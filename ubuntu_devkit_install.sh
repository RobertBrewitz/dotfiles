#!/bin/bash

# https://docs.docker.com/engine/install/ubuntu/
echo "Setting up apt Docker repository"
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# https://docs.docker.com/compose/install/
echo "Installing docker-compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

# https://kubernetes.io/docs/tasks/tools/install-kubectl/
echo "Installing kubectl"
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# https://help.ubuntu.com/community/KVM/Installation#Installation_of_KVM
echo "Installing kvm for minikube"
sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils -y
sudo adduser `id -un` libvirt
sudo adduser `id -un` kvm

echo "Installing minikube"
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x ./minikube
sudo mv ./minikube /usr/local/bin/minikube

echo "Installing kubectx & kubens"
git clone https://github.com/ahmetb/kubectx.git
chmod +x kubectx/kubectx
sudo mv ./kubectx/kubectx /usr/local/bin/
chmod +x kubectx/kubens
sudo mv ./kubectx/kubens /usr/local/bin/

echo "Installing helm"
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https -y
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm -y

echo "REBOOT REQUIRED"
