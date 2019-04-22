#!/bin/bash

for instance in worker-1 worker-2; do
  scp kube-proxy.kubeconfig ${instance}:~/
done

for instance in master-1 master-2; do
  scp admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig ${instance}:~/
done