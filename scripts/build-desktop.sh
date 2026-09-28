#!/bin/bash
# Build the Open Cube desktop window — the Rust engine and the web client in
# one application bundle — and put it where it can be opened.
#
# This is not the release pipeline: no dmg, no installer, no signing identity.
# `scripts/package-release.sh` still owns shipping, and the Swift bundle in
# `dist/` is untouched until #33 retires it.
#
#   scripts/build-desktop.sh            build it
#   scripts/build-desktop.sh --open     build it and open the window
#   scripts/build-desktop.sh --install  also copy it into /Applications
set -euo pipefail
cd "$(dirname "$0")/.."

open_after=0
install_after=0
for argument in "$@"; do
  case "$argument" in
    --open) open_after=1 ;;
    --install) install_after=1 ;;
    *) printf 'Unknown option: %s\n' "$argument" >&2; exit 2 ;;
  esac
done

if [ "$(uname -s)" != "Darwin" ]; then
  printf 'This script bundles the macOS app. On Windows and Linux run: pnpm app:build\n' >&2
  exit 1
fi

printf 'Building the client and the window…\n'
# `--bundles app` skips the dmg: it doubles the time and nothing here needs it.
pnpm exec tauri build --config crates/app/tauri.conf.json --bundles app

built="target/release/bundle/macos/Open Cube.app"
[ -d "$built" ] || { printf 'Bundle missing: %s\n' "$built" >&2; exit 1; }

# Its own folder: the Swift bundle and the installer still use dist/ directly.
destination="dist/desktop"
mkdir -p "$destination"
rm -rf "$destination/Open Cube.app"
cp -R "$built" "$destination/Open Cube.app"

printf 'Built: %s/%s/Open Cube.app\n' "$PWD" "$destination"

if [ "$install_after" -eq 1 ]; then
  rm -rf "/Applications/Open Cube.app"
  cp -R "$destination/Open Cube.app" "/Applications/Open Cube.app"
  printf 'Installed: /Applications/Open Cube.app\n'
fi

if [ "$open_after" -eq 1 ]; then
  open "$destination/Open Cube.app"
fi
