#!/bin/bash
# Sets kitty tab title, auto-detecting the correct socket
TITLE="$1"
SOCKET=$(ls /tmp/kitty-main-* 2>/dev/null | head -1)
if [ -n "$SOCKET" ]; then
    kitty @ --to "unix:$SOCKET" set-tab-title "$TITLE"
fi
