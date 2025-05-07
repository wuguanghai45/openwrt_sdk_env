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

# Download and extract bcm27xx SDK
RUN wget https://downloads.openwrt.org/releases/24.10.1/targets/bcm27xx/bcm2710/openwrt-sdk-24.10.1-bcm27xx-bcm2710_gcc-13.3.0_musl.Linux-x86_64.tar.zst -O /bcm27xx_sdk.tar.zst && \
    mkdir -p /bcm27xx_sdk_extract && \
    zstd -d /bcm27xx_sdk.tar.zst -o /bcm27xx_sdk.tar && \
    tar xf /bcm27xx_sdk.tar -C /bcm27xx_sdk_extract && \
    mv /bcm27xx_sdk_extract/openwrt-sdk-24.10.1-bcm27xx-bcm2710_gcc-13.3.0_musl.Linux-x86_64 /bcm27xx-sdk && \
    rm -f /bcm27xx_sdk.tar.zst /bcm27xx_sdk.tar && \
    rm -rf /bcm27xx_sdk_extract

RUN /bcm27xx-sdk/scripts/feeds update -a

# Download and extract bcm27xx imagebuilder
RUN wget https://downloads.openwrt.org/releases/24.10.1/targets/bcm27xx/bcm2710/openwrt-imagebuilder-24.10.1-bcm27xx-bcm2710.Linux-x86_64.tar.zst -O /bcm27xx_imagebuilder.tar.zst && \
    mkdir -p /bcm27xx_imagebuilder_extract && \
    zstd -d /bcm27xx_imagebuilder.tar.zst -o /bcm27xx_imagebuilder.tar && \
    tar xf /bcm27xx_imagebuilder.tar -C /bcm27xx_imagebuilder_extract && \
    mv /bcm27xx_imagebuilder_extract/openwrt-imagebuilder-24.10.1-bcm27xx-bcm2710.Linux-x86_64 /bcm27xx-imagebuilder && \
    rm -f /bcm27xx_imagebuilder.tar.zst /bcm27xx_imagebuilder.tar && \
    rm -rf /bcm27xx_imagebuilder_extract

RUN cd /bcm27xx-imagebuilder && \
    sed -i '/option check_signature/d' repositories.conf && \
    make image PROFILE="rpi-3"

