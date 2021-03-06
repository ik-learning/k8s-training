# Design

In the design chapter, we are going to talk about resource requirements for our applications, and the
ability to set limits for CPU, memory and storage in the root filesystem of the node.

We also going to talk about containers that can assist our primary application, such as a sidecar,
which is typically something that enchance the primary application.

For example, if our application does not include logging, we can add a second container to the pod,
to handle logging on our behalf.

And adapter container might comfort the traffic to match the other application or needs of our cluster.
This allows for full flexibility for the primary application, to remain generating the data that it does,
and not have to be modified to fit that particular cluster.

There is also an ambassador container, which is our representation to the outside world. It can act
as a proxy then, so that perhaps I might want to split inbound traffic; if it's a read, it goes to one
container, and for write, it goes to a different container, allowing me to optimize my environment and
my application.

We also consider other application desing concepts, that can be helpful in the planning stage for the
deployment of your application.

== Learning Objectives ==

By the end of this chapter, you should be able to:

- Define an application resource requirements
- Understand multi-container pod design patterns: Ambassador, Adapter, Sidecar
- Discuss application design concepts

## Traditional Applications Considerations

One of the larger hurdles towards implementing Kubernetes in a production environment is the suitability of applicaiton design. Optimal K8s
deployment design changes are more than just the simple containerization of an application. Traditional applications were built and deployed
with the expectations for long-term processes and strong interdependencies.

For example, an Apache web server allows for incredible customization. Often, the server would be configured and tweeked without interruption.
As demand grows, the application may be migrated to larger and larger servers. The build and maintanance of the application assumes the isntance
would run without reset and have persistent and tightly coupled connections to other resources, such as networks and storage.

In early usage of containers, applications were containerized without redevelopment. This leeds to issues after resources failure,
or upon upgrade, or configuration. The cost and hassle of redesign and re-implementation should be taken into account.

## Decoupled Resources

The use of decoupled resources as integral to Kubernets. Instead of an application using a dedicated port and socket, for the life
of the instance, the goal is for each component to be decoupled from other resources. The expectaion and software development towards
separation allows for each component to be removed, replaced and rebuild.

Instead of hard-coding a resource in an application, an intermediary, such as a Service, enables connection and reconeection to other
resources, proving flexibility. A single machine is no longer requried to meed the application and user needs; any number of systems
could be brought together to meet the needs when, and, as long as, necessary.

As a K8s grows, even more resources are being devided out, which allows for an easier deployment of resources. Also, K8s developers
can optimize a particular function with fewer considerations of other objects

## Transience

Equally important is the expectation of transience. Each object should be developed with the expectaions that other components
will die and be rebuild. With any and all resources planned for transient relationships to others, we can update versions
or scale usage in an easy manner.

An upgrade is perhaps not quite the correct term, as the existing application does not survive. Instead, a controller terminates the container
and deploys a new one to replace it, using a different version of the application or setting. Typically, traditional applications were
not written this way, option toward long-term relationships for efficiency and ease of use.

## Flexible Framework

Like a school of fish, or pod of whales, multiple independant resources working together, but decoupled from each other and
without expectaition of individual relationship, gaing flexibility, higher availability and easy scalability. Instead of a monolithic Apache
server, we can deploy a flexible number of `nginx` servers, each handling a small part of the workload. The goal is the same,
but the framework of the solution is distinct.

A decoupled, flexible and transient application and framework is not the most efficient. In order for the Kubernetes
orchestration to work, we need a series of agents, otherwise known as controllers of watch-loops, to constantly monitor
the current cluster state and make changes untill taht state matches the delcared configuration.

The commodization of hardware has enabled the use of many smaller servers to handle a larger workload, isntead of a single,
huge systems.

## Managing Resource Usage

As with any application, an understanding or resource usage can be helpful for a successful deployment. K8s allows us to easily
scale clusters, larget or smaller, to meet demand. An understanding of how the K8s clusters view the resources is an important
consideration. The `kube-scheduler` or a custom shceduler, uses the `PodSpec` to determine the best node for the deployment.

In addition to administrative tasks to grow or shrink the cluster or the number of Pods, there are `autoscalers` which add or remove
nodes or pods, with plans for one which uses `cgroup` settings to limit CPU and memory usage by individual containers.

By default, Pods uses as much CPU, and memory as the workload requries, behaving and coexisting with other Linux processes.
Through the use of resource `requests`, the scheduler will only schedule a Pod to a node if resource exist to meet all requests
on that node. The scheduler takes these and several other factors into account when selecting a node for use.

