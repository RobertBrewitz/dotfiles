#!/bin/bash

set -e

sudo apt install -y libwayland-dev lld mold clang gcc-mingw-w64 cmake libfontconfig1
rustup toolchain install nightly
rustup component add rustc-codegen-cranelift-preview --toolchain nightly
rustup component add rust-analyzer --toolchain nightly
rustup target add wasm32-unknown-unknown
rustup target add x86_64-pc-windows-gnu
rustup target add aarch64-unknown-linux-gnu
cargo install wasm-server-runner wasm-bindgen-cli
