
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

kubectl run fronteend --replicas=2 --labels=run=load-balancer-example --image=busybox --port=8080
kubectl expose deployment frontend --type=NodePort --name=frontend-service --port=6262 --target-port=8080
kubectl set serviceaccount deployment frontend myuser
kubectl create service clusterip my-cs --tcp=5678:8080 --dry-run -o yaml
```

Unix/bash
```
args: ["-c", "while true; do date >> /var/log/app.txt; sleep 5;done"]
args: [/bin/sh, -c, "i=0;while true; do echo "$i: $(date);i=$(i+1)); sleep 5;done"]
args: ["-c", "mkdir -p collect;while true; do cat /var/data/* > /collect/data.txt; sleep 10;done"]
```

Grep
```
kubectl describe pods | grep --context=10 annotations:
kubectl describe pods | grep --context=10 Events:
```