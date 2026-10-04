#!/usr/bin/with-contenv bashio
# Serves the docs site to ingress.
#
# The site (hugo.toml, theme) is in the image at /opt/site. The content is
# the docs/ folder in HA /config, mounted read-only at /homeassistant and
# linked at /opt/content.
#
# `hugo server` renders to memory and rebuilds when a page changes, so
# copying new docs to the host is enough.
# --poll: the files change in another container (Samba, SSH); polling does
# not depend on inotify events crossing the bind mount.
set -e

if ! bashio::fs.directory_exists /homeassistant/docs; then
  bashio::exit.nok "/homeassistant/docs is missing. Copy the docs/ folder to /config on the host."
fi

mkdir -p /data/cache /data/resources
export HUGO_RESOURCEDIR=/data/resources

bashio::log.info "Serving the docs on the ingress port."
exec hugo server \
  --source /opt/site \
  --cacheDir /data/cache \
  --noBuildLock \
  --renderToMemory \
  --disableLiveReload \
  --poll 10s \
  --bind 0.0.0.0 \
  --port 8099 \
  --baseURL / \
  --appendPort=false
