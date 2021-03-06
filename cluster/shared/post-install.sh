#!/bin/bash

set -euox pipefail

echo "================================"
echo "== CLUSTER POST INSTALL START =="
echo "================================"

kubectl get nodes

kubectl cluster-info dump > /vagrant/cluster-info-dump

# install the kubernetes dashboard.
# see https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended/kubernetes-dashboard.yaml

# create the admin user.
# see https://github.com/kubernetes/dashboard/wiki/Creating-sample-user
# see https://github.com/kubernetes/dashboard/wiki/Access-control
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin
  namespace: kube-system
EOF

#
# wget https://tinyurl.com/yb4xturm -O rbac-kdd.yaml

# wget https://tinyurl.com/y8lvqc9g  -O calico.yaml

# kubectl apply -f rbac-kdd.yaml
# kubectl delete -f rbac-kdd.yaml
# kubectl apply -f calico.yaml
# kubectl delete -f calico.yaml
# save the admin token.
kubectl \
  -n kube-system \
  get \
  secret \
  $(kubectl -n kube-system get secret | grep admin-token- | awk '{print $1}') \
  -o json | jq -r .data.token | base64 --decode \
  >/vagrant/admin-token

kubectl get nodes -o wide > /vagrant/pods
kubectl get pods --all-namespaces > /vagrant/namespaces
kubeadm token list > /vagrant/kubeadm-tokens
kubectl -n kube-system get secret > /vagrant/secrets
kubectl get svc > /vagrant/services

# Install heapster. TODO: change namespace to monitoring
kubectl apply -f https://raw.githubusercontent.com/kubernetes-retired/heapster/master/deploy/kube-config/influxdb/heapster.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended/kubernetes-dashboard.yaml

$SHELL -c 'while [ -z "$(kubectl get nodes --all-namespaces | grep -E "\s+Ready\s+")" ]; do sleep 3; done'
# install tiller server prereq
kubectl create serviceaccount -n kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
echo "=============================="
echo "== CLUSTER POST INSTALL END =="
echo "=============================="
