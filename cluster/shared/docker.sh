#!/bin/bash

set -euo pipefail

node_role="$1"
node_number="$2"

on_exit() {
IP_LINK=$(ip link)
BRIDGE_LINK=$(bridge link)
DOCKER_INFO=$(docker info)
DOCKER_VERSION=$(docker version)
DOCKER_NETWORK=$(docker network ls)
SUSMTEM_CTL=$(sysctl --system)

cat>/data/.debug-docker-${node_role}-${node_number}<<EOF
IP:
${IP_LINK}

BRIDGE_LINK:
${BRIDGE_LINK}

DOCKER_INFO:
${DOCKER_INFO}

DOCKER_VERSION:
${DOCKER_VERSION}

DOCKER_NETWORK:
${DOCKER_NETWORK}

SUSMTEM_CTL:
${SUSMTEM_CTL}
EOF
}
trap on_exit EXIT

# prevent apt-get et al from asking questions
export DEBIAN_FRONTEND=noninteractive
# install docker
apt-get install -y apt-transport-https software-properties-common

wget -qO- https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get install -y docker.io containerd.io

systemctl stop docker
cat >/etc/docker/daemon.json <<'EOF'
{
    "debug": false,
    "exec-opts": [
        "native.cgroupdriver=systemd"
    ],
    "labels": [
        "os=linux"
    ],
    "hosts": [
        "fd://",
        "tcp://0.0.0.0:2375"
    ]
}
EOF
sed -i -E 's,^(ExecStart=/usr/bin/dockerd).*,\1,' /lib/systemd/system/docker.service
systemctl daemon-reload
systemctl start docker

# configure containerd.
# see https://kubernetes.io/docs/setup/cri/
# modprobe overlay
# modprobe br_netfilter
cat >/etc/sysctl.d/99-kubernetes-cri.conf <<'EOF'
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sysctl --system
containerd config default >/etc/containerd/config.toml
sed -i -E 's,^(\s*systemd_cgroup =).*,\1 true,' /etc/containerd/config.toml
systemctl restart containerd

echo "Check if docker accessible"
usermod -aG docker vagrant

echo "Test containers"
docker run --rm hello-world
docker run --rm alpine cat /etc/resolv.conf
docker run --rm alpine ping -c1 8.8.8.8