# dotfiles

My development environment setup: Neovim + tmux + Fish + Ghostty.

Based on [craftzdog/dotfiles-public](https://github.com/craftzdog/dotfiles-public) with custom extensions for Go, Python, Terraform and Docker development.

## What's included

- **Neovim** (LazyVim) - solarized-osaka theme, oil.nvim file explorer, telescope, toggleterm, supermaven AI, zen-mode, DAP debugging
- **tmux** - C-t prefix, lazygit/claude code popups, solarized statusline
- **Fish** - tide prompt, eza aliases, zoxide, fzf integration
- **Ghostty** - solarized dark theme, transparency, FiraCode Nerd Font
- **shiki** - terminal notes app, solarized-dark theme config

## Prerequisites

- macOS (tested on Apple Silicon)
- [Homebrew](https://brew.sh)
- Git
- [Rust/Cargo](https://rustup.rs) (for shiki)
- [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads)

## Manual setup

### 1. Install dependencies

```bash
brew install neovim tmux fish ghostty eza zoxide fzf lazygit lazydocker vi-mongo
cargo install shiki
```

> **vi-mongo** (MongoDB TUI client) config lives in `~/Library/Application Support/vi-mongo/config.yaml` and typically holds connection strings/credentials, so it's intentionally **not** tracked in this repo. Configure connections manually after installing.

### 2. Set fish as default shell

```bash
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

### 3. Install fish plugin manager (fisher) and tide prompt

```bash
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fish -c "fisher install IlanCosman/tide@v6"
```

### 4. Install tmux plugin manager (TPM)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

### 5. Clone and symlink configs

```bash
git clone https://github.com/Capellinx/dotfiles.git ~/dotfiles

# Back up existing configs
mkdir -p ~/.config-backup
cp -r ~/.config/nvim ~/.config-backup/ 2>/dev/null
cp -r ~/.config/tmux ~/.config-backup/ 2>/dev/null
cp -r ~/.config/fish ~/.config-backup/ 2>/dev/null
cp -r ~/.config/ghostty ~/.config-backup/ 2>/dev/null

# Symlink configs
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.config/tmux ~/.config/tmux
ln -sf ~/dotfiles/.config/ghostty ~/.config/ghostty
cp ~/dotfiles/.config/fish/config.fish ~/.config/fish/config.fish

# shiki doesn't use ~/.config, it reads from ~/Library/Application Support
mkdir -p ~/Library/Application\ Support/shiki
ln -sf ~/dotfiles/.config/shiki/config.toml ~/Library/Application\ Support/shiki/config.toml
```

### 6. Open Ghostty and finish setup

```bash
# Inside tmux (starts automatically), install tmux plugins:
# Press Ctrl+t, then I (capital i)

# Configure tide prompt:
tide configure

# Open neovim - plugins install automatically:
nvim
```

## Setup using Claude Code

If you have [Claude Code](https://claude.ai/code) installed, you can automate the entire setup:

```bash
claude -p "Clone https://github.com/Capellinx/dotfiles and set up my dev environment. Install all dependencies with brew (neovim, tmux, fish, ghostty, eza, zoxide, fzf, lazygit, lazydocker). Set fish as default shell. Install fisher and tide. Install TPM. Symlink all configs from the cloned repo to ~/.config/. Open nvim to trigger plugin installation."
```

Or interactively:

```bash
claude
```

Then ask:

> Set up my dev environment using my dotfiles repo at https://github.com/Capellinx/dotfiles - install all dependencies, configure fish with tide, tmux with TPM, and symlink all configs.

## Key bindings

### Neovim

**File navigation:** `<leader>o` oil float, `<leader>e` oil cwd, `sf` telescope file browser, `;f` find files, `;r` live grep

**LSP:** `gd` go to definition, `gr` references, `K` hover, `<leader>rn` rename

**Git:** `<leader>gg` lazygit, `<leader>gb` git blame

**Editing:** `x` delete char (no copy), `<leader>p` paste from yank, `ss`/`sv` splits, `<leader>z` zen mode

### tmux (prefix: Ctrl+t)

`c` new window, `n`/`p` next/prev window, `"` split horizontal, `%` split vertical, `g` lazygit popup, `y` claude code popup, `r` reload config

### Fish

`g` = git, `c` = claude, `vim` = nvim, `ls`/`ll`/`la`/`lt` = eza variants
