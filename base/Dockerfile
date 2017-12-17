ARG BUILD_FROM=debian:stretch-slim
FROM ${BUILD_FROM}

# Environment variables
ENV \
    DEBIAN_FRONTEND="noninteractive" \
    HOME="/root" \
    LANG="C.UTF-8" \
    PS1="$(whoami)@$(hostname):$(pwd)$ " \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES=1 \
    TERM="xterm"

# Copy root filesystem
COPY rootfs /

# Install base system
ARG BUILD_ARCH=amd64
RUN \
    apt-get update \
    \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        udev \
        jq \
        tzdata \
    \
    && if [ "${BUILD_ARCH}" = "i386" ]; then S6_ARCH="x86"; else S6_ARCH="${BUILD_ARCH}"; fi \
    \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v1.20.0.0/s6-overlay-${S6_ARCH}.tar.gz" \
        | tar zxvf - -C / \
    \
    && if [ "${BUILD_ARCH}" = "i386" ]; then SEMVER_ARCH="386"; \
        elif [ "${BUILD_ARCH}" = "aarch64" ] || [ "${BUILD_ARCH}" = "armhf" ]; then SEMVER_ARCH="arm"; \
        else SEMVER_ARCH="${BUILD_ARCH}"; fi \
    \
    && curl -L -s "https://github.com/frenck/semver/releases/download/v0.1.0/semver_linux_${SEMVER_ARCH}.tar.gz" \
        | tar zxvf - -C /usr/bin/ \
    \
    && mkdir -p /etc/fix-attrs.d \
    \
    && \
        if [ "${BUILD_ARCH}" != "armhf" ]; then \
            rm -f /usr/bin/qemu-arm-static; \
        fi \
    \
    && \
        if [ "${BUILD_ARCH}" != "aarch64" ]; then \
            rm -f /usr/bin/qemu-aarch64-static; \
        fi \
    \
    && rm -f -r \
        /tmp/* \
        /var/lib/apt/lists/*

# Entrypoint & CMD
ENTRYPOINT [ "/init" ]

# Build arugments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Addon Debian base for ${BUILD_ARCH}" \
    io.hass.description="Community Hass.io Add-ons: ${BUILD_ARCH} Debian base image" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="Community Hass.io Add-ons: ${BUILD_ARCH} Debian base image" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Addon Debian base for ${BUILD_ARCH}" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="http://addons.community" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-debian-base/blob/master/README.md" \
    org.label-schema.vcs-ref=${REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-debian-base" \
    org.label-schema.vendor="Franck Nijhof"
