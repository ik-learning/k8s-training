# Kubernetes services

## Kube ApiServer
```
ps -aux | grep kube-apiserver
cat /etc/systemd/system/kube-apiserver.service
```

## Kube Controller-Manager
```
ps -aux | grep kube-controller-manager
cat /etc/systemd/system/kube-controller-manager.service
```

## Kube Scheduler

```
cat /etc/kubernetes/manifests/kube-scheduler.yaml
ps -aux | grep kube-scheduler
```

## Kubelet

```
ps -aux | grep kubelet
```

## Kube-proxy

```

```