# Expose Apps

In this chapter, we are going to talk about exposing our applications using services.

We'll start by talking about a `ClusterIP` service. This allows us to expose our application inside of the cluster only.

A `NodePort` will create a `ClusterIP` and then also, get a high number port from the node. This allows us then to expose
our applications internally on a low number port, and externally, but only on a high number port.

The use of a `LoadBalancer` first create a `NodePort` on our behalf. The difference is it also sends and asynchronous request to a cloud
provider to make use of a `LoadBalancer`.

If we not using a cloud provider, or if a load balancer is not avaialable, it continuous to run as a `NodePort`.

The fourth service that we are going to discuss is called `ExternalName`. This is useful for handling requests to an outside
DNS resource, instead of one inside of the cluster.

This is helpful if you were in the process of moving your applicaiton from outside of the cluster inside.

We'll also discuss the configuration of an Ingress Controller. The two reasons that you might want to use Ingress Controller is, for example,
if you have thousands of services, having them independent can become difficult to manage, and wastfull of resources.

You can then consolidate it to a single Ingress Controller. Or multiple Ingress Controllers if you want more flexibility.

The second reason is an Ingress Controller allows you to expose a low numbered port to your application.

Without that, you could get there, but you'd have to use iptables, which could become difficult and not terribly flexible to manage.

## Learning Objectives

- Use of services to expose to application
- Understand the ClusterIP service
- Configure the NodePort service
- Deploy the LoadBalancer service
- Discuss the ExternalName service
- Understand an ingress controller

## Service Types

Serivces can be of the following types:

- ClusterIP
- NodePort
- LoadBalancer
- ExternalName

The `ClusterIP` service type is the default, and only provides access internally(except if manually create an external endpoint). The range of ClusterIP used is
defined via an API server startup option.

The `NodePort` type is great for debugging, or when a static IP address is necessary, such as opening a particular address through a firewall. The NodePort
range is defined in the cluster configuration.

The `LoadBalancer` service was created to pass requests to a cloud provider like GKE or AWS. Private cloud solutions, also may implement this
service type if there is a cloud provider plugin, such as with `CloudStack` and `OpenStack`. Even without a cloud provider, the address is made
available to public traffic, and packets are spread among the Pods in the deployment automatically.

A newer service is `ExternalName`, which is a bit different. It has no selectors, nor does if define ports or endpoints. It allows the return of an
alias to and external service. The redirection happens at the DNS level, not via a proxy or forward. This object can be useful for services not yet
brought into the K8s cluster. A simple change of the type in the future would redirect traffic to the internal objects.

The `kubectl proxy` command creates a local service to acces a ClusterIP. This can be useful for troubleshooting or development work.

## Service Update Patterns

Labels are used to deretmine which Pods should receive traffic from a service. Labels can be dynamically updated for an object, which may effect
which Pods continue to connect to a service.

The default update pattern is for a rolling deployment, where new Pods are added, with different versions of an application, and due to automatic
load balancing, receive traffic alogn with previous versions of the application.

Shoud there be a difference in applications deployed, such taht clients would have issues communicating with different versions, you may consider
a more specific label for the deployment, which includes a version number. When the deployment creates a new replication controller for the update,
the label would not match. Once the new Pods have been created, and perhaps allowed to fully initialize, we would edit the labels for which
the Service connects. Traffic would shift to the new and ready version, minimizing client version confusion.

```sh
kubectl expose deployment/nginx --port=80 --type=NodePort
```

Typically, a service creates a new endpoint for connectivity. Should you want to create the service, but latter add the endpoint, such as connecting to
a remote database, you can use a service without selectors. This can also be used to direct the service to another service, in a different namespace or cluster.

## ClusterIP

For itner-cluster communication, frontends talking to backends can use `ClusterIPs`. These addresses and ednpoints only work withi the cluster.
`ClusterIP` is the default type of service created.

```yaml
spec:
  clusterIP: 10.108.95.67
  ports:
  - name: "443"
    port: 443
    protocol: TCP
    targetPort: 443
```

## NodePort

NodePort is a simple connection from a high-port routed to a `ClusterIP` using iptables, or ipvs in newer versions. The creation of a NodePort
generates a `ClusterIP`. Tfaffic is routed from the `NodePort` to the `ClusterIP`. Only high ports can be used, as declared in the source code.
The NodePort is accessible via calls `NodeIP`:`NodePort`

```yaml
spec:
  clusterIP: 10.108.191.46
  externalTrafficPolicy: Cluster
  ports:
  - nodePort: 31070
    port: 80
    protocol: TCP
    targetPort: 800a0
  selector:
    io.kompose.service: nginx
  sessionAffinity: Node
  type: NodePort
```

## LoadBalancer

Creating a load balancer service generates a NodePort, which then creates a ClusterIP, It also sens an async call to an external load balancer,
typically supplied by a cloud provider. The `External-IP` value will remain in a `Pending` state until the load balancer returns. Should it not
return, the `NodePort` created acts as it woul otherwise.

```yaml
Type: LoadBalancer
loadBalancerIP: 12.45.105.12
clusterIP: 10.5.31.33
ports:
- protocol: TCP
  port: 80
```

## External Name

The use of an `ExternalName`, which is a special type of service without selectors, is to point to an external DNS server. USe of the service
returns a CNAME record. Working with the ExternalName service is handy when  using a resource external to the cluster, perhaps prior to
full intergration.

```yaml
spec:
  type: ExternalName
  externalName: ext.db.example.com
```

## Ingress Resource

An ingress resource in an API object containing a list of rules matched against all incoming requests. Only HTTP rules are currently supported.
In order for the controller to direct traffic to the backend, the HTTP request must match both the host and the path declared in the ingress.

## Ingress Controller

Handling a few services can be easilty done. However, managing thousands or ten of thousands of services can create inefficiences. The use of an
Ingress Controller manages ingress rules to route traffic to existing services. Ingress can be used for fat out to services, name-based hosting, TLS,
or load balancing.

