# Update cluster

kubeadm allows us to upgrade our cluster components in the proper order, making sure to include important feature upgrades we might want to take advantage of in the latest stable version of Kubernertes. In this lesson, we will go through upgrading our cluster from version 1.13.5 to 1.14.1.

View the version of the server and client on the master node:
```sh
kubectl version --short
```

View the version of the scheduler and controller manager:
```
kubectl get pods -n kube-system kube-controller- -o yaml
```

View the name of the kube-controller pod:
```sh
kubectl get pods -n kube-system
```

Set the variable to the latest stable release of Kubernetes:
```sh
export VERSION=v1.13.5
```

Set the ARCH variable to the amd64 system:
```sh
export ARCH=amd64
```

Curl the latest stable version of Kuberntetes:
```sh
curl -sSL https://dl.k8s.io/release/${VERSION}/bin/linux/${ARCH}/kubeadm > kubeadm
sudo install -o root -g root -m 0755 ./kubeadm /user/bin/kubeadm
```

Check the version of kubeadm:
```sh
sudo kubeadm version
```

Plan the upgrade:
```sh
sudo kubeadm upgrade plan
```

Apply the upgrade to 1.14.1
```sh
kubeadm upgrade apply v1.13.5
```

View the difference between the old and new machines:
```sh
diff kube-controller-manager.yaml /etc/kubernetes/manifests/kube-controller-manager.yaml
```

Curl the latest version of kubelet:
```sh
curl -sSL https://dl.k8s.io/release/${VERSION}/bin/linux/${ARCH}/kubelet > kubelet
```

Install the latest version of kubelet:
```sh
sudo install -o root -g root -m 0755 ./kubelet /usr/bin/kubelet
```

Restart the kubelet service:
```
sudo systemctl restart kubelet.service
```

Watch the nodes as they change version:
```sh
kubectl get nodes -w
```


-------- Version 2 -----

Get version 1.13.5 of kubeadm
```
```

