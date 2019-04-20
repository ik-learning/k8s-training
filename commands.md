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

or

```yaml
apiVersion: v1
kind: Pod
	metadata: name:
spec:
	containers:
	- name: nginx
		image: nginx
		env:
		- name: VAR1
			value: "foobar
	restartPolicy: Never
```

