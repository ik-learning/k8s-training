#!/bin/bash

set -euo pipefail

echo "================================="
echo "== WORKER NODE PROVISION START =="
echo "================================="
# write to file
$SHELL -x /vagrant/kubeadm-join.sh

echo "================================"
echo "== WORKER NODE PROVISION END =="
echo "================================"
