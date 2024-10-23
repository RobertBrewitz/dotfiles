#!/bin/bash

# https://docs.docker.com/engine/install/ubuntu/
echo "Setting up apt Docker repository"
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Manage Docker as a non-root user"
if [ ! $(getent group docker) ]; then
  sudo groupadd docker
fi
if ! id -nG "$USER" | grep -qw "docker"; then
  sudo usermod -aG docker $USER
  newgrp docker
fi

# echo "Make Docker use host machine's DNS"
# sudo apt-get install dnsmasq
# sudo mkdir /etc/resolvconf/resolv.conf.d
# sudo touch /etc/resolvconf/resolv.conf.d/tail
# echo "nameserver 172.17.0.1" | sudo tee -a /etc/resolvconf/resolv.conf.d/tail
# sudo touch /etc/NetworkManager/dnsmasq.d/docker.conf
# sudo tee -a /etc/NetworkManager/dnsmasq.d/docker.conf <<EOF
# interface=lo
# interface=tun0
# interface=docker0
# listen-address=172.17.0.1
# bind-dynamic
# EOF

echo "DONE"
