# Multiple commands

View the pods in the default namespace with a custom view:
```sh
kubectl get pods -o custom-columns=POD:metadata.name,NODE:spec.nodeName --sort-by spec.nodeName -n kube-system
```

View the kube-scheduler YAML:
```sh
kubectl get endpoints kube-scheduler -n kube-system -o yaml
```

Create a stacked etcd topology using kubeadm:
```sh
kubeadm init --config=kubeadm-config.yaml
```

Wath as pods are created in the default namespace:
```sh
kubectl get pods -n kube-system -w
```

View the token file from within a pod:
```sh
cat /var/run/secrets/kubernetes.io/serviceaccount/token
```