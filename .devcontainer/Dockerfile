FROM ubuntu:24.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        binutils \
        ca-certificates \
        cmake \
        curl \
        libc6-dev \
        libstdc++-14-dev \
        make \
        xz-utils \
    && llvm_version="$(curl -fsSL https://api.github.com/repos/llvm/llvm-project/releases/latest | sed -n 's/.*"tag_name":[[:space:]]*"llvmorg-\([^"]*\)".*/\1/p')" \
    && test -n "$llvm_version" \
    && case "$(dpkg --print-architecture)" in \
        amd64) llvm_arch=X64 ;; \
        arm64) llvm_arch=ARM64 ;; \
        *) echo "Unsupported architecture: $(dpkg --print-architecture)" >&2; exit 1 ;; \
    esac \
    && curl -fsSL "https://github.com/llvm/llvm-project/releases/download/llvmorg-${llvm_version}/LLVM-${llvm_version}-Linux-${llvm_arch}.tar.xz" -o /tmp/llvm.tar.xz \
    && mkdir -p /opt/llvm \
    && tar -xJf /tmp/llvm.tar.xz --strip-components=1 -C /opt/llvm \
    && rm /tmp/llvm.tar.xz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/opt/llvm/bin:${PATH}" \
    CC=clang \
    CXX=clang++
