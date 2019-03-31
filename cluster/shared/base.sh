#!/bin/bash

set -euo pipefail

node_role="$1"
node_number="$2"
# prevent apt-get et al from asking questions
export DEBIAN_FRONTEND=noninteractive

# make sure the system does not uses swap (a kubernetes requirement).
# NB see https://kubernetes.io/docs/tasks/tools/install-kubeadm/#before-you-begin
swapoff -a
sed -i -E 's,^([^#]+\sswap\s.+),#\1,' /etc/fstab

echo "Update the local node"
apt-get update
# && sudo apt-get upgrade -y

# install vim with jq
apt-get install -y --no-install-recommends vim jq
cat >/etc/vim/vimrc.local <<'EOF'
syntax on
set background=dark
set esckeys
set ruler
set laststatus=2
set nobackup
EOF

# configure the shell.
cat >/etc/profile.d/login.sh <<'EOF'
[[ "$-" != *i* ]] && return
export EDITOR=vim
export PAGER=less
alias l='ls -lF --color'
alias ll='l -a'
alias h='history 25'
alias j='jobs -l'
EOF

cat >/etc/inputrc <<'EOF'
set input-meta on
set output-meta on
set show-all-if-ambiguous on
set completion-ignore-case on
"\e[A": history-search-backward
"\e[B": history-search-forward
"\eOD": backward-word
"\eOC": forward-word
EOF

# show mac addresses and the machine uuid to troubleshoot they are unique within the cluster.
IP_LINK=$(ip link)
PRODUCT_UUID=$(cat /sys/class/dmi/id/product_uuid)

cat>/data/.debug-base-${node_role}-${node_number}<<EOF
IP:
${IP_LINK}
PRODUCT_UUID:
${PRODUCT_UUID}
EOF

if [ "$node_role" == 'master' ]; then
cat >/etc/motd <<'EOF'
 __        ___.                               __
|  | ____ _\_ |__   ___________  ____   _____/  |_  ____   ______
|  |/ /  |  \ __ \_/ __ \_  __ \/    \_/ __ \   __\/ __ \ /  ___/
|    <|  |  / \_\ \  ___/|  | \/   |  \  ___/|  | \  ___/ \___ \
|__|_ \____/|___  /\___  >__|  |___|  /\___  >__|  \___  >____  >
     \/         \/     \/           \/     \/          \/     \/
                        __
  _____ _____    ______/  |_  ___________
 /     \\__  \  /  ___|   __\/ __ \_  __ \
|  Y Y  \/ __ \_\___ \ |  | \  ___/|  | \/
|__|_|  (____  /____  >|__|  \___  >__|
      \/     \/     \/           \/
EOF
else
cat >/etc/motd <<'EOF'
 __        ___.                               __
|  | ____ _\_ |__   ___________  ____   _____/  |_  ____   ______
|  |/ /  |  \ __ \_/ __ \_  __ \/    \_/ __ \   __\/ __ \ /  ___/
|    <|  |  / \_\ \  ___/|  | \/   |  \  ___/|  | \  ___/ \___ \
|__|_ \____/|___  /\___  >__|  |___|  /\___  >__|  \___  >____  >
     \/         \/     \/           \/     \/          \/     \/
                     __
__  _  _____________|  | __ ___________
\ \/ \/ /  _ \_  __ \  |/ // __ \_  __ \
 \     (  <_> )  | \/    <\  ___/|  | \/
  \/\_/ \____/|__|  |__|_ \\___  >__|
                         \/    \/
EOF
fi