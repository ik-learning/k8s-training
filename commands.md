# K8s Commands

Switch cluster context
```
kubectl config use-context k8s
```

rollout

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
ifconfig
cat /etc/issue
hostname
cat /proc/cpuinfo
ps aux
ln -s {source-filename} {symbolic-filename}
sudo apt-mark hold docker-ce kubelet kubeadm kubectl
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


Kubeadm
```
kubeadm token list
kubeadm join --token c04797.8db60f6b2c0dd078 192.168.12.10:6443 --discovery-token-ca-cert-hash sha256:<hash>
```

Locations:
```
/etc/kubernetes/manifests
```

Firewaill
```
sudo systemctl status firewalld
cat /etc/resolv.conf
ps auxw | grep kube-proxy
iptables-save | grep hostnames
```

Systemd Essentials:
https://www.digitalocean.com/community/tutorials/systemd-essentials-working-with-services-units-and-the-journal

sudo systemctl edit --full nginx.service
systemctl show nginx.service
systemctl cat nginx.service