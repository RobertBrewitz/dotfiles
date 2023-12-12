#!/bin/bash

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

echo "DONE"
