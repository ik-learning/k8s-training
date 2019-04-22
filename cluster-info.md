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

