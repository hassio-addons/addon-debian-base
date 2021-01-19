ARG BUILD_FROM=debian:buster-20210111-slim
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Environment variables
ENV \
    DEBIAN_FRONTEND="noninteractive" \
    HOME="/root" \
    LANG="C.UTF-8" \
    PS1="$(whoami)@$(hostname):$(pwd)$ " \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES=1 \
    TERM="xterm-256color"

# Copy root filesystem
COPY rootfs /

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install base system
# hadolint ignore=DL4001
ARG BUILD_ARCH=amd64
RUN \
    apt-get update \
    \
    && apt-get install -y --no-install-recommends \
        bash=5.0-4 \
        ca-certificates=20200601~deb10u1 \
        curl=7.64.0-4+deb10u1 \
        jq=1.5+dfsg-2+b1 \
        tzdata=2020e-0+deb10u1 \
        openssl=1.1.1d-0+deb10u4 \
    \
    && S6_ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "i386" ]; then S6_ARCH="x86"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then S6_ARCH="arm"; fi \
    && if [ "${BUILD_ARCH}" = "armhf" ]; then S6_ARCH="armhf"; fi \
    \
    && echo "https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.2/s6-overlay-${S6_ARCH}.tar.gz" \
    && wget "https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.2/s6-overlay-${S6_ARCH}.tar.gz" \
    && curl -L -v "https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.2/s6-overlay-${S6_ARCH}.tar.gz" \
        | tar zxvf - -C / \
    \
    && mkdir -p /etc/fix-attrs.d \
    && mkdir -p /etc/services.d \
    \
    && curl -J -L -o /tmp/bashio.tar.gz \
        "https://github.com/hassio-addons/bashio/archive/v0.9.0.tar.gz" \
    && mkdir /tmp/bashio \
    && tar zxvf \
        /tmp/bashio.tar.gz \
        --strip 1 -C /tmp/bashio \
    \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    \
    && rm -fr \
        /tmp/* \
        /var/{cache,log}/* \
        /var/lib/apt/lists/*

# Entrypoint & CMD
ENTRYPOINT [ "/init" ]

# Build arugments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION
ARG BUILD_REPOSITORY

# Labels
LABEL \
    io.hass.name="Addon Debian base for ${BUILD_ARCH}" \
    io.hass.description="Home Assistant Community Add-on: ${BUILD_ARCH} Debian base image" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="base" \
    io.hass.version=${BUILD_VERSION} \
    io.hass.base.version=${BUILD_VERSION} \
    io.hass.base.name="debian" \
    io.hass.base.image="hassioaddons/debian-base" \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.title="Addon Debian base for ${BUILD_ARCH}" \
    org.opencontainers.image.description="Home Assistant Community Add-on: ${BUILD_ARCH} Debian base image" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
