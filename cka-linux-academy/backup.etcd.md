# Backupt ETCD

Get the etcd binaries:
```sh
wget https://github.com/etcd-io/etcd/releases/download/v3.3.12/etcd-v3.3.12-linux-amd64.tar.gz
```

Unzip the compressed binaries:
```sh
tar xvf etcd-v3.3.12-linux-amd64.tar.gx
```

Move the files into `/usr/local/bin`:
```sh
sudo mv etcd-v3.3.12-linux-amd64/etcd* /usr/local/bin
```

Take a snapshot of the etcd datastoure using etcdctl:
```sh
sudo ETCDCTL_API=3 etcdctl snapshot save snapshot.db --cacert /etc/kubernetes/pki/etcd/server.crt --cert /etc/kubernetes/pki/etcd/ca.crt --key /etc/kubernetes/pki/etcd/ca.key
```

View the help page for etcdctl:
```sh
ETCDCTL_API=3 etcdctl --help
```

Browse to the folder that contains the certificate files:
```
cd /etc/kubernetes/pki/etcd/
```

View that the snapshot was successful:
```sh
ETCDCTL_API=3 etcdctl --write-out=table snapshot status snapshot.db
```

Zip up the contents of the etcd directory:
```sh
sudo tar -zcvf etcd.tar.gz etcd
```

Copy the etcd directory to another server:
```sh
scp etcd.tar.gz cloud@user....:~/
```
