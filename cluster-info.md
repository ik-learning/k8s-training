# Cluster information

https://kubernetes.io/docs/setup/pick-right-solution/

## Cluster Design

  * [Cluster Design](#cluster-design)
  * [Purpose](#purpose)
    + [Eduction](#eduction)
    + [Development & Testing](#development---testing)
  * [Hosting Production Applications](#hosting-production-applications)
  * [Cloud or OnPrem](#cloud-or-onprem)
  * [Storage](#storage)
  * [Nodes](#nodes)
  * [Workload](#workload)


## Purpose

### Eduction

- Minikube
- Single node cluster with kubeadm/GCP/AWS

### Development & Testing

- Mulit-node cluster with a Single Master and Multiple workers
- Setup using kubeadm tool to kuick provision on GCP or AWS or AKS

## Hosting Production Applications

- High Availability Multi Node cluster with multiple master nodes
- Kubeadm or GCP or Kops on AWS or other supported platform
- Upto 5000 nodes
- Upto 150,000 PODs in the cluster
- Upto 300,000 Total Containers
- Upto 100 Pod per Node

## Cloud or OnPrem

- Use Kubeadm fro on-prem
- GKE for GCP
- Kops for AWS
- Azure Kubernetes Service(AKS) for Azure

## Storage

- High Performance - SSD Backend Storage
- Multiple Concurrent connections - Network Based storage
- Persistent shared volumes for shared access across multiple PODs
- Label nodes with dpecific disk types
- Use Node Selectors to assign applications to nodes with specific disk types

## Nodes

- Virtual or Physical Machines
- Minimum of 4 Node Cluster (Size based on workloads)
- Master vs Worker Nodes
- Linux X86_64 Arcthitecture

## Workload

- How many?
- What kind?
  -- Web
  -- Big Data/Analytics
- Application Resource Requirements
  -- CPU Intensive
  -- Memtory Intensive
- Traffic
  -- Heavy Traffic
  -- Burst Traffic

 ## Choosing Infrastructure

- Laptop
- Single/Multi Node cluster

### Turnkey Solutions

- Provison required VMs
- Use Tools/Scripts

- You provsiion VMs
- You Configure VMs
- You use Scripts to Deploy Cluster
- You Maintain VMs yourself

Solitions

 - [X] OpenShift
 - [V] Cloudfoundry Container Runtime
 - [V] Cloudfoundry PKS on AWS,VMware,Azure and GCP
 - [V] Vagrant

### Hosted Solutions (Managed)

* Kubernetes-As-A-Service
* Provider provision VMs
* Provider installs Kubernetes
* Provider mainstains Web

Solitions

- [X] Google Container Engine (GKE)
- [V] Openshift Online
- [V] Aure Kubernetes Service
- [V] Amazon EKS

## Choosing a Network Solutions

https://kubernetes.io/docs/concepts/cluster-administration/networking/#how-to-implement-the-kubernetes-networking-model

## ETCD Deployment Strategies

### Stacked Topology

- [V] Easier to setup
- [V] Easier to manage
- [V] Fewer Servers
- [X] Risk during failures

### External ETCD Topology

- [V] Less Risky
- [X] Harder to setup
- [X] More Servers

## Fault Tolerance For HA Setup

`Quorum = N / 2 + 1`

| Managers | Majority | Fault Tolerance | Recomended |
|--|--|--|--|
| 1  | 1 | 0 ||
| 2  | 2 | 0 ||
| 3  | 2 | 1 |V|
| 4  | 3 | 1 ||
| 5  | 3 | 2 |V|
| 6  | 4 | 2 ||
| 7  | 4 | 3 |V|

## Cluster Sizing

It depends... in general, sizing your environment for a Docker Swarm Cluster is going to be the same process that you
would use for any application in you ecosystem.
You need to be shure that you understand when and how its going to be used.
You would need to consider things like:

### CPU, Memory and Disk

You containerized application will have the same requirements that it would if running on any other infrastructure (physical or virtual).
Be sure your underlying host(s) have the necesary horsepower

### Concurency

What are the load requirements of the application at peak and in total? These will determine optimal placement and the amound of hardware
resources(contraints) you need to allocate.

## Recomendations

- Plan for load Balancing
- Use External Certificate Authority for Production
- Performance considerations
- Take to account implementation
- Networking NATs
- CPU, Disk, Memory
- Managers and workers are going to communicate in,out and in bothd directions over TCP and UDP ports for variety of reasons

## Caveats

### Routing

Either you will have to expose the Docker applicatin/service via port redirection when you launch them OR you
will have to provide a routing mechanism(statically) to the container network on their hos(s)

### Port Redirection

As mentioned above, managing ports either through passing them directly through or redirecting them to the
underlying host on different ports, will affect how they behave in you environment

### Portability

Making sure taht data is external to the container application (on the host via a network share) can have
(sometimes significant) impacts on their performance

## Containers should Be..

### Abstract

You containerize an application so that it rematins removed from other components in the stack. That abstraction
makes updates easier, but does introduce additional potential areas that communication can fail.

### Portable

Applications that are containerized can be picked up and pul almost anywhere and will be consistent in their content and
behaviour. However, re-establishing communication with other components in the stack will depend on the new location
and how you have planned acccess to that resource.

### Flexible

Containers give you almost limiless flexibility. Be sure to try and refrain from launching you container services
tied too closely to external(and changeable) variables (hard coded related IP addresses or hostnames) not easily
changed


## Fault Tolerance Consideration

- Immediately replaces failed nodes
- Distribute management nodes for High Availability
- Monitor Health
- Have a Backup and Recovery Plan for the Swarm

## HA Distribution Consideration

- Use a Minimum of 3 Availability Zones to Distribute Managers
- Run `Manager Only` Nodes
- Force rebalance after restart