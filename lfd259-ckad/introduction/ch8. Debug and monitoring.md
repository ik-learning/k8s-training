# Debug and Monitoring

Troubleshooting, which we'll cover in this chapter, can be difficult, in a distributed and decoupled environment like K8s.

We will cover the basic flow that can be used to diagnose and identify issues you may have.

We do not have cluster wide logging build-in into K8s.

So, we talk about other projects you may want to implement, like Prometheus and FluentD, that offer monitoring and logging in a cluster-wide
sense.

We will talk about agent logs locally, and node logs locally as well.

With conformance testing, we can ensure that the deployment of kubernetes that we have chosen conforms to standarts used in the community.

We'll also talk about certification, which is a way of knowing that the K8s distribution you are using is up to the standards of the community in general.

## Learning Objectives

- Understand and use the troubleshooting flow
- Monitor applications
- Review system logs
- Review agent logs
- Discuss conformance testing
- Discuss cluster certifications

## Overview

Kubernetes relies on API calls and is sensitive to network issues. Standart Linux tools and processes are the best methos for troubleshooting your
cluster. If a shell, such as bash, is not avaialable in an effected pod, consider deploying another similar pod with a shell, like busybox. DNS
configuration files and tools like dig are good place to start. For more difficult challanges, you may need to install other tools, like tcpdump.

Large and diverse workloads can be difficult to track, so monitoring of usage is essential. Monitoring is about collecting key metrics, such as CPU,
memory, disk and disk usage, and network bandwith on you nodes, as well as monitoring key metrics in your applications. These features have not
been ingested into Kubernetes, so exterior tools will be necessary.

Logging activity across all the nodes is another feature not part of k8s. Using FluentD can be useful data collector for a unified logging
layer. Having aggregated logs can help visualize the issue, and provides the ability to search all logs. It is a good place to start when local
network troubleshooting does not expose the root cause.

Another projecct from CNCF combines logging, monitoring and alerting and is called Prometheus. It provides a time-series database, as well as integration
with Grafana for visualiation and dashboards.

We are going to review some of the basic kubectl commands that you can use to debug what is happening, and we will walk you through the basic steps
to be able to debug your containers, you pending containers, and also the systems in K8s.

```
kubectl run busybox --image=busybox command -- sleep 3600
kubectl exec -ti <busybox_pod> -- /bin/sh
kubectl run -i --tty busybox --image=busybox --restart=Never -- sh
```

Intermode networking can also be an issue. Changes to switches, routes or other network settings can adversely affect K8s. Historically, the
primary cahuses were DNS and firewalls. As k8s integrations have become common and DNS integration is maturing, this has become less of an issue.
Still, check connectivity and fro recent infrastructure chagnes as part of your troubleshooting process. Every so often, an update which was
said should't cause an issue may, in fact, be causing an issue.

Troubleshooting an application begins with the application itself. IS the application behaving as expected? Transient issues are difficult to
troubleshoot; difficulties are also encountered if the issue is intermittent or if it concerns cossainal slow performance.

Assuming the application is not the issue, beging by viewing the pods with the `kubectl get` command. Ensure the pods report a status of Running.
A status of Pending typically means a resource is not available from the cluster, such as a properly tainted node, expected storage, or enough
resources. Other errors codees typically require looking at the logs and events of the containers for further troubleshooting. Also, look for an
unusual number of reestarts. A container is expected to restart due to several reasons, such as a command argument finishing. If the restarts
are not due to that, it may indicate the deployed application is having an issue and failing due to panic or probe failure.

## Basic Troubleshooting Flow - Agents

The issue found with a decoupled system like K8s are similar to those of a traditional datacenter, plus the layers of K8s controlers.

- Controls pods in pending or error state
- Look for errors in log files
- Are there enough resources?
- etc

## Conformance Testing

The flexibility of K8s can lead to the development of non-conforming cluster
- Meet the demands of your environment
- Several vendor-provided tools for confomance testing
- For ease or use, []Sonobuyouby](https://github.com/heptio/sonobuoy) by Heptio can be used to understand the state of the cluster.

Commands

```
ps -elf |grep kube-proxy
```

If the containers, services and endpoints are working the issue may be with an infrastructure service like kube-proxy.
Ensure it’s running, then look for errors in the logs. As we have two nodes we will have two proxies to look at. As we
built our cluster with kubeadm the proxy runs as a container. On other systems you may need to use journalctl or look
under /var/log/kube-proxy.log.
```
journalctl -a | grep proxy
```

Check that the proxy is creating the expected rules for the problem service. Find the destination port being used for the
service, 30195 in this case.
```
sudo iptables-save |grep secondapp
```