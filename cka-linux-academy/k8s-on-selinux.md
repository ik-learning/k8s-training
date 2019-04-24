1. The first thing that we are going to do is use SSH to log in to all machines.
Once we have logged in, we need to elevate privileges using sudo.

```
sudo su
```

2. Disable SeLinux

```sh
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
```

3. Enable the `br_netfilter` module for cluster communication

```sh
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
```

4. Ensure that the Docker dependencies are satisfied.
```sh
yum install -y yum-utils device-mapper-persistent-data lvm2
```

5. Add the Docker repo and install Docker.
```sh
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
```

6. Set the cgroup driver for Docker to systemd, then reload systemd, enable and start Docker
```sh
sed -i '/^ExecStart/ s/$/ --exec-opt native.cgroupdriver=systemd/' /usr/lib/systemd/system/docker.service
systemctl daemon-reload
systemctl enable docker --now
```

7. Add the repo for Kubernetes
```
cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
 https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
```

8. Install K8s
```
yum install -y kubelet kubeadm kubectl
```

9. Enable the kubelet service. The kubelet service will fail to start until the cluster is initialized, this is expected.
```sh
systemctl enable kubelet
```

*Note: Complete the following section on the MASTER ONLY!
10. Initialize the cluster using the IP range for Flannel.
```sh
kubeadm init --pod-network-cidr=10.244.0.0/16
```

11. Copy the kubeadmn join command that is in the output. We will need this later.
12. Exit sudo and copy the admin.conf to your home directory and take ownership.
```sh
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

13. Deploy Flannel
```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

14. Check the cluster state
```sh
kubectl get pods --all-namespaces
```

15. Run the join command that you copied earlier, this requires running the command as sudo on the nodes. Then check your nodes from the master.
```sh
kubectl get nodes
```