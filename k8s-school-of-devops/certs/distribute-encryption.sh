#!/bin/bash

for instance in master-1 master-2; do
  scp encryption-config.yaml ${instance}:~/
done
