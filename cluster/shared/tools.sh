#!/bin/bash

set -euo pipefail

node_role="$1"
node_number="$2"
node_ip=$3
kube_version=$4
kube_cni_version=$5

echo "========================"
echo "== DOCKER TOOLS START =="
echo "========================"

on_exit() {
KUBELET_SERVICE=$(systemctl cat kubelet.service)
KUBELET_VERSION=$(kubelet --version)
KUBEADM_VERSION=$(kubeadm version -o json)

KUBECTL_VERSION=$(kubectl version -o json 2>/dev/null || true)

cat>/data/.debug-tools-${node_role}-${node_number}<<EOF
KUBELET_SERVICE:
${KUBELET_SERVICE}

KUBELET_VERSION:
${KUBELET_VERSION}

KUBEADM_VERSION:
${KUBEADM_VERSION}

KUBECTL_VERSION:
${KUBECTL_VERSION}
EOF
}
trap on_exit EXIT

# prevent apt-get et al from asking questions
export DEBIAN_FRONTEND=noninteractive

wget -qO- https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
add-apt-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

apt-get update

apt-get install -y kubernetes-cni=${kube_cni_version}  kubeadm=${kube_version} kubelet=${kube_version} kubectl=${kube_version}
# make sure kublet uses:
#   1. the same cgroup driver as docker.
#   2. the correct node-ip address.
#       NB in vagrant the first interface is for NAT but we want to use the
#          second interface for the kubernetes control plane.
#       NB this is seen in the INTERNAL-IP column of the kubectl get nodes -o wide output.
docker_cgroup_driver=$(docker info -f '{{.CgroupDriver}}')
cat >/etc/systemd/system/kubelet.service.d/11-cgroup-driver.conf <<EOF
[Service]
Environment="KUBELET_EXTRA_ARGS=--cgroup-driver=$docker_cgroup_driver"
EOF
cat >/etc/systemd/system/kubelet.service.d/11-node-ip.conf <<EOF
[Service]
Environment="KUBELET_EXTRA_ARGS=--node-ip=${node_ip}"
EOF

systemctl daemon-reload
systemctl restart kubelet
echo "Pull correct images for Kubernetes"
kubeadm config images pull

echo "========================"
echo "== DOCKER TOOLS END   =="
echo "========================"