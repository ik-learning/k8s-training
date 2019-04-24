# Cluster Setup

Now that we’ve considered all the different types of clusters and where to locate the tools we need to install a cluster, let’s get to it! In this lesson, we will go through the all steps to install a three-node cluster using your Linux Academy cloud servers.

Add the Docker gpg key:
```sh
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

Add the Docker repository:
```sh
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

Get the K8s gpg key:
```sh
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
```

Add the K8s repository
```sh
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
```

Update you packages:
```
sudo apt-get update
```

Install Docker, kubelet, kubeadm and kubectl:
```sh
sudo apt-get install -y docker-ce=18.06.1~ce~3-0~ubuntu kubelet=1.13.5-00 kubeadm=1.13.5-00 kubectl=1.13.5-00
```

Hold them at the current version:
```sh
sudo apt-mark hold docker-ce kubelet kubeadm kubectl
```

Add the iptables rule to sysctl.conf:
```sh
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
```

Enable iptables immediately:
```
sudo sysctl -p
```

Initialize the cluter(only on master)
```sh
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

Set up local kubeconfig:
```sh
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Apply Flannel CNI network overlay:
```sh
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
```

Join the worker nodes to the cluster:
```sh
kubeadm join [your unique string from the kubeadm init command]
```

Verify the worker nodes have joined the cluster successfulyy:
```
kubectl get nodes
```

