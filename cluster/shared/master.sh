#!/bin/bash

set -euox pipefail

echo "================================="
echo "== MASTER NODE PROVISION START =="
echo "================================="

apiserver_advertise_address=$1
pod_network_cidr=$2
service_cidr=$3
service_dns_domain=$4
node_number=$5

# initialize kubernetes.
KUBEADM_INIT=$(kubeadm init \
    --apiserver-advertise-address=$apiserver_advertise_address \
    --pod-network-cidr=$pod_network_cidr \
    --service-cidr=$service_cidr \
    --service-dns-domain=$service_dns_domain \
    --ignore-preflight-errors=NumCPU)


on_exit() {
cat>/data/.debug-master-${node_number}<<EOF
KUBEADM_INIT:
${KUBEADM_INIT}
EOF
}
trap on_exit EXIT

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

echo "==============================="
echo "== MASTER NODE PROVISION END =="
echo "==============================="