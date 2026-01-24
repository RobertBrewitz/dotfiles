#!/bin/bash

set -e

sudo pacman -S --noconfirm --needed wayland lld mold clang mingw-w64-gcc cmake fontconfig
rustup toolchain install nightly
rustup component add rustc-codegen-cranelift-preview --toolchain nightly
rustup component add rust-analyzer --toolchain nightly
rustup target add wasm32-unknown-unknown
rustup target add x86_64-pc-windows-gnu
rustup target add aarch64-unknown-linux-gnu
cargo install wasm-server-runner wasm-bindgen-cli
