# Deployment

In this chapter, we are going to cover some of the typical tasks necessary for full application
deployment inside of Kubernetes

We will begin by talking about attaching storage to our containers. Be default, storage would only last
as long as the container using it.
Through the use of PersistentVolumes and Persistent Volume claims, we can attach storage such that it lives longer
than the container and the pod the container runs inside of.
We'll cover adding dynamic storage, which might be made available from a cloud provider, and we will
talk about ConfigMaps and secrets.

These are ways of attaching configuraiton information into our containers in a flexible manner. They are
ingested in almost the exact same way. The difference between them, currently, is a secret is encoded.
There are plans for it to be encrypted in the future.

We will also talk about how do we update our applications. We ca do a rolling update, where there's always some
containers available for response to client requests, or update all of them at once.

We also cover hot wo rollback an application to a previous version, looking at our entire history of updates,
and choosing a particular one.

## Learning Objectives

- Understand and create persistent volumes
- Configure persistent volume claims
- Manage volume access modes
- Deploy an application with access to persistent storage
- Discuss the dynamic provisioning of storage
- Configure secrets and ConfigMaps
- Update a deployment application
- Roll back to a previous version

## Volume Overview

Container engines have traditionally not offered storage that outlives container. As containers are considered transient, this could
leat to a loss of data, or complex exterior storate options. A K8s `volume` shared the Pod lifetime, not the containers within. Should a
container terminate, the data would continue to be available to the new container.

A `volume` is a directory, possibly pre-populated, made available to containers in a Pod. The creation of the directory, the backend storage
of the data and the contents depends on the volumetype. As of `v1.8`, there are 25 different volume types ranging from `rbd` to gain access to
Ceph, to `NFS`, to dynamic volumes from a cloud provider like Google's `gcePersistentDisk`. Each has particular configuraiton options and
dependencies.

An `alpha` feature to `v1.9` is the `Container Storate Interface CSI` with the goal of an industry standard interface for container orchestration
to allow access to arbitrary storage systems. Currently, volume plugins are "in-tree", meaining they are complied and build with the core K8s
binaries. This `out-of-tree` object will allow storage vendors to develop a single driver and allow the plugin to be containerized. This will
replace the existing `Flex` plugin which requires elevated access to the host node, a large security concert.

Should you want your storage lifetime to be distinct from a Pod, you can use `Persistent Volumes`. These allow for empty or pre-populated volumes
to be claimed by a Pod using a `Persistent Volume Claim`, they outlive the Pod. Data inside the volume could then be used by another Pod, or as
a means of retrieving data.

There are two API Objects which exists to provide data to a Pod already. Encoded data can be passed during a `Secret` and non-encoded data
can be passed with a `ConfigMap`. These can be used to pass important data like SSH keys, pahhphrase, or even a configuration file like `/etc/hosts`.

## Introducing Volumes

A Pod specification can declare one or more volumes and where they are made available. Each require a name, a type, and a mount point. The same
volume can be made available to multiple containers within a Pod, which can be a method of container-to-container communication. A volume can be
made available to multiple Pods, with each given an `access mode` to write. There is no concurrency checking, which means data corruption
is probable, unless outside locking takes place.

A particular `access` mode is part of a Pos request. As a request, the user may be granted more, but not less access, though a direct match is
attempted first. The cluster groups volumes with the same mode together, then sorts volumes by size, from smallet to largest. The claim is
checked against each in that access mode goupd, untill a volume of sufficient size matches. The three access modes are `RWO (ReadWriteOnce)`, which
allows read-write by a single noe, `ROX (ReadOnlyMany)`, which allows read-only by multiple nodes, and `RWX(ReadWriteMany)`, which allows read-write by many nodes.

When a volume is requested, the local `kubelet` uses the `kubelet_pods.go` script to map the raw devices, determine and make the mount point for the container, then create the symbolic link on the host node filesystem to associate the storate to the container. The API server makes a request for the
storage to the `StorageClass` plugin, but the specifics of the requests to the backend storage depends on the plugin in use.

