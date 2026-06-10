#!/bin/bash
# Bookmark picker usando fzf dentro do kitty quick-access-terminal
# Baseado no setup do linkarzu

export PATH="/opt/homebrew/bin:$PATH"

BOOKMARKS_FILE="$HOME/.config/kitty/bookmarks/bookmarks.tsv"

if ! command -v fzf &>/dev/null; then
  echo "fzf nao encontrado. Instale com: brew install fzf"
  exit 1
fi

if [[ ! -f "$BOOKMARKS_FILE" ]]; then
  echo "Arquivo de bookmarks nao encontrado: $BOOKMARKS_FILE"
  exit 1
fi

while true; do
  selection=$(cat "$BOOKMARKS_FILE" | fzf \
    --prompt="Open bookmark > " \
    --header="Type at least 3 characters to search bookmarks" \
    --layout=reverse \
    --delimiter=$'\t' \
    --with-nth=1 \
    --min-height=10 \
    --border=rounded \
    --no-info)

  if [[ -z "$selection" ]]; then
    # ESC pressionado - esconde a janela
    break
  fi

  url=$(echo "$selection" | cut -f2)
  if [[ -n "$url" ]]; then
    open "$url"
  fi
done
