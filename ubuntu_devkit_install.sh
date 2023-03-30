#!/bin/bash

# https://docs.docker.com/engine/install/ubuntu/
echo "Setting up apt Docker repository"
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg -y
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Manage Docker as a non-root user"
sudo groupadd docker -f # exit successfully if group already exists
sudo usermod -aG docker $USER
newgrp docker

# https://kubernetes.io/docs/tasks/tools/install-kubectl/
echo "Installing kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# https://help.ubuntu.com/community/KVM/Installation#Installation_of_KVM
echo "Installing kvm for minikube"
sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils -y
sudo adduser `id -un` libvirt
sudo adduser `id -un` kvm

# https://minikube.sigs.k8s.io/docs/start/
echo "Installing minikube"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# echo "Installing kubectx & kubens"
git clone https://github.com/ahmetb/kubectx.git
chmod +x kubectx/kubectx
sudo mv ./kubectx/kubectx /usr/local/bin/
chmod +x kubectx/kubens
sudo mv ./kubectx/kubens /usr/local/bin/

# https://helm.sh/docs/intro/install/
echo "Installing helm"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
