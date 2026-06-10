#!/bin/bash
# Abre o popup de bookmarks globalmente via socket do Kitty
# Chamado pelo skhd de qualquer lugar do macOS

export PATH="/opt/homebrew/bin:$PATH"

MAIN_PID=$(pgrep -f "kitty.app/Contents/MacOS/kitty$" | head -1)
KITTY_SOCK="/tmp/kitty-main-${MAIN_PID}"
SOCKET="unix:$KITTY_SOCK"

if [[ -z "$MAIN_PID" || ! -S "$KITTY_SOCK" ]]; then
  open -a kitty
  sleep 1
  MAIN_PID=$(pgrep -f "kitty.app/Contents/MacOS/kitty$" | head -1)
  KITTY_SOCK="/tmp/kitty-main-${MAIN_PID}"
  SOCKET="unix:$KITTY_SOCK"
fi

if [[ -n "$MAIN_PID" && -S "$KITTY_SOCK" ]]; then
  kitty @ --to "$SOCKET" launch --type=background kitten quick-access-terminal \
    --config "$HOME/.config/kitty/quick-access-terminal-center.conf" \
    --instance-group bookmarks \
    /bin/bash -c "$HOME/.config/kitty/scripts/bookmarks-picker.sh"
fi
