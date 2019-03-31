#!/bin/bash

set -euox pipefail

echo "==============================="
echo "== CLUSTER INFORMATION START =="
echo "==============================="

kubectl cluster-info dump

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
# trap on_exit EXIT


echo "==============================="
echo "== CLUSTER INFORMATION END =="
echo "==============================="
