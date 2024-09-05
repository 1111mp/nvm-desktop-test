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
    apt-get update
    apt-get install -y libwebkit2gtk-4.1-dev libappindicator3-dev librsvg2-dev patchelf
    # 设置交叉编译环境变量
    export CC_aarch64_unknown_linux_gnu=aarch64-linux-gnu-gcc
    export CXX_aarch64_unknown_linux_gnu=aarch64-linux-gnu-g++
    export AR_aarch64_unknown_linux_gnu=aarch64-linux-gnu-ar
    export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-linux-gnu-gcc
    # 配置 pkg-config 环境变量
    export PKG_CONFIG_ALLOW_CROSS=1
    export PKG_CONFIG_SYSROOT_DIR=/
    export PKG_CONFIG_LIBDIR=/usr/lib/aarch64-linux-gnu/pkgconfig:/usr/share/pkgconfig
    export PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig
else
    echo "Unknown target: $INPUT_TARGET" && exit 1
fi

bash .github/build-for-linux-arm64/build.sh
