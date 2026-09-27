#!/bin/sh
set -e

repo=7iambatman7/madwine
dir="${XDG_DATA_HOME:-$HOME/.local/share}/madwine"
app="$dir/Madwine.AppImage"

get() { curl -fsSL "$1" 2>/dev/null || wget -qO- "$1"; }
fetch() { curl -fL# -o "$2" "$1" 2>/dev/null || wget -O "$2" "$1"; }

url=$(get "https://api.github.com/repos/$repo/releases/latest" | grep -o 'https://[^"]*_amd64\.AppImage' | head -1)
[ -n "$url" ] || { echo "no madwine release found, check https://github.com/$repo/releases" >&2; exit 1; }

mkdir -p "$dir"
echo "downloading $(basename "$url")"
fetch "$url" "$app"
chmod +x "$app"
"$app" "$@" || "$app" --appimage-extract-and-run "$@"
