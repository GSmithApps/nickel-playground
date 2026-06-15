FROM mcr.microsoft.com/devcontainers/base:debian

RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

ARG TARGETARCH

RUN set -eux; \
    case "$TARGETARCH" in \
      amd64) ARCH="x86_64" ;; \
      arm64) ARCH="arm64" ;; \
      *) echo "Unsupported arch: $TARGETARCH" && exit 1 ;; \
    esac; \
    curl -fL "https://github.com/nickel-lang/nickel/releases/latest/download/nickel-${ARCH}-linux" \
      -o /usr/local/bin/nickel; \
    curl -fL "https://github.com/nickel-lang/nickel/releases/latest/download/nls-${ARCH}-linux" \
      -o /usr/local/bin/nls; \
    chmod +x /usr/local/bin/nickel /usr/local/bin/nls