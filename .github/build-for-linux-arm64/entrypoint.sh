#!/bin/bash

# 设置 Rust 默认工具链为稳定版本
rustup default stable
rustup --version

wget https://nodejs.org/dist/v20.17.0/node-v20.17.0-linux-arm64.tar.xz
tar -Jxvf ./node-v20.17.0-linux-arm64.tar.xz
export PATH=$(pwd)/node-v20.17.0-linux-arm64/bin:$PATH
npm install pnpm -g

rustup target add "$INPUT_TARGET"

if [ "$INPUT_TARGET" = "aarch64-unknown-linux-gnu" ]; then
    apt-get update
    apt-get install -y libwebkit2gtk-4.1-dev libappindicator3-dev librsvg2-dev patchelf
else
    echo "Unknown target: $INPUT_TARGET" && exit 1
fi

bash .github/build-for-linux-arm64/build.sh
