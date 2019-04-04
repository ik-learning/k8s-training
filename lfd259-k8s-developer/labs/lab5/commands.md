# Commands for lab 5

```
kubectl get pv
kubectl get pvc
```

Secrets
```
kubectl get secrets
kubectl exec -ti busybox -- cat /mysqlpwd/password
```

Edit deployments
```
kubecl edit deployment nginx
```

Create Config Map
```yaml
kubectl create configmap color \
 --from-literal=text=black \
 --from-file=./favorite \
 --from-file=./primary/
> configmap/color created
kubectl get configmap color
---
apiVersion: v1
kind: ConfigMap
data:
  black: |
    k
    known as key
  cyan: |
    c
  favorite: |
    blue
  magenta: |
    m
  text: black
  yellow: |
    y
---
```

Ops deployment
```
kubectl apply -f /Users/ivanka/code/self/kubernetes-trainings/lfd259-k8s-developer/labs/lab5/simpleapp.yaml
kubectl exec -c simpleapp -it <pod-id> -- /bin/bash -c 'echo $ilike'
try1-675f468686-flgwf <pod-id> -- /bin/bash -c 'env'
kubectl delete -f /Users/ivanka/code/self/kubernetes-trainings/lfd259-k8s-developer/labs/lab5/simpleapp.yaml
```

```yaml


```

Debug readiness probe
```
kubectl describe pod <podid>
kubectl delete deployment try1
kubectl exec -c simpleapp -it <pod-id> -- /bin/bash -c 'cat /etc/cars/car.trim`
```

Attaching storage
```
kubectl apply -f ./lfd259-k8s-developer/labs/lab5/PVol.yaml
> persistentvolume/pvvol-1 created
kubectl get pv
>
kubectl get pvc
>
kubectl apply -f ./lfd259-k8s-developer/labs/lab5/pvc.yaml
```

5.3

```
kubectl apply -f ./lfd259-k8s-developer/labs/lab5/pv-weblog.yaml
kubectl get pv weblog-pv-volume
kubectl apply -f ./lfd259-k8s-developer/labs/lab5/pvc-weblog.yaml
kubectl apply -f ./lfd259-k8s-developer/labs/lab5/basic.fluentd.yaml
kubectl exec -c webcont -it basicpod -- /bin/bash
$ ls -l /var/log/nginx/access.log
$ tailf /var/log/nginx/access.log
kubectl logs basicpod fdlogger
kubectl exec -c fdlogger -it basicpod -- /bin/sh
```

5.4 Update deployment

```
kubectl edit deployment try1
kubectl rollout history deployment try1
```

Compare the output of the rollout history for the two revisions. Images and labels should be different, with the image v2 being the change we made.
```
kubectl rollout history deployment try1 --revision=1 > one.out
kubectl rollout history deployment try1 --revision=2 > two.out
diff one.out two.out
```

View what would be undone using the –dry-run option while undoing the rollout. This allows us to see the new template prior to using it.
```
kubectl rollout undo --dry-run=true deployment/try1
```

In our case there are only two revisions, which is also the default number kept. Were there more we could choose a particular version. The following command would have the same effect as the previous, without the –dry-run option.
```
kubectl rollout undo deployment try1 --to-revision=1
```

Again, it can take a bit for the pods to be terminated and re-created. Keep checking back until they are all running again
```
kubectl get pods
```
