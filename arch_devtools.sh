#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090
[ -f "$HOME/.profile" ] && source "$HOME/.profile" || true

echo "Installing terminal/editor dev tools"
sudo pacman -S --noconfirm --needed \
    tmux \
    neovim \
    jq \
    openssl \
    systemd-libs \
    alsa-lib \
    mold \
    lld \
    clang \
    mingw-w64-gcc \
    cmake \
    fontconfig \
    wayland \
    ripgrep \
    fd \
    perf \
    go \
    the_silver_searcher \
    editorconfig-core-c

echo "Installing nvm and node"
if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | NODE_VERSION=--lts bash
fi
# shellcheck disable=SC1090
[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"
if command -v nvm &> /dev/null; then
    nvm install --lts
    nvm alias default 'lts/*'
fi

echo "Installing rust, rust-analyzer, and game-dev Rust targets"
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
fi
# shellcheck disable=SC1091
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
rustup component add rust-analyzer
rustup toolchain install nightly
rustup component add rustc-codegen-cranelift-preview --toolchain nightly
rustup component add rust-analyzer --toolchain nightly
rustup target add wasm32-unknown-unknown
rustup target add x86_64-pc-windows-gnu
rustup target add aarch64-unknown-linux-gnu
cargo install cross --git https://github.com/cross-rs/cross
cargo install wasm-server-runner wasm-bindgen-cli

echo "Installing go and gopls"
export GOPATH="${GOPATH:-$HOME/go}"
export PATH="$GOPATH/bin:$PATH"
go install golang.org/x/tools/gopls@latest

echo "Installing tree-sitter-cli for neovim treesitter"
cargo install tree-sitter-cli

echo "Installing git-completion"
curl -fsSL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o "$HOME/.git-completion.bash"

echo "Dev tools installed."
