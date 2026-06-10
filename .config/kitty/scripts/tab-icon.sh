#!/bin/bash
# Retorna ícone nerd font baseado no processo
case "$1" in
  nvim|vim)     echo "" ;;
  node)         echo "" ;;
  python*|py*)  echo "" ;;
  fish|bash|zsh) echo "" ;;
  git)          echo "" ;;
  docker)       echo "" ;;
  ssh)          echo "" ;;
  ruby|irb)     echo "" ;;
  go)           echo "" ;;
  cargo|rustc)  echo "" ;;
  claude)       echo "✦" ;;
  npm|yarn|pnpm) echo "" ;;
  tmux)         echo "" ;;
  htop|top|btop) echo "" ;;
  curl|wget)    echo "" ;;
  *)            echo "" ;;
esac
