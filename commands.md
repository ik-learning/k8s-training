# K8s Commands

Switch cluster context
```
kubectl config use-context k8s
```

ollout

```
kubectl rollout history deployments
kubectl get componentstatuses
top
df -h
ps -ef --forest
sudo journalctl -u kubelet
sudo systemctl status kubelet
```

```
kubectl explain <resource-name>
```

RBAC Tests

```
kubectl auth can-i create deployments -n <namespace>
kubectl auth can-i get pods -n <namespace>
kubectl auth can-i create deployments --namespace default
kubectl auth can-i create pods --as=me
kubectl auth can-i create pods --as-group=some
```

ENV

```bash
kubectl run nginx --image=nginx --restart=Never --env=VAR1=foobar
```

```
kubectl auth can-i craete deployments
kubectl auth can-i delete nodes
kubectl auth can-i craete deployments --as dev-user
kubectl auth can-i list pod/dark-blue-app -n blue --as dev-user
kubectl auth can-i create deployments -n blue --as dev-user
```

