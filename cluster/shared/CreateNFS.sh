#!/bin/bash
#/* **************** LFD259:2019-01-14 s_05/CreateNFS.sh **************** */
#/*
# * The code herein is: Copyright the Linux Foundation, 2019
# *
# * This Copyright is retained for the purpose of protecting free
# * redistribution of source.
# *
# *     URL:    https://training.linuxfoundation.org
# *     email:  training@linuxfoundation.org
# *
# * This code is distributed under Version 2 of the GNU General Public
# * License, which you should have received with the source.
# *
# */
sudo apt-get update && sudo apt-get install -y nfs-kernel-server

sudo mkdir /opt/sfw

sudo chmod 1777 /opt/sfw/

sudo bash -c "echo software > /opt/sfw/hello.txt"

sudo bash -c "echo '/opt/sfw/ *(rw,sync,no_root_squash,subtree_check)' >> /etc/exports"

sudo exportfs -ra

echo
echo "Should be ready. Test here and second node"
echo

sudo showmount -e localhost

# extras on worker node only
sudo apt-get -y install nfs-common nfs-kernel-server

# Test
showmount -e master-1.cluster.vagrant
> Export list for master-1.cluster.vagrant:
> /opt/sfw *

# Mount remove volume
sudo mount master-1.cluster.vagrant:/opt/sfw /mnt
ls -l /mnt
> -rw-r--r-- 1 root root 9 Apr  2 13:53 hello.txt

# Another volume
# master
sudo mkdir /tmp/weblog
