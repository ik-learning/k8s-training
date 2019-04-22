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
sudo systemd-analyze verify etcd.service
lsof -i :<PORT>
$(cat server.csr | base64 | tr -d '\n')
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



/usr/local/bin/etcd \
 --name master-1 \
 --cert-file=/etc/etcd/etcd-server.crt \
 --key-file=/etc/etcd/etcd-server.key \
 --peer-cert-file=/etc/etcd/etcd-server.crt \
 --peer-key-file=/etc/etcd/etcd-server.key \
 --trusted-ca-file=/etc/etcd/ca.crt \
 --peer-trusted-ca-file=/etc/etcd/ca.crt \
 --peer-client-cert-auth \
 --client-cert-auth \
 --initial-advertise-peer-urls https://192.168.5.11:2380 \
 --listen-peer-urls https://192.168.5.11:2379,https://127.0.0.1:2379 \
 --advertise-client-urls https://192.168.5.11:2379 \
 --initial-cluster-token etcd-cluster-0 \
 --initial-cluster master-1=https://192.168.5.11:2380,master-2=https://192.168.5.12.2380 \
 --initial-cluster-state new \
 --data-dir=/var/lib/etcd