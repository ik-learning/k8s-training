# Security Chapter

 In the Security chapter, we are goingto talk about how an API call is ingested into
the cluster.
 We will go through the details of the three different phases each
call goes through. We'll look at the different types of authentication that are
available to us, and work with RBAC, which handles the authorization on our behalf.

 We also configure pod policies. The use of pod policy allows us to configure the deatils of what a container can do, and
how processes run with that container. We'll finish by understanding a network policy. If the netwok plugin honors a network policy,
this allows you to isolate a pod from other pods in the environment.

 The deault kubernetes architecture says that all pods should be able to see all pods. So, this is a change from that historic
 approach. But as we use it in a produciton, you may want to limit ingress or egress traffic to a pod.

 ## Learning Objectives

- Explain the flow of API requests
- Configure authorization rules
- Examine authentication policies
- Restrict network traffic with network policies

## Overview

Security is a big and complex topic, especially in a distributed system like k8s. This, we are just going to cover some of the
concepts taht deal with security in the context of K8s.

The, we are going to focus on the authentication aspect of the API server and we will dive into authorization, looking at things like
ABAC and RBAC, which is now the default configuration when you bootstrap a K8s cluster with `kubeadmin`.

We are going to look at the `admission control system`, which lets you look at the and possibly modify the request that are coming in,
and do a final deny or accept on those requests.

Following that, we're going to look at a few other concepts, including how you can secure you Pods more tightly using security contexts and
pod security policies, which are full-fledged API objects in Kubernetes.

Finally, we will look at network policies. By default, we tend not to torun on network policies, which let any traffic flow through all of
our pods, in all the different namespaces. Using network policies, we can actually define ingress rules so that we can restrict the ingress
traffic between the different namespaces. The networktool in use, such a `Flannel` or `Calico` will determine if a network policy can be
implemented. As K8s becombe more mature, this will becoma a strongly suggested configuration.

## Accessing the API

To perform any action a K8s cluster, you need to access the API and go through three main steps:
- Authentication
- Authorization (ABAC or RBAC)
- Admission Control

