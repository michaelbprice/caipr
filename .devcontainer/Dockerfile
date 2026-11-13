FROM ubuntu:24.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        git \
        gnupg \
        lsb-release \
        ninja-build \
        software-properties-common \
        wget \
    && wget -O /tmp/llvm.sh https://apt.llvm.org/llvm.sh \
    && chmod +x /tmp/llvm.sh \
    && /tmp/llvm.sh \
    && clang_version="$(find /usr/bin -maxdepth 1 -name 'clang-[0-9]*' -printf '%f\n' | sort -V | tail -n 1 | cut -d- -f2)" \
    && ln -s "/usr/bin/clang-${clang_version}" /usr/local/bin/clang \
    && ln -s "/usr/bin/clang++-${clang_version}" /usr/local/bin/clang++ \
    && rm /tmp/llvm.sh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV CC=clang \
    CXX=clang++
