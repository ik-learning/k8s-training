# Kubernetes Course (Developer Certification)

## Introduction

### Objectives

- Contanerize and deploy a new Python script
- Configure the deployment with ConfigMaps, Secrets and SecurityContexts
- Understand multi-container Pod design
- Configure probes for pod health
- Implement services and NetworkPolicies
- Use PersistentVolumeClaims for state persistence

## Architecture

 In this chapter, we are going to cover a little bit of the history of Kubernetes. This helps
to understand the why things are where they are. Then we talk about master nodes and the main agents
that work to make K8s what it is.
 We also talk about minion nodes. Those are the workers nodes that uses API calls back to the master
node to understand what the configuration should be, and report back status.
 We also talk about CNI network plugin configuration, which is new, but definately the future of
K8s.
 And well cover some common terms, so that, as you learn more about K8s, youll understand which each
component is, and hos it works with the other components in our decoupled and transient environment.
 Lets get started.

### Objectives

- Learn about master node components
- Learn about minions node components
- Understand the Container Network Interface (CNI) configuration and Network Plugins

### == Master Node ==

#### Kube-scheduler

Sees the requests for running containers coming to the API and finda a suitable node to run that container it.

#### kube-apiserver

All call, both internal and external traffic, are handled via this agent. All actions accepted and validated by this agent, and it is
only connection to the `etcd` database. Acts as a master process for the entire cluster, and acts as a frontend of the cluster's shared state.

#### etcd

The state of the cluster, networking, and other persistent information is kept in an `etcd` database.

#### kube-controller-manager

A core control loop daemon which interacts with the `kube-apiserver` to determine the state of the cluster.

#### == Nodes ==

#### Kubelet

Receives requests to run containers, manages any necessary resources and watches over them on the local node. Responsible for access creation to Secrets and ConfigMaps.

#### Kube-proxy

Creates and manages networking rules to expose the container on the network

#### supervisord

A lightweight process monitor used in traditional Linux environments to monitor and notify about other processes. In the cluster, this
daemon monitors both the `kubelet` and `docker` processes.

### Terminology

`Deployment` ensures that resources are avaialbe, such as IP address and storage, and then deploys `ReplicaSet`.

`ReplicaSet` is a controller which deploys and restarts containers, Docker by default, until the requested number of containers is running.

`Jobs` & `CronJobs` to handle single recurring tasks.

`Service` is a microservice handling a particular bit of traffic, such as a single `NodePort` or a `LoadBalancer` to distribute inbound
requests among many `Pods`. Handles access policies for inbound requests, useful for resource control, as well as for security.

`Endpoints`, `Namespace` and `ServiceAccounts` contorllers each manage the eponymous resources for Pods.