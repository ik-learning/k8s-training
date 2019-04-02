 # Commands

 kubectl api-resources

 Create/delete new pod using
 ```
 kubectl apply -f ./lsf158x[introduction-to-k8s]/labs/2.2/basic.yaml
 kubectl get pod
 kubectl describe pod basicpod
 kubectl get pod -o wide
 kubectl delete pod basicpod
 ```

Services. Expose to outside world
```
kubectl get svc
> NAME           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
> basicservice   NodePort    10.13.195.180   <none>        80:30905/TCP   4s
> kubernetes     ClusterIP   10.13.0.1       <none>        443/TCP        49m
curl http://worker-1.cluster.vagrant:30905 -v
> nginx response
 ```

Composite
```
kubectl delete -f ./lsf158x[introduction-to-k8s]/labs/2.2/composite.yaml
> NAME       READY   STATUS    RESTARTS   AGE
> basicpod   2/2     Running   0          27s

kubectl describe pod basicpod

```

## Deployment

```
kubectl create deployment firstpod --image=nginx
kubectl get deployment,pod
kubectl describe deployment firstpod
kubectl describe pod <name|id>
kubectl get namespaces
kubectl get deploy,rs,po,svc,ep
```










Clean it
```
kubectl delete -f ./lsf158x[introduction-to-k8s]/labs/2.2/basic.yaml
```