If a request for a particular `StorageClass` was not made, the the only parameter used will be access mode and size. The volume could come from any
of the storage types available, and there is no configuraiton to determine which of the available ones will be used.

## Volume Spec

One of the many types of storage available is an `emptyDir`. The kubelet will create the directory in the container, but not mount any storage.
Any data created is written to the shared container space. As a result, it would not be persistent storage. When the Pod is destroyed, the directory
would be deleted along with the container.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox
  namespace: default
spec:
  containers:
    - image: busybox
      name: busy
      command:
        - sleep
        - "3600"
      volumeMounts:
        - mountPath: /scratch
          name: scratch-volume
  volumes:
    - name: scratch-volume
      emptyDir: {}
```

The YAML file above woul create a Pod with a single container with a volume named `scratch-volume` creaetd, which would create the
`/scratch` directory inside the container.

## Volume Types

There are several types that can use to define volumes, each with their pros and cons. Some are local, and many make use of network-based resources.

In `GCE` and `AWS`, you can use volumes of type `GCEpersistentDisk` or `awsElasticBlockStore`, which allows you to mount `GCE` and `EBS` disks in your
Pods, assuming you have already set up accounts and priviledges.

`emptyDir` and `hostPath` volumes are easy to use. As mentioned, `emptyDir` is an empty directory that gets erased when the Pod dies, but is
recreated when the container restarts. The `hostPath` volume mounts a resource from the host node filesystem. The resource could be a directory, file
socket, character, or block device. These resorces must already exist on the host to be used. There are two types, `DirectoryOrCreate` and `FileOrCreate`, which create the resource on the host, and use them if they don't already exist.

`NFS (Network File System)` and `iSCSI (Internet Small Container System Interface)` are straightforward choices for multiple readers scenarios.

`rbd` for block storage or `CepthFS` and `GlusterFS`, if available in you K8s cluster, can be a good choice for multiple writer needs.

Besides the volume types we just mentioned, there are many other possible, with more beind added: `azureDisk`, `azureFile`, `csi`,
`downwardAPI`, `fc (fibre channel)`, `flocker`, `gitRepo`, `local`, `projected`, `portworkxVolume`, `quobyte`, `scaleIO`, `secret`, `storageos`,
`vsphereVolume`, `peristentVolumeClaim`, and etc.

## Shared Volume Example

The following example create a pod with two containers, both with access to a shared volume:

```yaml
containers:
  - name: busy
    image: busybox
    volumeMounts:
      - name: test
        mountPath: /busy
  - name: busy
    image: busybox
    volumeMounts:
      - name: box
        mountPath: /box
      - name: test
        emptyDir: {}
```

or create with commands

```sh
kubectl exec -ti busybox -c box -- touch /box/foobar
kubectl exec -ti busybox -c busy -- ls -la /busy
```

You could use `emptyDir` or `hostPath` easily, since those types do not require any additional setup, and will work in you K8s cluster.

Note that one container wrote, and the other container had immediate access to the data. There is nothing to keep the contaieners from
overwriting the other's data . Locking or versioning considerations must be part of the application to avoid corruption.

## Persistent Volumes and Claims

A `persistent volume (pv)` is a storage abstraction used to retain data longer then the Pod using it. Pods define a volume of type
`persistentVolumeClaim (pvc)` with various parameters for size and possibly the type of backend storage known as its `StorageClass`. The cluster
then attaches the `persistentVolume`.

K8s will dynamically use volumes that are available, irrespective of its storage type, allowing claims to any backend storage.

There are serveral phases to persistent storage:

- `Provisioning` can be from `pvc` created in advance by the cluster administrator, or requested from a dynamic source, such as the cloud provider.
- `Binding` occurs when a control loop on the master notices the `PVC`, containing an amount of storage, access request, and optionally, a
  particular `StorageClass`. The watcher locates a matching `PV` of waits for the `StorageClass` provisioner to crete one. The `pv` must match
  at least the storage amount requested, buy may provide more.
- The `use` phase begins when the bound volume is mounted for the Pod to use, which continues as long as the Pod requires.
- `Releasing` happens when the Pod is done with the volume and an API request is sent, deleting the `PVC`. The volume remains in the state from
  when the claim is deleted until available to a new cliam. The resident data remains depending on the `persistentVolumeReclaimPolicy`
- The `reclaim` phase has three options:
  - `Retain` , which keeps the data intact, allowing for an administrator to handle the storage and data
  - `Delete` tells the volume plugin to delete the API object, as well as the storage behind it.
  - The `Recycle` option runs an `rm -rf /mountpoint` and then makes it avaialble to a new claim. With the stability of dynamic provisioning,
    the `Recycle` option is planned to be deprecated.

`PersistentVolume` with `hostPath` type

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: 10Gpv01
  labels:
    type: local
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/somepath/data01"
```

