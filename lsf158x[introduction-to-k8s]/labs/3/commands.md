# Commands

```
sudo docker build -t simpleapp .
kubectl apply -f ./lsf158x[introduction-to-k8s]/labs/3/volumes.yaml
kubectl get pv
```

Docker
```
docker build -t cloudkats/simpleapp .

docker push cloudkats/simpleapp

kubectl create deployment try1 --image=cloudkats/simpleapp:latest
kubectl scale deployment try1 --replicas=3
kubectl get pods
kubectl delete deployment try1
kubectl get deployment
```

Return to the master node. Save the try1 deployment as YAML. Use the –export option to remove unique identifying
information. The command is shown on two lines for readability. You can remove the backslash when you run the
command.

```
kubectl get deployment try1 -o yaml --export > simpleapp.yaml
kubectl apply -f ./lsf158x[introduction-to-k8s]/labs/3/simpleapp.yaml
kubectl delete -f ./lsf158x[introduction-to-k8s]/labs/3/simpleapp.yaml
```

Create a health check file
```
kubectl exec -it try1-5ffb9fbbcc-g7bdc -c simpleapp -- /bin/bash -c "touch /tmp/healthy"
kubectl describe pod try1-68bf86bdd7-qmnkb | tail
```