Monitoring the resource usage cluster wide is not included feature of Kubernetes. Other projects, like Prometheus, are used
instead. In order to view resource consumption issues locally, use the `kubectl describe pod`  command. You may know of
issues after the pod has been terminated.

## CPU

CPU requests are made in CPU inits, each unit being a millicore, using millie - the Latin workd for thousand. Some
documentation uses `millicore`, others both have the same meaning. Thus, a request for `.7` of a CPU would be `700` millicores.
Should a container use more resources than allowd, it won't be killed. The exact amount of overuse is not definite.

```yaml
spec:
	containers:
		resources:
			limits:
				cpu:
			requests:
				cpu:
```

The value of CPU is not relative. It does no matter how many exist, or if other Pods have requirements. One CPU, in Kubernetes,
is equivalent to:

- 1 AWS vCPU
- 1 GCP Core
- 1 Azure Core
- 1 Hyperthread on a bare-metal Intell processor with Hyperthreading

## RAM

With Docker engine, the `limits.memory` value is converted to an integer value and become the value to the `docker run --memory <value> <image>`
command. The handling of a container which exceeds its memory limit is not definite. It may be restarted, or if asks for more
that the memory request settings, the entire Pod may be evicted from the node

```yaml
spec:
	containers:
		resources:
			limits:
				memory:
			requests:
				memory:
```

## Ephemeral Storae

Container files, logs, and `EmptyDir` storage as well as K8s cluster data, reside on the root filesystem of the host node.
As storage is a limited resource, you may need to manage it as other resource. The scheduler will only choose a node with enough space
to meet the sum of all the container requests. Should a particular container, or the sum of the containers in a Pod, use more then
the limit, the Pod will be evicted.

```yaml
spec:
	containers:
		resources:
			limits:
				ephemeral-storage:
			requests:
				ephemeral-storage:
```

## Multi-Container Pods

The idea of multiple containers in a Pod goes ahead the architectural idea of decoupling as much as possible. One could
run an entire operating system inside a container, but would lose much of the granular scalability Kubernetes is capable of.
But there are certain needs in which a second or third co-located container makes sense. By adding a second container, each
container can still be optimized and developed independently, and bot can scale and be repurposed to best meet the needs of the
workload.

## Sidecar Container

The idea for a `sidecar container` is to add some functionality not present in the main container. Rather than bloading code,
which may not be necessary in other deployments, adding a container to handle a function such as logging solves the issue,
while remaining decoupled and scalable. Prometheus monitoring and Fluentd logging leverage sidecar containers to collect data.

## Adapter Container

The basic purpose of an `adapter container` is to modify data, either on ingress or egress, to match some other need. Perhaps,
an existing enterprise-wide monitoring role tools has particular data format needs. An adapter would be an efficient way to
standartize the output of the main container to be ingested by the monitoring tool, without having to modify the monitor or the
containerized application. An adapter container transforms multiple applications to a single view.

## Ambassador

An ambassador allows for access to the outside world without having to implment a service or another entry in an ingress controller.

- Proxy local connections
- Reverse proxy
- Limits HTTP requests
- Re-route from the container to the outside world

## Point to Ponder

A few things to carefully consider:
- Is my application decoupled as it could possible be? Is there anything that I could take out, or make its own container?
- Is each container transient, does it expect others to be transient?
- Can I scale any particular component to meet workload demand?
- Have I used the most open standard stable enough to meet my needs?

## Jobs

Jobs are part or the `bach` API group. They are used to run a set number of pods to completion. If a pod fails, it will
be restarted untill the number of completion reached.

While they can be sees as a way to do batch processing in Kubernetes, they can also be used to run one-off pods. A `Job`
spcecication have paralelism and a completion key. If ommited, they will be set to one. If they are present, the paralelism
number will set the number of pods that can run concurrently, and the completion number will set how many pods need to run
succesfully for the `Job` itself to be considered done. Several `Job` patterns can be implemented, like a traditional work queue.

`CronJobs` work in a similar manner to Linux jobs, with the same time syntax. There are some cases where a job would not be run
during a time period or could ru twice; as a result, the requested Pod should be idempotent.

An option `spec` field is `.spec.concurrencyPolicy` which determines how to handle existing jobs, should the time segment expire.
If set ot `Allow`, the default, another concurrent job will be run. If set to `Forbid`, the current job continues and the new-job
is skipped. A value of `Replace` cancels the current job and starts a new job in its place.



































