Each type will have own configuration settings. For example, an already created Ceph or GCE Persistence Disk would not need to be configured,
but could be claimed from the provider.

Persistent volumes are cluster-scoped, but persistent volume claims are namespace-scoped. An alpha feature since v1.11, this allows for
static provisioning of Raw Block Volumes, which currently support the Fibre Channel Plugin. There is a lot of development and change in this area,
with plugins adding dynamic provisioning.

With a persistent volume created in you cluster, you can then write a manifest for a claim and use that claim in you pod definition. In the Pod, the
volume uses the `persistentVolumeClaim`

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 8Gi
```

In the Pod

```yaml
spec:
  containers:
    volumes:
      - name: test-volume
        persistentVolumeClaim:
          claimName: myclaim
```

The Pod configuration can be complex as this

```yaml
volumeMounts:
  - name: Cephd
    mountPath: /data/rbd
volumes:
  - name: rbdpd
    rbd:
      monitors:
        - "10.19.14.22:6789"
        - "10.19.14.23:6789"
        - "10.19.14.24:6789"
      pool: k8s
      image: client
      fsType: ext4
      readOnly: true
      user: admin
      keyring: /etc/ceph/keyring
      imageformat: "2"
      imagefeatures: "layering"
```

## Dynamic Provisioning

While handling volumes with a persistent volume definition adn abstracting the storage provider using a claim is powerfull, a cluster administrator
still needs to create those volumes in the first place. Starting with Kubernetes v1.4 `Dynamic Provisioning` allowed for the cluster to request
storage from an exterior, pre-configured source. API calls made by the appropriate plugin allow for a wide range of dynamic storage use.

The `StorageClass` API resource allows an administrator to define a persistent volume provisioner of a certain type, passing storage-specific
parameters.

With a `StorageClass` created, a user can request a claim, which the API Server fills via auto-provisioning. The resource will also be reclaimed as
configured by the provider. `AWS` and `GCE` are common choices for dynamic storage, but other options exists, such as a `Ceph` cluster or `iSCSI`.
Single, default class is possible via annotation.

Here is an example of a `StorageClass` using GCE.This example demonstrates how to restrict the topology of provisioned volumes to specific zones and should be used as a replacement for the zone and zones parameters for the supported plugins.

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: anyname
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-standard
volumeBindingMode: WaitForFirstConsumer
allowedTopologies:
  - matchLabelExpressions:
      - key: failure-domain.beta.kubernetes.io/zone
        values:
          - us-central1-a
          - us-central1-b
```

## Secrets

Pods can access local data using volumes, but there is some data you don't want readable to the naked eye. Passwords may be an example. Someone
reading through a YAML file may read a password and remember it. Using the Secret API resource, the same password could be encoded. A casual
reading would not give away the password. You can create, get or delete secrets.

```sh
kubectl get secrets
```

