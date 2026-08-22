#!/usr/bin/env bash
# build-packages.sh
# ---------------------------------------------------------------------------
# Reproducibly build Vulkan-Typing-Studio portable release packages.
#
# - Fully offline. Requires only: zip, tar, sha256sum (standard on Linux/macOS).
# - No npm, no network, no build step. Each package is a self-contained archive
#   holding the standalone HTML app plus a one-click launcher, README and LICENSE.
# - Output lands in the repository root, matching the existing convention used
#   by the previous Windows 7 ZIP.
#
# The Windows 7 package is built strictly from release/win7/* sources and never
# shares code with the modern packages, so modern builds cannot regress because
# of Windows 7 support.
# ---------------------------------------------------------------------------
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT_DIR="$REPO_ROOT"

APP_HTML="$SCRIPT_DIR/Vulkan-Typing-Studio-Standalone.html"
LICENSE="$REPO_ROOT/LICENSE"
WIN7_DIR="$SCRIPT_DIR/win7"

# Keep in sync with package.json version.
VERSION="0.7.0"

for tool in zip tar sha256sum; do
  command -v "$tool" >/dev/null 2>&1 || { echo "Required tool missing: $tool" >&2; exit 1; }
done
[ -f "$APP_HTML" ] || { echo "Missing $APP_HTML" >&2; exit 1; }
[ -f "$LICENSE" ]  || { echo "Missing $LICENSE"  >&2; exit 1; }
[ -d "$WIN7_DIR" ] || { echo "Missing $WIN7_DIR" >&2; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

APP_NAME="Vulkan-Typing-Studio"

# ---------------------------------------------------------------------------
# Modern, platform-agnostic quick-start README (shared by Win/Linux/macOS).
# ---------------------------------------------------------------------------
MODERN_README="$(cat <<'README_EOF'
VULKAN TYPING STUDIO — PORTABLE PACKAGE
=======================================
Version: 0.7.0 (V7)

A single-file, offline-first typing app for English and Hindi.
No installation, no account, no telemetry, and no network access.

HOW TO RUN
----------
1. Extract this folder anywhere you like (for example your Desktop or Documents).
2. Run the launcher for your platform:
     Windows : double-click  Start.bat
     Linux   : ./start.sh            (first time: chmod +x start.sh)
     macOS   : double-click  start.command   (first time: right-click > Open)
   Or simply double-click:
     Vulkan-Typing-Studio-Standalone.html
   It opens in your default web browser.

WHAT'S INSIDE
-------------
Vulkan-Typing-Studio-Standalone.html   The entire application (one file).
Start.bat / start.sh / start.command   One-click launchers.
README.txt                             This file.
LICENSE                                Apache License 2.0.

REQUIREMENTS
------------
Any modern, up-to-date browser: Microsoft Edge, Google Chrome,
Mozilla Firefox, Apple Safari, or Brave.
- Windows 8.1 or later
- Linux (any current distribution that ships a browser)
- macOS 11 (Big Sur) or later, on Apple Silicon or Intel

This package is NOT for Windows 7. For Windows 7, download the separate
"Vulkan-Typing-Studio-Windows7-Portable.zip" release asset instead.

FONTS
-----
Font binaries are not bundled because of their licenses. Install properly
licensed copies of the requested fonts for full coverage:
  Kruti Dev 010, Mangal, Nirmala UI, Shruti, Chanakya, Poor Richard,
  Arial, Georgia.
If a font is unavailable, the app falls back to available system fonts.

PRIVACY
-------
Everything runs locally inside your browser. Nothing is uploaded or phoned home.

Learn more: https://github.com/anacondy/Vulkan-Typing-Studio
README_EOF
)"

# ---------------------------------------------------------------------------
# Launchers (modern packages). .bat gets CRLF; .sh/.command stay LF.
# ---------------------------------------------------------------------------
WIN_LAUNCHER="$(cat <<'BAT_EOF'
@echo off
rem Vulkan Typing Studio - modern Windows launcher (Windows 8.1 / 10 / 11)
rem Opens the standalone app in your default web browser. No install, no network.
setlocal
set "APP=%~dp0Vulkan-Typing-Studio-Standalone.html"
if not exist "%APP%" (
  echo Cannot find Vulkan-Typing-Studio-Standalone.html next to this script.
  pause
  exit /b 1
)
start "" "%APP%"
exit /b 0
BAT_EOF
)"

LINUX_LAUNCHER="$(cat <<'SH_EOF'
#!/usr/bin/env sh
# Vulkan Typing Studio - Linux launcher
# Opens the standalone app in your default web browser. No install, no network.
set -e
APP="$(dirname "$0")/Vulkan-Typing-Studio-Standalone.html"
if [ ! -f "$APP" ]; then
  echo "Cannot find Vulkan-Typing-Studio-Standalone.html next to this script." >&2
  exit 1
fi
xdg-open "$APP" >/dev/null 2>&1 || echo "Could not open a browser automatically. Open this file manually: $APP"
SH_EOF
)"

