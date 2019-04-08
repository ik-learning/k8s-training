[KubeCtl](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#run)
[CheatSheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

```
kubectl run nginx --image=nginx
```

Namespaces

```
kubectl create namespace dev
kubectl cofnig set-context $(kubectl config current-context) --namespace=dev
```

Commands:

```
kubectl run nginx --image=nginx (deployment)
kubectl run nginx --image=nginx --restart=Never (pod)
kubectl run nginx --image=nginx --restart=OnFailure (job)
kubectl run nginx --image=nginx --restart=OnFailure --schedule="* * * *" (crenJob)
kubectl run --generator=run-pod/v1 nginx --image=nginx
kubectl run --generator=run-pod/v1 nginx --image=nginx --dry-run -o yaml
kubectl run --generator=deployment/v1beta1 nginx --image=nginx
kubectl run --generator=deployment/v1beta1 nginx --image=nginx --dry-run -o yaml
kubectl run --generator=deployment/v1beta1 nginx --image=nginx --dry-run --replicas=4 -o yaml
kubectl run --generator=deployment/v1beta1 nginx --image=nginx --dry-run --replicas=4 -o yaml > nginx-deployment.yaml

kubectl run fronteend --replicas=2 --labels=run=load-balancer-example --image=busybox --port=8080
kubectl expose deployment frontend --type=NodePort --name=frontend-service --port=6262 --target-port=8080
kubectl set serviceaccount deployment frontend myuser
kubectl create service clusterip my-cs --tcp=5678:8080 --dry-run -o yaml
```

ReplicaSet

```sh
kubectl replace -f <file>
kubectl scale --replicas=6 -f <file>
kubectl scale --replicas=6 replicaset myapp-replicaset
kubectl scale --replicas=3 rs/foo
```

ConfigMaps

```sh
kubectl create configmap <name> --from-literal=<key>=<value>
kubectl create configmap <name> --from-file=<file.properties>
```

Unix/bash

```sh
args: ["-c", "while true; do date >> /var/log/app.txt; sleep 5;done"]
args: [/bin/sh, -c, "i=0;while true; do echo "$i: $(date);i=$(i+1)); sleep 5;done"]
args: ["-c", "mkdir -p collect;while true; do cat /var/data/* > /collect/data.txt; sleep 10;done"]
```

Grep

```
kubectl describe pods | grep --context=10 annotations:
kubectl describe pods | grep --context=10 Events:
```

Secrets

```sh
echo -n "test" | base64
kubectl create secret generic app-secret --from-literal=<key>=<value>
```

Security

```sh
kubectl exec ubuntu-sleeper whoami
```


Switch cluster
```
kubectl config use-context <cluster>
```

## Taints

```sh
kubectl taint nodes node-name key=value:tainf-effect
kubectl taint nodes node1 app=blue:NoSchedule
```

## Node selectors

```sh
kubectl label nodes <nodename> <label-key>=<label-value>
kubectl label nodes node1 size=Large
```

Taint effects: NoSchedule|PreferNoSchedule|NoExecute