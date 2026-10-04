#!/usr/bin/env bash
# Downloads the theme and Hugo modules listed in modules.lock into the
# folder given as $1 (Hugo's themesDir), checking each SHA-256. A module
# is fetched again only when its line in modules.lock changes.
# Used by the Docs app (addons/docs/run.sh) and `mise run docs:serve`.
set -euo pipefail

dest="$1"
lock="$(dirname "$0")/modules.lock"
mkdir -p "$dest"

sha256() { if command -v sha256sum >/dev/null; then sha256sum "$1"; else shasum -a 256 "$1"; fi | cut -d' ' -f1; }

grep -v '^\s*\(#\|$\)' "$lock" | while read -r name sum url sub; do
  stamp="$dest/$name/.lock-line"
  line="$sum $url $sub"
  [[ -f "$stamp" && "$(cat "$stamp")" == "$line" ]] && continue
  echo "Fetching $name"
  tmp="$(mktemp)"
  curl -fsSL -o "$tmp" "$url"
  if [[ "$(sha256 "$tmp")" != "$sum" ]]; then
    echo "Checksum mismatch for $name ($url)" >&2
    rm -f "$tmp"
    exit 1
  fi
  rm -rf "$dest/$name" "$dest/.extract"
  mkdir -p "$dest/.extract"
  tar -xzf "$tmp" -C "$dest/.extract" --strip-components=1
  if [[ -n "$sub" ]]; then
    mv "$dest/.extract/$sub" "$dest/$name"
    rm -rf "$dest/.extract"
  else
    mv "$dest/.extract" "$dest/$name"
  fi
  rm -f "$tmp"
  echo "$line" > "$stamp"
done
