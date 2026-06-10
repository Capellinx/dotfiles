#!/bin/bash
# Project switcher: zoxide + fzf popup no Kitty
# Abre um popup global, seleciona diretório e cria tab na instância principal

export PATH="/usr/bin:/usr/sbin:/opt/homebrew/bin:$PATH"

KITTY_CMD="/Applications/kitty.app/Contents/MacOS/kitty"

# Busca o socket da instância principal (PPID=1, não é popup filho)
SOCKET=""
for sock in /tmp/kitty-main-*; do
  [[ -S "$sock" ]] || continue
  sock_pid="${sock##*-}"
  kill -0 "$sock_pid" 2>/dev/null || continue
  ppid=$(ps -p "$sock_pid" -o ppid= 2>/dev/null | tr -d ' ')
  [[ "$ppid" == "1" ]] || continue
  SOCKET="unix:$sock"
  break
done

# Remove para garantir que kitty @ não fale com o popup
unset KITTY_LISTEN_ON

selection=$(zoxide query --list | fzf \
  --prompt="Project > " \
  --header="Select a directory to open in new tab" \
  --layout=reverse \
  --min-height=10 \
  --border=rounded \
  --no-info \
  --preview='eza --icons -1 --color=always {}' \
  --preview-window=right:40%)

if [[ -n "$selection" && -n "$SOCKET" ]]; then
  $KITTY_CMD @ --to "$SOCKET" launch --type=tab --tab-title="$(basename "$selection")" --cwd="$selection"
  $KITTY_CMD @ --to "$SOCKET" focus-window
  osascript -e 'tell application "kitty" to activate'
fi
