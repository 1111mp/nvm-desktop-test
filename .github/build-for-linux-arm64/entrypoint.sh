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
		apt-get install -y gcc-aarch64-linux-gnu

		dpkg --add-architecture arm64
		# 替换 sources.list 文件内容
		# 使用 'cat' 替换 sources.list 文件内容
		sudo bash -c 'cat <<EOL > /etc/apt/sources.list
		deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ jammy main restricted
		deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ jammy-updates main restricted
		deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ jammy universe
		deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ jammy-updates universe
		deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ jammy multiverse
		deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ jammy-updates multiverse
		deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse
		deb [arch=amd64] http://security.ubuntu.com/ubuntu/ jammy-security main restricted
		deb [arch=amd64] http://security.ubuntu.com/ubuntu/ jammy-security universe
		deb [arch=amd64] http://security.ubuntu.com/ubuntu/ jammy-security multiverse

		# 添加 Ubuntu ports 源
		deb [arch=armhf,arm64] http://ports.ubuntu.com/ubuntu-ports jammy main restricted
		deb [arch=armhf,arm64] http://ports.ubuntu.com/ubuntu-ports jammy-updates main restricted
		deb [arch=armhf,arm64] http://ports.ubuntu.com/ubuntu-ports jammy universe
		deb [arch=armhf,arm64] http://ports.ubuntu.com/ubuntu-ports jammy-updates universe
		deb [arch=armhf,arm64] http://ports.ubuntu.com/ubuntu-ports jammy multiverse
		deb [arch=armhf,arm64] http://ports.ubuntu.com/ubuntu-ports jammy-updates multiverse
		deb [arch=armhf,arm64] http://ports.ubuntu.com/ubuntu-ports jammy-backports main restricted universe multiverse
		deb [arch=armhf,arm64] http://ports.ubuntu.com/ubuntu-ports jammy-security main restricted
		deb [arch=armhf,arm64] http://ports.ubuntu.com/ubuntu-ports jammy-security universe
		deb [arch=armhf,arm64] http://ports.ubuntu.com/ubuntu-ports jammy-security multiverse
		EOL'

    apt-get update
		apt-get upgrade -y
		apt-get install -y libssl-dev:arm64
    apt-get install -y libwebkit2gtk-4.1-dev:arm64 libappindicator3-dev:arm64 librsvg2-dev:arm64 patchelf:arm64
		apt-get --fix-broken install
		export PKG_CONFIG_SYSROOT_DIR=/usr/aarch64-linux-gnu/
		export PKG_CONFIG_ALLOW_CROSS=1
else
    echo "Unknown target: $INPUT_TARGET" && exit 1
fi

bash .github/build-for-linux-arm64/build.sh