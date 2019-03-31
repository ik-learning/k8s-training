# Build Application

In this chapter, we are going to deploy our new Python application into our
Kubernetes cluster. We'll firt containerie it, using Docker commands, then create
and use our own local registry. After testing that the resistry is avaialbe to all of our
nodes, we will deploy our application in a multi-container pod.

== Learning Objectives ==

By the end of this chapter, you should be able to:

- Learn about runtime and container options
- Containerize an applicaion
- Host a local repository
- Deploy a multi-container pod
- Configure a readinessProbes
- Configre livenessProbes

## Containerd

The intent of the `containerd` project is not to build a user facing tool;instead it is focused on exposing hightly focused
low-level primitives:
- Defaults to runC to run containers according to the OCI Specifications
- Intended to be embedded into a larger systems
- Minimal CLI, focused on debugging and development

With a focus on supporting the low-level, or backend plumbing of containers, this project is better suited to integration and operation
teams building specialized products, instead of typical build, ship, and run applicaion.

## Containerizing an Application

 To containerize an applicaion, you beging by creating your applicaion. Not all applicaions do well with containerization. The more
stateless and transient the application, the better. Also, remove any environmental configuraion, as those can be provided using other tools, like ConfigMaps. work on the application untill you have a single build artifact, which cat be deployed to multiple environments without
needing to be changed. Many legacy applications become a series of objects and artifacts, residing among multiple containers.

## Creating a Deployment

 Once you can push and pull images using the `docker` command, try to run a new deployment inside Kubernetes using the image. The string
passed to the `--image` argument includes the repository to use, the name of the applicaiton, then the version

Use `kubectl run` to test the image
```
kubectl run <Deploy-Name> --image<repo>/<app-name>:<version>
```

## Running command in a Container

 Part of the testing may be to execute commands within the Pods. What commands are avaiable depend on what was included in the base
environment when the image was created. In keeping to a decoupled and lean design, it's possible that there is no shell, or that the Born shell
is available instead of `bash`. After testing, you may want to revisit  the build and resources necessary for testing and production.

Use the `-it` option for an interactive shell instead of the command running without interaction on access.

If you have more thean one container, declare which container:

```
kubectl exec -it <Pod-Name> -- /bin/bash
```

## Multi-Container Pod

 It may not make sense to recreate an entire image to add functionality like a sehll or logging agent. Instead, you could add
another container ot the pod, which would provide the necessary tools.

 Each container in the pod should be transient and decoupled. If adding another container limits the scalability or transient nature of
the original application, then a new build may be warranted.

## readinessProbe

 Oftentimes, out application may have to initialize or be configured prior to being ready to accept traffic. As we scale up our application,
we may have containers in various state of creation. Rather than communicate with a client prior to being fully ready, we can use a
`readinessProbe`. The container will not accept traffic until the probe returns a healthy state.

 With the `exec` statement, the container is not considered ready untill a command returns a zero exit code. As long as the return is non-zero, the container
is considered not ready and the probe will keep trying.
 Another type of probe uses an HTTP GET request (httpGet). Using a defined header to a particular port and path, the container is not considered healthy
untill the web server returns a code `200-399`. Any other code indicates failure, and the probe will try again.
The TCP Socket probe (tcpSocket) will attempt to open a socket on a predefined port, and keep trying based on `periodSeconds`. Once the port can be opened the container is considered healthy.

## livenessProbe

Just as a we want for a container to be ready for traffic, we also want to make sure it stays in a healthy state. Some applications may not have build-in checking, so we can use `livenessProbes` to continually chech the health of a container. If the containeris found to fail a probe, it is terminated. If under a controller, a replacement would be spawned.

Both probes are often configured into a deployment to ensure applications are ready for traffic and remain healthy.
















