#!/usr/bin/env bash
set -euo pipefail

# Install `c` CLI locally or system-wide.
# Usage:
#   ./tools/install_c.sh           -> installs to ~/bin (creates it if needed)
#   sudo ./tools/install_c.sh -s   -> installs to /usr/local/bin (requires sudo)

DEST="${HOME}/bin"
SYSTEM=false

while getopts "s" opt; do
  case "$opt" in
    s) SYSTEM=true ;;
    *) echo "Usage: $0 [-s]"; exit 2 ;;
  esac
done

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_SRC="$ROOT_DIR/bin/c"
TOOL_SRC="$ROOT_DIR/tools/c"

if [ "$SYSTEM" = true ]; then
  DEST="/usr/local/bin"
fi

mkdir -p "$DEST"
chmod +x "$BIN_SRC" "$TOOL_SRC"
cp -f "$BIN_SRC" "$DEST/c"
if [ -f "$ROOT_DIR/bin/claude" ]; then
  cp -f "$ROOT_DIR/bin/claude" "$DEST/claude"
  echo "Installed claude -> $DEST/claude"
fi

if [ "$SYSTEM" = true ]; then
  echo "Installed system-wide. Ensure /usr/local/bin is in your PATH." 
else
  echo "Installed to $DEST. Add 'export PATH=\"$DEST:$PATH\"' to your shell rc to use 'c' globally." 
fi

echo "Note: To call Anthropic Claude, set ANTHROPIC_API_KEY in your environment and install 'requests' (pip install requests)."
