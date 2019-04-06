
```sh
curl -H "Host: www.example.com" http://worker-1.cluster.vagrant
kubectl run thirdpage --generator=run-pod/v1 --image=nginx --port=80 -l example=third
kubectl expose pod thirdpage --type=NodePort
```