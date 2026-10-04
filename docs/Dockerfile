# Hugo extended is linked against glibc, so the base is Debian, not Alpine.
# The image is multi-arch; Supervisor builds it on the host.
FROM ghcr.io/home-assistant/base-debian:trixie-2026.08.0

# Keep the version the same as hugo-extended in mise.toml. The Lotus Docs
# theme needs the extended build (it compiles Sass).
ARG BUILD_ARCH
ARG HUGO_VERSION=0.167.0
ARG HUGO_SHA256_ARM64=c73eaba13738754b50de4d07606670d5c0cd2eaaf2057af657cec9efd3b01876
ARG HUGO_SHA256_AMD64=0163f5c3deddac1f494a1629ddc40c65d18de9d5794facd98f7f96ac2c7d8957

RUN set -eux; \
    case "${BUILD_ARCH}" in \
      aarch64) arch=arm64; sum="${HUGO_SHA256_ARM64}" ;; \
      amd64)   arch=amd64; sum="${HUGO_SHA256_AMD64}" ;; \
      *) echo "unsupported arch ${BUILD_ARCH}"; exit 1 ;; \
    esac; \
    curl -fsSL -o /tmp/hugo.tgz \
      "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-${arch}.tar.gz"; \
    echo "${sum}  /tmp/hugo.tgz" | sha256sum -c -; \
    tar -xzf /tmp/hugo.tgz -C /usr/local/bin hugo; \
    rm -f /tmp/hugo.tgz; \
    hugo version

# The site settings are part of the image; the theme is fetched here, at
# build time, so the app starts without the internet. Only the content
# (the docs/ folder in HA /config) is read at runtime, through /opt/content.
COPY site /opt/site
RUN set -eux; \
    rm -rf /opt/site/themes /opt/site/public /opt/site/resources; \
    bash /opt/site/fetch-modules.sh /opt/site/themes; \
    ln -s /homeassistant/docs /opt/content

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
