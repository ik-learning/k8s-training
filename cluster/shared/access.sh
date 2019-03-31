#!/bin/bash

set -euo pipefail

echo "================================="
echo "== WORKER ACCESS SETUP START =="
echo "================================="

for home in /home/vagrant; do
    o=$(stat -c '%U' $home)
    g=$(stat -c '%G' $home)
    install -d -m 700 -o $o -g $g $home/.kube
    install -m 600 -o $o -g $g /vagrant/admin.conf $home/.kube/config
    echo "KUBECONFIG=$home/.kube/config" >> $home/.bashrc
done

echo "============================="
echo "== WORKER ACCESS SETUP END =="
echo "============================="
