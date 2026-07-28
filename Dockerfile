FROM ubuntu:26.04@sha256:3131b4cc82a783df6c9df078f86e01819a13594b865c2cad47bd1bca2b7063bb

ARG TARGETARCH

# binwalk
# https://github.com/ReFirmLabs/binwalk
ARG BINWALK_VERSION="3.1.0"
ARG BINWALK_HASH="fabf028b31679ffea7a4b10df5ab7be7d73eb1ff3f7772909fb7955c85003efe"

# dcfldd
# https://packages.ubuntu.com/resolute/dcfldd
ARG DCFLDD_VERSION="1.9.3-2"

# Foremost
# https://packages.ubuntu.com/resolute/foremost
ARG FOREMOST_VERSION="1.5.7-11build1"

# Hayabusa
# https://github.com/Yamato-Security/hayabusa
ARG HAYABUSA_VERSION="3.10.0"

# Scalpel
# https://packages.ubuntu.com/resolute/scalpel
ARG SCALPEL_VERSION="1.60+git20240110.6960eb2-2build1"

# TestDisk & PhotoRec
# https://packages.ubuntu.com/resolute/testdisk
ARG TESTDISK_VERSION="7.2-0.1build1"

# The Sleuth Kit
# https://packages.ubuntu.com/resolute/sleuthkit
ARG TSK_VERSION="4.12.1+dfsg-3build1"

# Volatility 3
# https://github.com/volatilityfoundation/volatility3
ARG VOLATILITY3_VERSION="2.28.0"
ARG VOLATILITY3_HASH="b3fef4524bf1c3937225c347c5a91b6b3408a7156ceb0116801dc1dfd856a85c"

# YARA
# https://packages.ubuntu.com/resolute/yara
ARG YARA_VERSION="4.5.5-1"

RUN apt update && apt install -y --no-install-recommends \
      autoconf \
      automake \
      build-essential \
      ca-certificates \
      cargo \
      file \
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
      "foremost=${FOREMOST_VERSION}" \
      "scalpel=${SCALPEL_VERSION}" \
      "testdisk=${TESTDISK_VERSION}" \
      "sleuthkit=${TSK_VERSION}" \
      "yara=${YARA_VERSION}" && \
    rm -rf /var/lib/apt/lists/*

# binwalk
RUN TMP="$(mktemp)" && \
    wget -O "${TMP}" "https://github.com/ReFirmLabs/binwalk/archive/refs/tags/v${BINWALK_VERSION}.zip" && \
    echo "${BINWALK_HASH} ${TMP}" | sha256sum -c - && \
    mkdir -p "/tmp/binwalk" && \
    unzip -q "${TMP}" -d "/tmp/binwalk/" && \
    rm "${TMP}" && \
    cd "/tmp/binwalk/binwalk-${BINWALK_VERSION}" && \
    cargo install \
      --locked \
      --path . && \
    rm -r "/tmp/binwalk/"

# Hayabusa
RUN case "${TARGETARCH}" in \
      amd64) HAYABUSA_ARCH="x64-gnu"; HAYABUSA_HASH="5879131758c142b0d30d14e4b3f4019155507384d22ad1ce55868670325a071c" ;; \
      arm64) HAYABUSA_ARCH="aarch64-gnu"; HAYABUSA_HASH="726623a238549c3274ae998ec11de7b205f728ebd592a776cd6eb8d82a3746ad" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    TMP="$(mktemp)" && \
    wget -O "${TMP}" "https://github.com/Yamato-Security/hayabusa/releases/download/v${HAYABUSA_VERSION}/hayabusa-${HAYABUSA_VERSION}-lin-${HAYABUSA_ARCH}.zip" && \
    echo "${HAYABUSA_HASH} ${TMP}" | sha256sum -c - && \
    mkdir -p "/opt/hayabusa" && \
    unzip -q "${TMP}" -d "/opt/hayabusa/" && \
    rm "${TMP}" && \
    chmod +x "/opt/hayabusa/hayabusa-${HAYABUSA_VERSION}-lin-${HAYABUSA_ARCH}" && \
    ln -sf "/opt/hayabusa/hayabusa-${HAYABUSA_VERSION}-lin-${HAYABUSA_ARCH}" "/usr/local/bin/hayabusa"

# Volatility 3
RUN TMP="$(mktemp)" && \
    wget -O "${TMP}" "https://github.com/volatilityfoundation/volatility3/archive/refs/tags/v${VOLATILITY3_VERSION}.zip" && \
    echo "${VOLATILITY3_HASH} ${TMP}" | sha256sum -c - && \
    mkdir -p "/opt/volatility3" && \
    unzip -q "${TMP}" -d "/opt/volatility3/" && \
    rm "${TMP}" && \
    cd "/opt/volatility3/volatility3-${VOLATILITY3_VERSION}" && \
    pip install --user -e ".[full]" --break-system-packages
ENV PATH="/root/.local/bin:${PATH}"

# Cleanup
RUN apt purge -y \
      build-essential \
      cargo \
      autoconf \
      automake \
      pkg-config \
      python3-dev \
      libfontconfig1-dev \
      libjpeg-dev \
      libusb-1.0-0-dev && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /lab

ENTRYPOINT ["/bin/bash"]