Secrets can be manually encoded with

```sh
kubectl create secret generic --help
kubeclt create secret generic mysql --from-literal=password=root
```

A secret is not encrypted by default, only `base64` encoded. You can see the encoded string inside the secret with `kubectl`. The secret will be decoded
and be presented as a string saved to a file. The file canbe used as an environment variable or in a new directory, similar to the presentation volume.

In order to encrypt secrets, you must create an `EncryptionConfiguration` object with a key and proper identity. Then, the `kube-apiserver` needs the
`--encryption-provider-config` flag set to a previously configured provider, such as `aescbc` or `ksm`. Once this is enabled, you need to
recreate every secret, as they are encrypted upon write. Multiple keys are possible. Each key for a provider is tried during dencryption. The first key
of the first provider is used for encryption. To rotate keys, first create a new key, restart (all) kube-apiserver processes, then recreate every
secret.

Create manually a secret and insert into a YAML file

```sh
echo LFTr@1 | base64
> TEZUckAxCg==
```

`secret.yaml`

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: LF-secret
data:
  password: TEZUckAxCg==
```

### Secrets as Environment Variables

A secret can be used as an environment variable in a Pod. You can see one being configured in the following example:

```yaml
---
spec:
  containers:
    - name: mysql
      image: myslq:5.5
      env:
        - name: SECRET_USERNAME
          valueFrom:
            secretKeyRef:
              name: mysql
              key: username
        - name: SECRET_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql
              key: password
```

There is no limit to the nubmer of Secrets used, but there is a `1MB` limit to their size. Each secret occupies memory, along with other API objects,
so very large number of secrets

They are stored in the `tmpfs` storage on the host node, and are only sent to the host running Pod. All volumes requested by a Pod must be
mounted before the containers within the Pod are started. So, a secret must exist prior to being requested.

### Mounting Secrets as Volumes

You can also mount secrets as files using a volume definition in a pod manifest. The mount path will contain a file whose name will be the key of the
secret created with the `kubectl create secret` step.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: busy
      image: busybox
      volumeMounts:
        - name: mysql
          mountPath: "/mysqlpwd"
          readOnly: true
  volumes:
    - name: foo
      secret:
        secretName: mysql
```

Once the pod is running, you can verify that the secret is indeed accessible in the container:

```sh
kubectl exec -ti busybox -- cat /mysqlpwd/password
```

## ConfigMaps

ConfigMaps can be consumed in various ways:

- Pod environment variables from single or multiple `ConfigMaps`
- Use `ConfigMaps` values in Pod commands
- Populate Volume from `ConfigMap`
- Add `ConfigMap` data to specific path in Volume
- Set file names and access mode in Volume from `ConfigMaps` data
- Can be used by system components and controllers

### ConfigMaps portable Data

A similar API resource to Secrets is the ConfigMap, except the data is not encoded. In keeping with the concept of decoupling in K8s,
using a ConfigMap decouples a container image from configuration artifacts.

They store data as sets of key-value pairs or plain configuration files in any format. The data can come from a collection of files or all files
in a directory. It can also be populated from a literal value.

A `ConfigMap` can be used in several different ways. A Pod can use the data as environment variables from one or more sources. The values contained
inside can be passed to commands inside the pod. A Volume or a file in a Volume can be created, including different name and particular access modes.
In addition, cluster components like controllers can use the data.

Let's say you have a file on you local filesystem called `config.js`. You can craet a `ConfigMap` that contains this file. The `configMap` object will
have a `data` section containing the contect of the file:

```sh
kubectl get configmap foobar -o yaml
```

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: foobar
  namespace: default
data:
  config.js: |
    {
      "key": 1
    }
