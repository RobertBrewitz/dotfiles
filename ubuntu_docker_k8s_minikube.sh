#!/bin/bash

# https://docs.docker.com/engine/install/ubuntu/
echo "Setting up apt Docker repository"
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# https://docs.docker.com/compose/install/
echo "Installing docker-compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# https://kubernetes.io/docs/tasks/tools/install-kubectl/
echo "Installing kubectl"
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# https://github.com/kubernetes/kompose/blob/master/docs/installation.md#github-release
echo "Installing kompose"
curl -L https://github.com/kubernetes/kompose/releases/download/v1.21.0/kompose-linux-amd64 -o kompose
chmod +x kompose
sudo mv ./kompose /usr/local/bin/kompose

# https://help.ubuntu.com/community/KVM/Installation#Installation_of_KVM
echo "Installing kvm for minikube"
sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
sudo adduser `id -un` libvirt
sudo adduser `id -un` kvm

echo "Installing minikube"
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x ./minikube
sudo mv ./minikube /usr/local/bin/minikube

echo "Installing kubectx & kubens"
git clone git@github.com:ahmetb/kubectx.git
cd kubectx
chmod +x kubectx
sudo mv ./kubectx /usr/local/bin/
chmod +x kubens
sudo mv ./kubens /usr/local/bin/

echo "REBOOT REQUIRED"
