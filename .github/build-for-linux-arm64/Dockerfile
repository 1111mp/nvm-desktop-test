FROM --platform=linux/arm64 ubuntu:22.04

# 安装必要的依赖
RUN apt-get update && \
    apt-get install -y curl build-essential wget

# 安装最新的 Rust 稳定版本
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
ENV PATH="/root/.cargo/bin:${PATH}"

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"] 