```

### Using ConfigMaps

Like secrets, you can use `ConfigMaps` as environment variables or using a volume mount. They must exists prior to being used by a Pod, unless
marked `optional`. They also reside in a specific namespace.

In the case of environment variables, you pod manifest will use `valuesFrom` key and the `configMapKeyRef` value to read the values. For instance

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: special-config
  namespace: default
data:
  SPECIAL_LEVEL: very
  SPECIAL_TYPE: charm
  special.how: very
```

Volume:

```yaml
volumes:
  - name: config-volume
    configMap:
      # Provide the name of the ConfigMap containing the files you want
      # to add to the container
      name: special-config
restartPolicy: Never
```

Environment:

```yaml
containers:
  - name: test-container
    image: k8s.gcr.io/busybox
    command: ["/bin/sh", "-c", "env"]
    env:
      # Define the environment variable
      - name: SPECIAL_LEVEL_KEY
        valueFrom:
          configMapKeyRef:
            # The ConfigMap containing the value you want to assign to SPECIAL_LEVEL_KEY
            name: special-config
            # Specify the key associated with the value
            key: special.how
restartPolicy: Never
```

## Deployment Configuration Status

The `Status` output is generated when the information is requested:

```yaml
status:
  availableReplicas: 2
  observedGeneration: 2
  readyReplicas: 2
  replicas: 2
  updatedReplicas: 2
```

The output above shows what the same deployment were to look like if teh number of replicas were increased to two. The times are different than
when the deployment was first generetated.

- `avaialbleReplicas`; indicates how many were configured by the `ReplicaSet`. This would be compared to the later value of `readiReplicas`, which would be used to determine if all replicas have been fully generated and without error.
- `observedGeneration`; shows how often the deployment has been updated. This information can be used to understand the rollout and rollback situation of the deployment

## Scaling and Rolling Updates

The API server allows for the configuration settins to be updated for most values. There are some immutable values, which may be different depending
on the version of K8s you have deployed.

A common update is to change the number of replicas running. If this number is set to zero, there would be no containers, but there would still be a
`ReplicaSet` and `Deployment`. This is the backend process when a `Deployment` is delted.

```sh
kubectl scale deploy/dev-web --replicas=4
> deployment scaled
kubectl get deployments
```

Non-immutable values can be edited via a text editor, as well. Use `edit` to trigger an update. For example, to change the deployed version of the `nginx` web server to an older version:

```sh
kubecl edit deployment nginx
---
containers:
  - image: nginx:1.8 #<<--- Set to and older version
    imagePullPolicy: IfNotPresent
    name: dev-web
---
```

This would trigger a rolling update of the deployment. While the deployment would show an older age, a review of the Pods would show a recent
update and older version of the web server application deployed.

## Deployment Rollbacks

With all the `ReplicaSets` of a Deployment being kept, you can also roll back to a previous revision by scaling up and down the `ReplicaSets` the other way. Next, we will have a closer look at rollbacks, usng the `--record` option of the `kubectl run` command, which allows annotation in the resource definition

```sh
kubectl run ghost --image=ghost --record
kubectl get deployments ghost -o yaml
---
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
    kubernetes.io/change-cause: kubectl run ghost --image=ghost --record=true
  generation: 1
---
```

Should an update fail, due to improper image version, for example, you can rollback the change to a working version with `kubectl rollout undo`

```
kubectl set image deployment/ghost ghost=ghost:09 --all
> NAME                     READY   STATUS
> ghost-5585c8d96c-dcrc6   0/1     ErrImagePull
kubectl rollout history deployment/ghost
> REVISION  CHANGE-CAUSE
> 1         kubectl run ghost --image=ghost --record=true
> 2         kubectl run ghost --image=ghost --record=true
kubectl rollout undo deployment/ghost
```
You can roll back to a specific revision with the `--to-retrieve=2` option.
You can also edit a Deployment using the `kubectl edit` command.
You can also pause a Deployment, and then resume.
```sh
kubectl rollout pause deployment/ghost
kubectl rollout resume deployment/ghost
```

`ReplicaController` change with `kubectl rolling-update` command will work but only if client is open.


























