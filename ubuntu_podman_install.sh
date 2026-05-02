#!/bin/bash

set -e

# https://podman.io/docs/installation#ubuntu
echo "Installing Podman (rootless) and dependencies"
sudo apt-get update
sudo apt-get install -y \
  podman \
  podman-docker \
  podman-compose \
  buildah \
  skopeo \
  uidmap \
  slirp4netns \
  fuse-overlayfs

echo "Configuring subuid/subgid for rootless containers"
if ! grep -q "^${USER}:" /etc/subuid 2>/dev/null; then
  sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER"
fi

echo "Enabling Podman user socket (for Docker API compatibility)"
systemctl --user enable --now podman.socket || true

echo "Configuring container registries"
sudo mkdir -p /etc/containers/registries.conf.d
sudo tee /etc/containers/registries.conf.d/00-unqualified-search.conf <<EOF
unqualified-search-registries = ["docker.io"]
EOF

echo "Configuring custom DNS for containers"
mkdir -p "$HOME/.config/containers"
tee "$HOME/.config/containers/containers.conf" <<EOF
[containers]
dns_servers = ["192.168.50.200"]
EOF

echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
echo ""
echo "Podman installed. The 'docker' command is aliased to podman via podman-docker."
echo "For Docker API compatibility, export:"
echo "  export DOCKER_HOST=unix://\$XDG_RUNTIME_DIR/podman/podman.sock"
echo ""
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
echo ""
echo "DONE — log out and back in for subuid/subgid changes to take effect"
