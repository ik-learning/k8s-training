#!/bin/bash

set -euo pipefail

echo "================================="
echo "== MASTER NODE PROVISION START =="
echo "================================="

apiserver_advertise_address=$1
pod_network_cidr=$2
service_cidr=$3
service_dns_domain=$4
node_number=$5

echo "Pull system apps for Kubernetes"
kubeadm config images pull

# initialize kubernetes.
KUBEADM_INIT=$(kubeadm init \
    --apiserver-advertise-address=$apiserver_advertise_address \
    --pod-network-cidr=$pod_network_cidr \
    --service-cidr=$service_cidr \
    --service-dns-domain=$service_dns_domain \
    --ignore-preflight-errors=NumCPU)


on_exit() {
LISTENING_PORTS=$(ss -n --tcp --listening --processes)
KUBERNETES_CONFIG_FILES=$(find /etc/kubernetes)
IP_ROUTE=$(ip route)
cat>/data/.debug-master-${node_number}<<EOF
KUBERNETES_CONFIG_FILES:
${KUBERNETES_CONFIG_FILES}
========================
EOF
cat>/data/.debug-master-listening-ports-${node_number}<<EOF
Show Listening Ports:
${LISTENING_PORTS}
EOF
cat>/data/.debug-master-kube-init${node_number}<<EOF
${KUBEADM_INIT}
EOF
cat>/data/.debug-master-ip-routes-${node_number}<<EOF
Show and manipulate routing:
${IP_ROUTE}
EOF
}
trap on_exit EXIT
# --node-name ${node_name}
kubeadm token create --print-join-command > /vagrant/kubeadm-join.sh

# configure kubectl in the root and vagrant accounts with kubernetes superuser privileges.
for home in /root /home/vagrant; do
    o=$(stat -c '%U' $home)
    g=$(stat -c '%G' $home)
    install -d -m 700 -o $o -g $g $home/.kube
    install -m 600 -o $o -g $g /etc/kubernetes/admin.conf $home/.kube/config
done

# also save the kubectl configuration on the host, so we can access it there.
cp /etc/kubernetes/admin.conf /vagrant/

# install the kube-router cni addon as the pod network driver.
# see https://github.com/cloudnativelabs/kube-router
# see https://github.com/cloudnativelabs/kube-router/blob/master/Documentation/kubeadm.md
wget -q https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml
kubectl apply -f kubeadm-kuberouter.yaml

# wait for this node to be Ready.
# e.g. km1     Ready     master    35m       v1.14.0
$SHELL -c 'node_name=$(hostname); while [ -z "$(kubectl get nodes $node_name | grep -E "$node_name\s+Ready\s+")" ]; do sleep 3; done'

# wait for the kube-dns pod to be Running.
# e.g. coredns-fb8b8dccf-rh4fg   1/1     Running   0          33m
$SHELL -c 'while [ -z "$(kubectl get pods --selector k8s-app=kube-dns --namespace kube-system | grep -E "\s+Running\s+")" ]; do sleep 3; done'

$SHELL -c 'while [ -z "$(kubectl get nodes | grep -E "\s+Ready\s+")" ]; do sleep 3; done'

echo "==============================="
echo "== MASTER NODE PROVISION END =="
echo "==============================="
