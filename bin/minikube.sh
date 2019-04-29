#!/bin/bash

set -euo pipefail

COMMAND=${1:-plan}


# minikube $COMMAND --memory 4048
# https://github.com/knative/docs/blob/master/install/Knative-with-Minikube.md
minikube start

minikube config set kubernetes-version v1.13.5
minikube config set memory 4192
minikube config set cpus 2
minikube config set heapster true
minikube config set ingress true


# 192.168.99.102

# minikube config view
# minikube set vm-driver virtualbox
# minikube config set vm-driver virtualbox
# minikube config set memory 8192
# minikube config set cpus 4

# https://kubernetes.io/docs/setup/minikube/#installation
# minikube start --memory=4192 --cpus=2 \
#   --kubernetes-version=v1.13.5 \
#   --vm-driver=virtualbox

# cat $HOME/.minikube/config/config.json
# echo -e "\n"
# minikube start

echo "Show namespaces"
# kubectl get pods --all-namespaces
