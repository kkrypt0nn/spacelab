FROM ubuntu:26.04

ARG TARGETARCH

# binwalk
# https://github.com/ReFirmLabs/binwalk
# renovate: datasource=github-tags depName=ReFirmLabs/binwalk
ARG BINWALK_VERSION="3.1.0"

# dcfldd
# https://packages.ubuntu.com/resolute/dcfldd
# renovate: datasource=deb depName=dcfldd
ARG DCFLDD_VERSION="1.9.3-2"

# exiftool
# https://packages.ubuntu.com/resolute/libimage-exiftool-perl
# renovate: datasource=deb depName=libimage-exiftool-perl
ARG EXIFTOOL_VERSION="13.50+dfsg-1"

# Foremost
# https://packages.ubuntu.com/resolute/foremost
# renovate: datasource=deb depName=foremost
ARG FOREMOST_VERSION="1.5.7-11build1"

# Hayabusa
# https://github.com/Yamato-Security/hayabusa
# renovate: datasource=github-tags depName=Yamato-Security/hayabusa
ARG HAYABUSA_VERSION="4.4.0"

# Scalpel
# https://packages.ubuntu.com/resolute/scalpel
# renovate: datasource=deb depName=scalpel
ARG SCALPEL_VERSION="1.60+git20240110.6960eb2-2build1"

# TestDisk & PhotoRec
# https://packages.ubuntu.com/resolute/testdisk
# renovate: datasource=deb depName=testdisk
ARG TESTDISK_VERSION="7.2-0.1build1"

# The Sleuth Kit
# https://packages.ubuntu.com/resolute/sleuthkit
# renovate: datasource=deb depName=sleuthkit
ARG TSK_VERSION="4.12.1+dfsg-3build1"

# Volatility 3
# https://github.com/volatilityfoundation/volatility3
# renovate: datasource=github-tags depName=volatilityfoundation/volatility3
ARG VOLATILITY3_VERSION="2.28.2"

# YARA
# https://packages.ubuntu.com/resolute/yara
# renovate: datasource=deb depName=yara
ARG YARA_VERSION="4.5.5-1"

# YARA-X
# https://github.com/VirusTotal/yara-x
# renovate: datasource=github-tags depName=VirusTotal/yara-x
ARG YARA_X_VERSION="1.24.0"

RUN apt update && apt install -y --no-install-recommends \
      autoconf \
      automake \
      build-essential \
      ca-certificates \
      cargo \
      file \
      gpgv \
      libfontconfig1-dev \
      libjpeg-dev \
      libusb-1.0-0-dev \
      pkg-config \
      python3 \
      python3-dev \
      python3-pip \
      tar \
      unzip \
      wget \
      "dcfldd=${DCFLDD_VERSION}" \
      "libimage-exiftool-perl=${EXIFTOOL_VERSION}}" \
      "foremost=${FOREMOST_VERSION}" \
      "scalpel=${SCALPEL_VERSION}" \
      "testdisk=${TESTDISK_VERSION}" \
      "sleuthkit=${TSK_VERSION}" \
      "yara=${YARA_VERSION}" && \
    rm -rf /var/lib/apt/lists/*

# binwalk
RUN TMP="$(mktemp)" && \
    wget -O "${TMP}" "https://github.com/ReFirmLabs/binwalk/archive/refs/tags/v${BINWALK_VERSION}.zip" && \
    mkdir -p "/tmp/binwalk" && \
    unzip -q "${TMP}" -d "/tmp/binwalk/" && \
    rm "${TMP}" && \
    cd "/tmp/binwalk/binwalk-${BINWALK_VERSION}" && \
    cargo build --release && \
    mkdir -p "/opt/binwalk" && \
    mv "target/release/binwalk" "/opt/binwalk/binwalk" && \
    ln -sf "/opt/binwalk/binwalk" "/usr/local/bin/binwalk" && \
    rm -r "/tmp/binwalk/"

# Hayabusa
RUN case "${TARGETARCH}" in \
      amd64) HAYABUSA_ARCH="x64-gnu" ;; \
      arm64) HAYABUSA_ARCH="aarch64-gnu" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    TMP="$(mktemp)" && \
    wget -O "${TMP}" "https://github.com/Yamato-Security/hayabusa/releases/download/v${HAYABUSA_VERSION}/hayabusa-${HAYABUSA_VERSION}-lin-${HAYABUSA_ARCH}.zip" && \
    mkdir -p "/opt/hayabusa" && \
    unzip -q "${TMP}" -d "/opt/hayabusa/" && \
    rm "${TMP}" && \
    mv "/opt/hayabusa/hayabusa-${HAYABUSA_VERSION}-lin-${HAYABUSA_ARCH}" "/opt/hayabusa/hayabusa" && \
    chmod +x "/opt/hayabusa/hayabusa" && \
    ln -sf "/opt/hayabusa/hayabusa" "/usr/local/bin/hayabusa"

# Volatility 3
RUN TMP="$(mktemp)" && \
    wget -O "${TMP}" "https://github.com/volatilityfoundation/volatility3/archive/refs/tags/v${VOLATILITY3_VERSION}.zip" && \
    mkdir -p "/opt/volatility3" && \
    unzip -q "${TMP}" -d "/opt/volatility3/" && \
    rm "${TMP}" && \
    cd "/opt/volatility3/volatility3-${VOLATILITY3_VERSION}" && \
    pip install --user -e ".[full]" --break-system-packages
ENV PATH="/root/.local/bin:${PATH}"

# YARA-X
RUN case "${TARGETARCH}" in \
      amd64) YARA_X_ARCH="x86_64" ;; \
      arm64) YARA_X_ARCH="aarch64" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    TMP="$(mktemp)" && \
    wget -O "${TMP}" "https://github.com/VirusTotal/yara-x/releases/download/v${YARA_X_VERSION}/yara-x-v${YARA_X_VERSION}-${YARA_X_ARCH}-unknown-linux-gnu.tar.gz" && \
    mkdir -p "/opt/yara-x" && \
    tar -xzf "${TMP}" -C "/opt/yara-x/" && \
    rm "${TMP}" && \
    chmod +x "/opt/yara-x/yr" && \
    ln -sf "/opt/yara-x/yr" "/usr/local/bin/yr"

# Cleanup
RUN apt purge -y \
      build-essential \
      cargo \
      autoconf \
      automake \
      pkg-config \
      python3-dev \
      libjpeg-dev \
      libusb-1.0-0-dev && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.cargo && \
    rm -rf /root/.cache && \
    rm -rf /tmp

WORKDIR /lab

ENTRYPOINT ["/bin/bash"]
