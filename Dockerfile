FROM ubuntu:24.04

# Install required dependencies for OpenWrt SDK
RUN apt-get update && apt-get install -y \
    build-essential \
    clang \
    flex \
    bison \
    g++ \
    gawk \
    gcc-multilib \
    g++-multilib \
    git \
    libncurses5-dev \
    libssl-dev \
    python3-setuptools \
    rsync \
    swig \
    unzip \
    sudo \
    zlib1g-dev \
    file \
    wget \
    zstd \
    python3 \
    python3-pip \
    pyhton3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash builder && \
    echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create working directory and change to it
RUN mkdir -p /home/builder/workspace
WORKDIR /home/builder/workspace

# Set correct permissions
RUN sudo chown -R builder:builder /home/builder

# Download SDK file and extract it
USER builder
RUN wget https://github.com/wuguanghai45/openwrt_sdk_env/releases/download/v24.10.0/openwrt-sdk-24.10.0-ramips-mt7621_gcc-13.3.0_musl.Linux-x86_64.tar.zst -O /home/builder/sdk.tar.zst && \
    mkdir -p /home/builder/openwrt-sdk_extract && \
    zstd -d /home/builder/sdk.tar.zst -o /home/builder/sdk.tar && \
    tar xf /home/builder/sdk.tar -C /home/builder/openwrt-sdk_extract && \
    mv /home/builder/openwrt-sdk_extract/openwrt-sdk-24.10.0-ramips-mt7621_gcc-13.3.0_musl.Linux-x86_64 /home/builder/openwrt-sdk && \
    rm -f /home/builder/sdk.tar.zst /home/builder/sdk.tar

RUN chown -R builder:builder /home/builder/openwrt-sdk

RUN cd /home/builder/openwrt-sdk && ./scripts/feeds update -a && ./scripts/feeds install -a

