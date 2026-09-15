#!/usr/bin/env bash
# greezmode installer -- copies greezmode into a bin dir and links r-greezmode.
#
#   ./install.sh              # install to ~/.local/bin
#   ./install.sh /usr/local/bin
set -euo pipefail

BIN="${1:-$HOME/.local/bin}"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/greezmode"

command -v tmux >/dev/null || {
  echo "greezmode: tmux is not installed (apt install tmux / brew install tmux)" >&2
  exit 1
}

mkdir -p "$BIN"
install -m 755 "$SRC" "$BIN/greezmode"
ln -sf greezmode "$BIN/r-greezmode"

echo "installed: $BIN/greezmode"
echo "installed: $BIN/r-greezmode -> greezmode"

case ":$PATH:" in
  *":$BIN:"*) ;;
  *) echo
     echo "note: $BIN is not on your PATH. Add this to your shell rc:"
     echo "      export PATH=\"$BIN:\$PATH\"" ;;
esac
