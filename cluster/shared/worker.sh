#!/bin/bash

set -euo pipefail

node_name=$1

echo "================================="
echo "== WORKER NODE PROVISION START =="
echo "================================="
# write to file
$SHELL -x /vagrant/kubeadm-join.sh ${node_name}

echo "================================"
echo "== WORKER NODE PROVISION END =="
echo "================================"
