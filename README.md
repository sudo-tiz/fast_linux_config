# Fast Linux Config

Minimal dotfiles: Neovim, Tmux, Zsh, Bash. vi-mode, sane defaults, git/docker/k8s aliases.

## Setup

```bash
# Dependencies
sudo apt update && sudo apt install -y zsh neovim git tmux

# Vim + Bash
curl -Lo ~/.vimrc https://raw.githubusercontent.com/sudo-Tiz/fast_linux_config/main/.vimrc
curl -Lo ~/.bashrc https://raw.githubusercontent.com/sudo-Tiz/fast_linux_config/main/.bashrc

# Neovim + Zsh
curl --create-dirs -Lo ~/.config/nvim/init.lua https://raw.githubusercontent.com/sudo-Tiz/fast_linux_config/main/init.lua
curl -Lo ~/.zshrc https://raw.githubusercontent.com/sudo-Tiz/fast_linux_config/main/.zshrc
chsh -s $(which zsh) && exec zsh

# Tmux
curl --create-dirs -Lo ~/.config/tmux/tmux.conf https://raw.githubusercontent.com/sudo-Tiz/fast_linux_config/main/tmux.conf
```

**Neovim plugins**: Use `init.plugins.lua` instead of `init.lua` (lazy.nvim, NvChad, LSP, blink.cmp).

**Tmux plugins**: Set `@enable_*=1` in tmux.conf, then `prefix + I`.

## Optional Tools

| Tool | Package | Use |
|------|---------|-----|
| fzf | `fzf` | Fuzzy finder; `cs()` shell selector |
| eza | `eza` | Fast `ls` with tree (`lt`, `llt`) |
| bat | `bat` | Syntax-highlighted `cat`; git diffs |
| ripgrep | `ripgrep` | Fast `rg` grep |

```bash
# Ubuntu/Debian
sudo apt install -y fzf eza bat ripgrep
```

## Features

**Shells**: vi-mode, 10M history, colors, completion, cursor shapes. Aliases: docker, k8s, git, python venv, rsync.

**Functions**: `ide <dir>` (tmux+nvim+opencode), `cs` (fzf shell navigator), `lssh`, `bak`, `ch`.

**Neovim**: Vanilla or plugins. See [nvim repo](https://github.com/sudo-Tiz/nvim).

**Tmux**: vi-nav, split-right, split-below, TPM optional.

## Related

- **[nvim](https://github.com/sudo-Tiz/nvim)** — Extended Neovim config (treesitter, telescope, etc.)
- **[opencode](https://github.com/sudo-Tiz/opencode)** — AI-powered terminal IDE
- **[LARBRE](https://github.com/sudo-Tiz/LARBRE)** — Arch Linux auto-setup (Hyprland, dotfiles, DNS)
- **[dotfilesV2](https://github.com/sudo-Tiz/dotfilesV2)** — Full dotfiles manager

