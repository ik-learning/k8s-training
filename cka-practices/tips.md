# CKA Tips



Debug quick
```
 kubectl get componentstatuses
```

```
find / -name "*.yaml"
mount | grep foo # confirm the mounting
cat /etc/passwd | cut -f 1 -d ':' > /etc/foo/passwd # read first column
```

Maintanance
```
kubectl drain <node>
kubectl cordon <node>
kubectl uncordon <node>
```

Upgrade
```
kubeadm upgrade plan
kubectl drain node-1
kubeadm upgrade plan
apt-get upgrade -y kubeadm=1.12.0-00
kubectl upgrade apply v1.12.0
apt-get upgrade -y kubelet=1.12.0-00
kubeadm upgrade node config --kubelet-version v1.12.0
systemctl restart kubelet
kubectl uncordon node-1
```

Commands
```
apt-get update
apt-get upgrade -u kubeadm=1.12.0-00
kubeadm upgrade node config --kubelet-version $(kubelet --version | cut -d ' ' -f 2)
apt install kubelet=1.12.0-00
```

Backup and Restore
```
go get github.com/coreos/etcd/etcdctl

```