# dotfiles

My development environment setup: Neovim + tmux + Fish + Ghostty.

Based on [craftzdog/dotfiles-public](https://github.com/craftzdog/dotfiles-public) with custom extensions for Go, Python, Terraform and Docker development.

## What's included

Neovim and Ghostty share the **Solarized Osaka (vivid)** theme, transparent with blur. tmux and vi-mongo still use **Catppuccin Macchiato**.

- **Neovim** (LazyVim, requires 0.12+) - solarized-osaka vivid theme (transparent, incl. sidebars/floats), native floating cmdline/messages (`vim._core.ui2` + tiny-cmdline, noice disabled), snacks.explorer tree + oil.nvim for batch file edits, dashboard on `nvim` and `nvim .`, telescope, cokeline buffer tabs, codediff (diff/history/PR/conflicts), mini.diff overlay, gitlinker permalinks, octo (PR review), GitHub Actions, flutter-tools, toggleterm, zen-mode, DAP debugging, test runner, VS Code-like multi-cursor and inline (Error Lens style) diagnostics. Format on save is off: format manually with `<leader>cf`
- **tmux** - C-Space prefix, lazygit/claude code popups, catppuccin statusline. Not auto-started: open it on demand with `t`
- **Fish** - tide prompt, eza aliases, zoxide, fzf integration, `t` tmux helper, `android`/`ios` emulator pickers
- **Ghostty** - Solarized Dark Vivid theme (matches nvim), transparency + blur, FiraCode Nerd Font
- **vi-mongo** - catppuccin and onedark style files
- **shiki** - terminal notes app config
- **Claude Code** - custom statusline (context/rate-limit/git/CI info)

## Prerequisites

- macOS (tested on Apple Silicon)
- [Homebrew](https://brew.sh)
- Git
- [Rust/Cargo](https://rustup.rs) (for shiki)
- [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads)
- Neovim **0.12+** (native `ui2` cmdline)
- [GitHub CLI](https://cli.github.com) authenticated (`gh auth login`) for octo, GitHub Actions and codediff PRs
- Optional: [Flutter SDK](https://docs.flutter.dev/get-started/install) on `PATH` - flutter-tools only loads when `flutter` is found

## Manual setup

### 1. Install dependencies

```bash
brew install neovim tmux fish ghostty eza zoxide fzf lazygit lazydocker vi-mongo gh
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
cp -r ~/dotfiles/.config/fish/functions/. ~/.config/fish/functions/
cp ~/dotfiles/.config/fish/config.fish ~/.config/fish/config.fish

# shiki doesn't use ~/.config, it reads from ~/Library/Application Support
mkdir -p ~/Library/Application\ Support/shiki
ln -sf ~/dotfiles/.config/shiki/config.toml ~/Library/Application\ Support/shiki/config.toml

# Claude Code statusline (add a "statusLine" entry pointing to it in ~/.claude/settings.json)
ln -sf ~/dotfiles/.claude/statusline-command.sh ~/.claude/statusline-command.sh
```

### 6. Open Ghostty and finish setup

```bash
# Start tmux (it is not auto-started) and install tmux plugins:
t
# Press Ctrl+Space, then I (capital i)

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

**Explorer:** `<leader>e` snacks.explorer tree (root), `<leader>E` tree (cwd), `sf` / `-` oil (float, current file dir), `;f` find files, `;r` live grep, `<Tab>`/`<S-Tab>` next/prev buffer

- *Tree:* `l`/`h` expand/collapse, `a` add (end with `/` for folder), `r` rename, `m` move, `c` copy, `d` delete, `Tab` multi-select, `/` filter, `?` help
- *Oil:* edit the directory like text and `:w` to apply (rename with `cw`, move with `dd`/`p`, batch rename with `:s`). `h`/`l` parent/open, `gd` toggle details, `<C-p>` preview, `g?` help

**LSP:** `gd` go to definition, `gI` TS source definition (skips `.d.ts`), `gr` references, `K` hover, `<leader>rn` rename

**Git:** `<leader>gg` lazygit, `<leader>gb` git blame, `<leader>gv` mini.diff overlay, `<leader>gy` copy GitHub permalink, `<leader>gO` open permalink

**Diff (codediff):** `<leader>gdo` repo changes, `<leader>gdm` vs main, `<leader>gds` staged, `<leader>gdh` file history, `<leader>gdH` repo history, `:CodeDiff pr <n>` review a PR without checkout, `q` closes

**PR review (octo):** `<leader>gpl` list PRs, `<leader>gpr` start review, `<leader>gpa` submit review, `<leader>gpd` PR diff, `<leader>gpc` checkout

**GitHub Actions:** `<leader>gah` history, `<leader>gap` history by branch/PR, `<leader>gaw` watch run, `<leader>gad` dispatch, `<leader>gao` open in browser. In history: `l` expand/logs, `R` rerun, `C` cancel

**Flutter:** `<leader>Fc` command picker, `<leader>Fr` run, `<leader>Fd` devices, `<leader>Fe` emulators, `<leader>Fh` hot reload, `<leader>FR` hot restart, `<leader>Fq` quit, `<leader>Fl` logs, `<leader>Fo` widget outline, `<leader>Ft` DevTools

**Editing:** `gcc` toggle comment, `yyp` duplicate line, `<M-j>`/`<M-k>` move line, `x` delete char (no copy), `<leader>p` paste from yank, `ss`/`sv` splits, `<leader>z` zen mode, `<leader>cf` format

**Multi-cursor:** `<C-n>` add cursor at next match, `<leader>A` cursors at all matches, `<M-Up>`/`<M-Down>` add cursor above/below, `<C-q>` skip match, `<Esc>` clear cursors

**Terminal & popups:** `<C-->` / `<C-/>` terminal (root), `<leader>tt` terminal popup, `<leader>ai` Claude Code, `<leader>ld` lazydocker

### tmux (prefix: Ctrl+Space)

`c` new window, `n`/`p` next/prev window, `"` split horizontal, `%` split vertical, `g` lazygit popup, `y` claude code popup, `r` reload config

### Fish

`g` = git, `c` = claude, `vim` = nvim, `ls`/`ll`/`la`/`lt` = eza variants, `mongo` = vi-mongo

`t` new tmux session, `t NAME` attach/create session NAME, `t -l` list sessions

`android` pick an AVD with fzf and open it in the emulator, `ios` pick an iOS simulator and boot it