MAC_LAUNCHER="$(cat <<'MAC_EOF'
#!/usr/bin/env sh
# Vulkan Typing Studio - macOS launcher
# Opens the standalone app in your default web browser. No install, no network.
APP="$(dirname "$0")/Vulkan-Typing-Studio-Standalone.html"
if [ ! -f "$APP" ]; then
  echo "Cannot find Vulkan-Typing-Studio-Standalone.html next to this script." >&2
  exit 1
fi
open "$APP"
MAC_EOF
)"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
to_crlf() { sed -e 's/\r$//' -e 's/$/\r/' -- "$1"; }

# Write a SHA256SUMS.txt inside a package directory (sorted, relative names).
write_internal_sums() {
  local dir="$1"
  ( cd "$dir" && find . -type f ! -name SHA256SUMS.txt | sed 's|^\./||' | sort \
      | while read -r f; do sha256sum "$f"; done > SHA256SUMS.txt )
}

# ---------------------------------------------------------------------------
# Modern packages (Windows / Linux / macOS)
# ---------------------------------------------------------------------------
build_modern() {
  local platform="$1" launcher_name="$2" launcher_text="$3" ext="$4"
  local dir="$WORK/$APP_NAME"
  rm -rf "$dir"; mkdir -p "$dir"
  cp "$APP_HTML" "$dir/Vulkan-Typing-Studio-Standalone.html"
  cp "$LICENSE"  "$dir/LICENSE"
  printf '%s\n' "$MODERN_README" > "$dir/README.txt"
  printf '%s\n' "$launcher_text" > "$dir/$launcher_name"
  if [ "$ext" = "zip" ]; then
    to_crlf "$dir/$launcher_name" > "$dir/$launcher_name.tmp" && mv "$dir/$launcher_name.tmp" "$dir/$launcher_name"
    to_crlf "$dir/README.txt"     > "$dir/README.txt.tmp"     && mv "$dir/README.txt.tmp"     "$dir/README.txt"
  else
    chmod +x "$dir/$launcher_name"
  fi
  write_internal_sums "$dir"
  local out="$OUT_DIR/$APP_NAME-$platform.$ext"
  rm -f "$out"
  if [ "$ext" = "zip" ]; then
    ( cd "$WORK" && zip -X -q -r "$out" "$APP_NAME" )
  else
    tar -C "$WORK" -czf "$out" "$APP_NAME"
  fi
  echo "Built $out"
}

build_modern "Windows-x64"        "Start.bat"       "$WIN_LAUNCHER"   "zip"
build_modern "Linux-x64"          "start.sh"        "$LINUX_LAUNCHER" "tar.gz"
build_modern "macOS-universal"    "start.command"   "$MAC_LAUNCHER"   "tar.gz"

# ---------------------------------------------------------------------------
# Windows 7 legacy package (strictly separate sources under release/win7/)
# ---------------------------------------------------------------------------
build_win7() {
  local dir="$WORK/$APP_NAME-Windows7"
  rm -rf "$dir"; mkdir -p "$dir"
  cp "$APP_HTML" "$dir/Vulkan-Typing-Studio-Standalone.html"
  cp "$LICENSE"  "$dir/LICENSE"
  # Win7 text assets: normalize to CRLF so Windows 7 Notepad renders them.
  for f in Start.bat "Vulkan Compatibility Check.bat" README.txt THIRD-PARTY-NOTICES.txt; do
    to_crlf "$WIN7_DIR/$f" > "$dir/$f"
  done
  cp "$WIN7_DIR/Vulkan-Win7-Diagnostics.html" "$dir/Vulkan-Win7-Diagnostics.html"
  write_internal_sums "$dir"
  local out="$OUT_DIR/$APP_NAME-Windows7-Portable.zip"
  rm -f "$out"
  ( cd "$WORK" && zip -X -q -r "$out" "$APP_NAME-Windows7" )
  echo "Built $out"
}

build_win7

# ---------------------------------------------------------------------------
# Release asset manifest (outer hashes + sizes)
# ---------------------------------------------------------------------------
MANIFEST="$OUT_DIR/release/SHA256SUMS.txt"
{
  echo "# Vulkan Typing Studio $VERSION — release asset checksums (SHA-256)"
  echo "# Verify after download:  sha256sum -c SHA256SUMS.txt"
  echo
  for a in \
    "$APP_NAME-Windows-x64.zip" \
    "$APP_NAME-Linux-x64.tar.gz" \
    "$APP_NAME-macOS-universal.tar.gz" \
    "$APP_NAME-Windows7-Portable.zip"; do
    p="$OUT_DIR/$a"
    [ -f "$p" ] && sha256sum "$p" | sed "s|$OUT_DIR/||"
  done
} > "$MANIFEST"
echo "Wrote $MANIFEST"
echo
echo "Release assets:"
( cd "$OUT_DIR" && ls -la "$APP_NAME"-*.zip "$APP_NAME"-*.tar.gz )
