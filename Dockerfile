FROM ubuntu:latest

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
    gettext \
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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create working directory and change to it
WORKDIR /workspace

# RUN image build 
RUN wget https://github.com/wuguanghai45/openwrt_sdk_env/releases/download/v24.10.1/openwrt-imagebuilder-24.10.1-ramips-mt7621.Linux-x86_64.tar.zst -O /imagebuilder.tar.xz && \
    mkdir -p /imagebuilder_extract && \
    tar xf /imagebuilder.tar.xz -C /imagebuilder_extract && \
    mv /imagebuilder_extract/openwrt-imagebuilder-24.10.1-ramips-mt7621.Linux-x86_64 /imagebuilder && \
    rm -f /imagebuilder.tar.xz && \
    rm -rf /imagebuilder_extract

RUN cd /imagebuilder && \
    sed -i '/option check_signature/d' repositories.conf && \
    make image PROFILE="hc_wormhole"

# Download SDK file and extract it
RUN wget https://github.com/wuguanghai45/openwrt_sdk_env/releases/download/v24.10.1/openwrt-sdk-24.10.1-ramips-mt7621_gcc-13.3.0_musl.Linux-x86_64.tar.zst -O /sdk.tar.zst && \
    mkdir -p /openwrt-sdk_extract && \
    zstd -d /sdk.tar.zst -o /sdk.tar && \
    tar xf /sdk.tar -C /openwrt-sdk_extract && \
    mv /openwrt-sdk_extract/openwrt-sdk-24.10.1-ramips-mt7621_gcc-13.3.0_musl.Linux-x86_64 /openwrt-sdk && \
    rm -f /sdk.tar.zst /sdk.tar && \
    rm -rf /openwrt-sdk_extract

RUN /openwrt-sdk/scripts/feeds update -a


# Download sunxi imagebuilder
RUN wget https://downloads.openwrt.org/releases/24.10.1/targets/sunxi/cortexa7/openwrt-imagebuilder-24.10.1-sunxi-cortexa7.Linux-x86_64.tar.zst -O /sunxi_imagebuilder.tar.zst && \
    mkdir -p /sunxi_imagebuilder_extract && \
    zstd -d /sunxi_imagebuilder.tar.zst -o /sunxi_imagebuilder.tar && \
    tar xf /sunxi_imagebuilder.tar -C /sunxi_imagebuilder_extract && \
    mv /sunxi_imagebuilder_extract/openwrt-imagebuilder-24.10.1-sunxi-cortexa7.Linux-x86_64 /sunxi-imagebuilder && \
    rm -f /sunxi_imagebuilder.tar.zst /sunxi_imagebuilder.tar && \
    rm -rf /sunxi_imagebuilder_extract

# Download sunxi sdk
RUN wget https://downloads.openwrt.org/releases/24.10.1/targets/sunxi/cortexa7/openwrt-sdk-24.10.1-sunxi-cortexa7_gcc-13.3.0_musl_eabi.Linux-x86_64.tar.zst -O /sunxi_sdk.tar.zst && \
    mkdir -p /sunxi_sdk_extract && \
    zstd -d /sunxi_sdk.tar.zst -o /sunxi_sdk.tar && \
    tar xf /sunxi_sdk.tar -C /sunxi_sdk_extract && \
    mv /sunxi_sdk_extract/openwrt-sdk-24.10.1-sunxi-cortexa7_gcc-13.3.0_musl_eabi.Linux-x86_64 /sunxi-sdk && \
    rm -f /sunxi_sdk.tar.zst /sunxi_sdk.tar && \
    rm -rf /sunxi_sdk_extract

RUN /sunxi-sdk/scripts/feeds update -a
