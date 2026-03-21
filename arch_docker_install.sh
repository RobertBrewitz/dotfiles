#!/bin/bash

set -e

# https://wiki.archlinux.org/title/Docker
echo "Installing iptables-nft (required for Docker networking)"
yes | sudo pacman -S --needed iptables-nft

echo "Installing Docker"
sudo pacman -S --noconfirm --needed docker docker-buildx

echo "Enabling Docker service"
sudo systemctl enable docker.service

echo "Manage Docker as a non-root user"
if [ ! $(getent group docker) ]; then
  sudo groupadd docker
fi
if ! id -nG "$USER" | grep -qw "docker"; then
  sudo usermod -aG docker $USER
fi

echo "Add Docker daemon.json"
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{}
EOF

echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
echo ""
echo "Add any tlscert and tlskey to /etc/docker/daemon.json manually"
echo ""
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
echo ""
echo "REBOOT before starting Docker (required after iptables-nft install)"