Thes steps are described in more detail in the official documentaion about [controlling access](https://kubernetes.io/docs/reference/access-authn-authz/controlling-access/) to the API.

Once a request reaches the API server securely, it will first go through any authentication module that has been configured. The request can be
rejected if authentication fails or it gets authenticated and passed to the authorization step.

At the authorization step, the request will be checked against existing policies. It will be authorized if the userhas the permissions to perform
the requested actions. Then, the requests will go through the last step of admission. In general , admission controllers will check the actual
content of the objects being created and validate them before admitting the request.

In addition to these steps, the requests reaching the API server over the network are encrypted using TLS. This need
to be properly configured using SSL certificates. If you use `kubeadm`, this configuration is done for you.

## Authentication

There are three main points to remember with authentication in K8s.
- In its straightforward form, authentication is done with certificates, tokens or basic authentication
- Users are not created by the API, but should be merged by an external system
- System accounts are used by processes to access the API

There are two more advanced authentication mechanisms: `Webhooks` which can be used to verify bearer tokens, and connection
with an external `OpenID` provider.

The type of authentication used is defined in the `kube-apiserver` startup options. Below are the four examples of a subset
of configuration options that would need to be set depending on what coice of authentication mechanism you choose:
```sh
--basich-auth-file
--oids-issuer-url
--token-auth-file
--authorization-webhook-config-file
```

One or mor Authentication Modules are used: x509 Client Certs; static token, bearer or bootstrap token, static password file,
service account and OpenID connect tokens. Each is tried until successful, and the other is not guaranteed. Anonymous access
can also be enabled, otherwise you will get a 401 response. Users are not created by the API, and should be managed by an external
system.

## Authorization

Once a request is authenticated, it needs to be authorized to be able to be processed through the K8s system and perform its
intended action. There are three main modes and two global Deny/Allow settings. The trhee main modes are:
- ABAC
- RBAC
- WebHook

They can be configured as `kube-apiserver` startup options:
```sh
--authorization-mode=ABAC
--authorization-mode=BBAC
--authorization-mode=Webhook
--authorization-mode=AlwaysDeny
--authorization-mode=AlwaysAllos
```

The authorization modes implement policies to allow requests. Attribute of the requests are checked against the policies (e.g. user, group
namespace, verb).

## ABAC

ABAC stands for Attribute Based Access Control. It was the first authorization model in K8s that allowed administrators to implement
the right policie. Today, RBAC is becoming the default authorization mode.

Policies are defined in JSON file and referenced by by a `kube-apiserver` startup option:
```
--authorization-policy-file=my_policy.json
```
For example, the policy file shown below authorizes user Bob to read in the namespace `foobar`:
```json
{
  "apiVersion": "abac.authorization.kubernetes.io/v1beta1",
  "kind": "Policy",
  "spec": {
    "user": "bob",
    "namespace": "foobar",
    "resource": "pods",
    "readonly": true
  }
}
```

[other policy examples](https://kubernetes.io/docs/reference/access-authn-authz/abac/#examples)

## RBAC

RBAC stands for Role Based Access Control

All resources are modeled API objects in K8s, from Pods to Namespaces. They also belonging to API Group, such as core and apps.
These resources allow operations such as Create, Read, Update and Delete(CRUD), which we have been working with so far. Operations
are called verbs inside YAML files. Adding to these basic components, we will add more elements of the API, which can then be managed via
RBAC.

Rules are operations which can act upon an API group. Roles are a group of rules which affect, or scope, a single namespace, whereas
ClusterRole have a scope of the entier cluster.

Each operation can act upon one of three subjects, which are `User Accoutns` which don't exists as API objects, Service Accoutns, and Groups which
are known as `clusterrolebinging` when using `kubectl`.

RBAC is then writing rules to allow or deny operations by users, roles or groups upon resources.

## RBAC process overview

While RBAC can be complex, the basic flow is to create a certificate for a user. As a user is no an API object of K8s, we are requiring
outside authentication, such as OpenSSL certificates. After generating the certificate against the cluster certificate authority, we can
set that credential for the user using a `context`.

Roles can then be used to configure an association of `apiGroups`, `resources` and the verbs allowed to them. The user can then be bound
to a role limiting what and where they can work in the cluster.

Here is a summary of the RBAC process:
- Determine or creat namespace
- Create certificate credentials for user
- Set the credentials for the user to the namespace using a context
- Create a role for the expected task set
- Bind the user to the role
- Verify the user has limited access

## Admission Controller

The last step in letting an API request into Kubernetes is admission control.

Admission controllers are pieces of software that can access the content of the objects being created by the requests. They can modify the
content or validate it, and potentially deny the request.

Admission contraollers are needed for certain features to work properly. Controllers have been added as K8s matured.
```sh
--admission-control=Initializers,NamespaceLifecycle,LimitRanger,\
ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,\
NodeRestriction,ResourceQuota
```

The first controller is `Initializers` which will allow the dynamic modification of the API request, providing great flexibility. Each
admission controller funcationality is explained in the documentation. For example, the `ResourceQuota` controller will ensure that the
object created does not violate any of the existing quotas.

## Security Context

Pods and controllers within pods can be given specific security contraints to limit what processes runnning in containers do. For example the
UID of the process, the Linux capabilities, and the filesystem group can be limited.

This security limitation is called a security context. It can be defined for the entire pod or per container, and is represented as additional
sections in the resources manifests. The notable difference is that Linux capabilities are at the container level.

For example, if you want to enforce a policy that containers cannot run their process as the root user, you can add a pod security policy
context like the one below
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  securityContext:
    runAsNonRoot: true
  containers:
  - image: nginx
    name: nginx
```

Then, when you craete this pod, you wil see a warning that the container is trying to run as root and that it is not allowd. Hence, the Pod will never run:
```
kubectl get pods
> container has runAsRoot and image will run as root.
```

## Pod Security policies

To automate the enforcement of security contexts, you can define PodSecurityPolicies. A PSP is defined via a standard Kubernetes manifest following
the PSP API schema.

These policies are cluster-level rules taht goven what a pod can do, what they can access, what user they run as, etc.

For isntance, if you do not want any of the containers in your cluster to run as the root user, you can define a PSP to that effect.
You can also prevent containers from being priviledged or use the host network namespace, or the host PID namespace.

```yaml
apiVersion: v1
kind: PodSecurityPolicy
metadata:
  name: restricted
spec:
  seLinux:
    rule: RunAsAny
  supplementalGroups:
    rule: RunAsAny
  runAsUser:
    rule: MustRunAsNonRoot
  fsGroup:
    rule: RunAsAny
```

For pod security Policies to be enabled, you need to configure the admission controller of the `controller-manager` to contain
`PodSecurityPolicy`. These policies make even more sense when coupled with the RBAC configuration in you cluster. This will allow you to
finely tune what your users are allowed to run and what capabilities and low level priviledges their containers will have.

[Example](https://github.com/kubernetes/examples/blob/master/staging/podsecuritypolicy/rbac/README.md)

## Network Security Policies

By default, all pods can reach each other; all ingress and egress traffic is allowed. This has been a high-level networking requirement in
K8s. However, network isolation can be configured and traffic to pods can be blocked. In newer versions of K8s, egress traffic
can also be blocked, This is done by configuring a `NetworkPolicy`. As all traffic is allowd, you may want to implement a policy
that drops all traffic, then, other policies which allow desired ingress and egress traffic.

The `spec` of the policy can narrow down the effect to a particular namespace, which can be handy. Further settings include `podSelector` or
label, to narrow down which Pods are affected. Further ingress and egress settings declare traffic to and from IP addresses and ports.

Not all network providers support the `NetworkPolicies` kind. A non-exahustive list of providers with support includes `Calico`, `Romana`,
`Cillum`, `Kube-router` and `Weave-Net`.

In previous versions of kubernetes, there was a requirement to annotate a namespace as part of network isolation, specifically the
`net.beta.kubernetes.io/network-policy=value`. Some network plugins may still require this setting.

[Policy Recipes](https://github.com/ahmetb/kubernetes-network-policy-recipes)

Only pods with the label of `role: db` will be affected by this policy, and the policy has both Ingress and Egress settings.
The ingress setting includes a `172.17` network, with a smaller range of `172.17.1.0` CIDR being excluded from this traffic.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ingress-egress-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - ipBlock:
        cidr: 172.17.0.0/16
        except:
        - 172.17.1.0/24
    - namespaceSelector:
        matchLabels:
          project: myproject
    - podSelector:
        matchLabels:
          role: frontend
  - ports:
    - protocol: TCP
      port: 6379
  egress:
  - ports:
    - port: 5978
      protocol: TCP
  - to:
    - ipBlock:
        cidr: 10.0.0.0/24
```

These rules change the namespace for the following settngs to be labeled `project: myproject`. The affected Pods also would need to match
the label `role: frontend`. Finally, TCP traffic on port 6379 would be allowed from these Pods.

The egress rules have the `to` settings in this keys the `10.0.0.0/24` range TCP traffic to port 5978.

The use of empty ingress or egress rules denies all types of traffic for the included Pods, though this is not suggested. Use another dedicated
`NetworkPolicy` instead.

Note that there can also be complex `matchExpressions` statements in the spec, but this may change as `NetworkPolicy` matures

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```

Some network plugins, such as `WeaveNet` may require annoation of the Namespace. The following shows the setting of a `DefaultDeny` for the `myns`
namespace

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: myns
  annotations:
    net.beta.kubernetes.io/network-policy: |
      {
        "ingress": {
          "isolation": "DefaultDeny"
        }
      }
```
























