#!/bin/bash

# https://docs.docker.com/engine/install/ubuntu/
echo "Setting up apt Docker repository"
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release -y
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
echo "Manage Docker as a non-root user"
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# https://kubernetes.io/docs/tasks/tools/install-kubectl/
# echo "Installing kubectl"
# curl -L https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl
# sudo chmod +x /usr/local/bin/kubectl
#
# # https://help.ubuntu.com/community/KVM/Installation#Installation_of_KVM
# echo "Installing kvm for minikube"
# sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils -y
# sudo adduser `id -un` libvirt
# sudo adduser `id -un` kvm
#
# echo "Installing minikube"
# curl -L minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -o /usr/local/bin/minikube
# sudo chmod +x /usr/local/bin/minikube
#
# echo "Installing kubectx & kubens"
# git clone https://github.com/ahmetb/kubectx.git
# chmod +x kubectx/kubectx
# sudo mv ./kubectx/kubectx /usr/local/bin/
# chmod +x kubectx/kubens
# sudo mv ./kubectx/kubens /usr/local/bin/
#
# echo "Installing helm"
# curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
# sudo apt-get install apt-transport-https -y
# echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
# sudo apt-get update
# sudo apt-get install helm -y

