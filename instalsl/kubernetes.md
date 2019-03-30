# Install Kubernetes

This lesson covers how to install Kubernetes on a CentOS 7 server in our Cloud Playground. Below, you will find a list of the commands used in this lesson.

*Note in this lesson we are using 3 unit servers as this meets the minimum requirements for the Kubernetes installation. Use of a smaller size server (less than 2 cpus) will result in errors during installation.

The first thing that we are going to do is use SSH to log in to all machines. Once we have logged in, we need to elevate privileges using sudo.
```
sudo su
```
Disable SELinux.
```
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g'
/etc/sysconfig/selinux
```
Enable the br_netfilter module for cluster communication.
```
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
```
Disable swap to prevent memory allocation issues.
```
 swapoff -a
 vim /etc/fstab.  ->  Comment out the swap line
```

Install the Docker prerequisites.
```
yum install -y yum-utils device-mapper-persistent-data lvm2
```
Add the Docker repo and install Docker.
```
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
```

Add the Kubernetes repo.
```
 cat <<EOF > /etc/yum.repos.d/kubernetes.repo
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
Install Kubernetes.

```
 yum install -y kubelet kubeadm kubectl

```
Enable and start Docker and Kubernetes. The kubelet service will not start until you run kubeadm init, until then it will be in a failed state, this is expected.

```
 systemctl enable docker
 systemctl enable kubelet
 systemctl start docker
 systemctl start kubelet
```

*Note: Complete the following section on the MASTER ONLY!

Initialize the cluster using the IP range for Flannel.
```
kubeadm init --pod-network-cidr=10.244.0.0/16
```
Copy the kubeadmin join command.

Exit sudo and run the following:
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
Deploy Flannel.
```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
Check the cluster state.
```
kubectl get pods —all-namespaces
```
*Note: Complete the following steps on the NODES ONLY!

Run the join command that you copied earlier (this command needs to be run as sudo), then check your nodes from the master.
kubectl get nodes
```
kubectl get nodes
```