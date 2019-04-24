# Cluster Maintanance

See which pods are running on which nodes:
```sh
kubectl get pods -o wide
```

Evict pods on a node:
```sh
kubectl drain [node-naim] --ignore-daemonsets
```

Schedule pods to the node after mainstanance complete:
```sh
kubectl uncordon [node-name]
```

Remove a node from the cluster:
```sh
kubectl delete node [node-name]
```

Generate a new token:
```sh
sudo kubeadm token generate
```

List the tokens:
```sh
sudo kubeadm token list
```

Print the token kubedm join command to join a node to the cluster:
```sh
sudo kubeadm token create [token-name] --ttl 1h --print-join-command
```