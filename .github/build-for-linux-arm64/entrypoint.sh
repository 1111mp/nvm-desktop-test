#!/bin/bash

# 设置 Rust 默认工具链为稳定版本
rustup default stable
rustup --version

wget https://nodejs.org/dist/v20.17.0/node-v20.17.0-linux-x64.tar.xz
tar -Jxvf ./node-v20.17.0-linux-x64.tar.xz
export PATH=$(pwd)/node-v20.17.0-linux-x64/bin:$PATH
npm install pnpm -g

rustup target add "$INPUT_TARGET"

if [ "$INPUT_TARGET" = "aarch64-unknown-linux-gnu" ]; then
		dpkg --add-architecture arm64
    apt-get update
		apt-get install -y python3:arm64 build-essential:arm64 python3-mako:arm64 python3-markdown:arm64
		apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu pkg-config libssl3:arm64
		apt-get --fix-broken install
    apt-get install -y libwebkit2gtk-4.1-dev:arm64 libappindicator3-dev:arm64 librsvg2-dev:arm64 patchelf:arm64
		apt-get --fix-broken install
		export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-linux-gnu-gcc
    export CC_aarch64_unknown_linux_gnu=aarch64-linux-gnu-gcc
    export CXX_aarch64_unknown_linux_gnu=aarch64-linux-gnu-g++
		export PKG_CONFIG_SYSROOT_DIR=/usr/aarch64-linux-gnu
		export PKG_CONFIG_ALLOW_CROSS=1
else
    echo "Unknown target: $INPUT_TARGET" && exit 1
fi

bash .github/build-for-linux-arm64/build.sh