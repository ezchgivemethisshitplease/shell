# Shell Setup - ZSH + Tmux + Vim + Modern CLI Tools

Modern, powerful shell environment for DevOps workflows with ZSH, Tmux, Vim and modern CLI replacements.

**Optimized for servers** - uses pre-built binaries instead of compilation from source.

## ✨ Features

### Terminal Stack
- **ZSH** with Oh-My-Zsh framework
- **Powerlevel10k** theme (fast, customizable)
- **Tmux** with persistent sessions and plugins
- **Vim** with modern configuration

### Modern CLI Tools
- `fzf` - fuzzy finder for files, history, SSH hosts
- `zoxide` - smart directory jumper (learns your paths)
- `eza` - modern `ls` replacement with icons and git status
- `bat` - `cat` with syntax highlighting
- `delta` - beautiful git diff viewer (side-by-side)
- `ripgrep` - fast code search
- `btop` - system monitor

### Key Capabilities
- **197 git aliases** via oh-my-zsh plugin (`gst`, `gp`, `gl`, `gd`, etc.)
- **FZF integration** - Ctrl+R (history), Ctrl+T (files), Alt+C (dirs)
- **Custom functions** - `fe` (edit), `fcd` (cd to file dir), `fkill` (kill process), `fssh` (connect to host)
- **Tmux persistent sessions** - auto-save every 15 minutes, restore after reboot
- **Vim persistent undo** - never lose your changes

## 🚀 Quick Start

### Standard Installation

```bash
# Clone this repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run installation
./install.sh
```

### Force Installation (for servers with existing configs)

**Use this when deploying to servers that already have ZSH/configs:**

```bash
# Clone repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Force mode: overwrites everything without backup or confirmation
./install.sh --force
```

**What `--force` does:**
- Removes existing `.zshrc`, `.tmux.conf`, `.vimrc` without backup
- Overwrites all configs with symlinks
- Updates all plugins to latest version
- No confirmation prompts (useful for automation/scripts)

### One-liner for servers

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles/main/install.sh | bash -s -- --force
```

## 📦 Supported Platforms

| Platform | Package Manager | Pre-built Binaries |
|----------|----------------|-------------------|
| **macOS** | Homebrew | ✅ All tools |
| **Debian/Ubuntu** | apt + GitHub releases | ✅ All tools |
| **Arch Linux** | pacman | ✅ All tools |

**No compilation required** - all modern CLI tools are installed from pre-built binaries (GitHub releases).

## 🛠️ What Gets Installed

### Core Tools

| Tool | macOS | Debian/Ubuntu | Arch | Method |
|------|-------|---------------|------|--------|
| zsh | brew | apt | pacman | Package manager |
| vim | brew | apt | pacman | Package manager |
| tmux | brew | apt | pacman | Package manager |
| git | brew | apt | pacman | Package manager |
| fzf | brew | git clone | pacman | Source/Package |
| zoxide | brew | **GitHub binary** | pacman | Pre-built |
| eza | brew | **GitHub binary** | pacman | Pre-built |
| bat | brew | **GitHub .deb** | pacman | Pre-built |
| delta | brew | **GitHub .deb** | pacman | Pre-built |
| ripgrep | brew | **GitHub .deb** | pacman | Pre-built |
| btop | brew | **GitHub binary** | pacman | Pre-built |

**On Debian/Ubuntu:** Modern tools are installed from latest GitHub releases (pre-built binaries), NOT compiled from source with cargo.

### ZSH Plugins
- **git** (oh-my-zsh built-in) - 197 git aliases
- **fzf-tab** - fzf-powered tab completion
- **zsh-autosuggestions** - suggestions from history
- **fast-syntax-highlighting** - command syntax highlighting
- **history-substring-search** - search history with arrows

### Tmux Plugins (via TPM)
- **tmux-resurrect** - save/restore sessions
- **tmux-continuum** - auto-save every 15 minutes
- **tmux-yank** - system clipboard integration
- **tmux-copycat** - improved search
- **tmux-open** - open files/URLs from tmux
- **tmux-jump** - quick text navigation
- **tmux-fzf** - fzf integration (Ctrl+A Ctrl+F)

## 📁 Configuration Files

All configs are stored in `~/dotfiles/config/` and symlinked to your home directory:

```
~/dotfiles/config/
├── .zshrc           # ZSH configuration
├── .p10k.zsh        # Powerlevel10k theme config
├── .tmux.conf       # Tmux configuration
├── .vimrc           # Vim configuration
├── .gitconfig       # Git config with delta
├── .aliases.md      # Aliases documentation
└── .tmux.md         # Tmux commands reference
```

**Note:** `.welcome.sh` has been removed - use `ref` and `tmuxref` commands instead.

## 🎯 Quick Reference

### Aliases

**File Operations:**
```bash
ls              # native ls (unaliased)
l               # eza with icons
ll              # eza detailed list with git status
lt              # eza tree view (2 levels)
cat             # bat with syntax highlighting
less            # bat with paging
```

**Navigation:**
```bash
z <name>        # smart cd (learns your paths)
zi              # interactive directory picker
```

**Git (oh-my-zsh plugin):**
```bash
gst             # git status
ga              # git add
gaa             # git add --all
gcmsg           # git commit -m
gp              # git push
gl              # git pull
gd              # git diff (uses delta)
glog            # git log --oneline --graph
```
[Full list](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git)

**Tmux:**
```bash
t               # tmux
ta              # tmux attach
tn <name>       # tmux new -s <name>
tl              # tmux list-sessions
tk <name>       # tmux kill-session -t <name>
```

**Documentation:**
```bash
ref             # show aliases reference
tmuxref         # show tmux commands reference
```

### Custom Functions

| Function | Description |
|----------|-------------|
| `fe` | Find and edit file with fzf preview |
| `fcd` | Find file and cd to its directory |
| `fkill` | Kill process interactively with fzf |
| `fssh` | Connect to SSH host from ~/.ssh/config |
| `venv` | Activate Python venv from ~/VSC/venv |

### FZF Keybindings

| Key | Action |
|-----|--------|
| `Ctrl+R` | Search command history |
| `Ctrl+T` | Find files with preview |
| `Alt+C` | CD to directory |
| `**<Tab>` | FZF completion in commands |

### Tmux

**Prefix:** `Ctrl+A`

| Key | Action |
|-----|--------|
| `Ctrl+A \|` | Vertical split |
| `Ctrl+A -` | Horizontal split |
| `Ctrl+A h/j/k/l` | Navigate panes (vim-style) |
| `Ctrl+A H/J/K/L` | Resize panes |
| `Ctrl+A r` | Reload config |
| `Ctrl+A I` | Install plugins (capital I) |
| `Alt+Left/Right` | Switch windows (no prefix) |

### Vim

**Leader key:** `Space`

| Key | Action |
|-----|--------|
| `<Space>w` | Save file |
| `<Space>q` | Quit |
| `<Space>x` | Save and quit |
| `<Space>e` | Toggle file explorer |
| `Ctrl+h/j/k/l` | Navigate splits |

## 🔧 Installation Steps

The script performs these steps:

1. Detect OS (macOS/Debian/Ubuntu/Arch)
2. Install package manager if needed (Homebrew on macOS)
3. Install all required packages and tools (**pre-built binaries on Debian/Ubuntu**)
4. Install Oh-My-Zsh + Powerlevel10k
5. Install ZSH plugins
6. Install TPM (Tmux Plugin Manager)
7. Create symlinks to configs (backs up existing files unless `--force`)
8. Change default shell to ZSH

## 🌐 Server Deployment Examples

### Single Server

```bash
ssh user@server

# Clone and install with force mode
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --force

# Restart shell
exec zsh
```

### Multiple Servers (Ansible/Script)

```bash
#!/bin/bash
SERVERS=("server1" "server2" "server3")

for server in "${SERVERS[@]}"; do
    echo "Deploying to $server..."
    ssh "$server" "git clone https://github.com/yourusername/dotfiles.git ~/dotfiles 2>/dev/null || (cd ~/dotfiles && git pull); cd ~/dotfiles && ./install.sh --force"
done
```

### SSH One-liner

```bash
ssh user@server 'bash -c "$(curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles/main/install.sh)" -s -- --force && exec zsh'
```

## 📝 Customization

### Editing Configs

All configs are in `~/dotfiles/config/`. After editing, changes apply immediately (symlinks).

```bash
cd ~/dotfiles/config

# Edit any config
vim .zshrc

# Reload ZSH
source ~/.zshrc

# Reload Tmux (or Ctrl+A r inside tmux)
tmux source ~/.tmux.conf
```

### Updating on Remote Servers

```bash
cd ~/dotfiles
git pull
source ~/.zshrc  # Apply changes
```

## 🔄 Version Control

Track your customizations:

```bash
cd ~/dotfiles

# Check status
git status

# Commit changes
git add -A
git commit -m "Update zsh config"

# Push to remote
git push
```

## 🗑️ Uninstallation

```bash
cd ~/dotfiles
./uninstall.sh
```

This will:
- Remove all symlinks
- Optionally restore backups
- Keep installed packages (uninstall manually if needed)

## 🐛 Troubleshooting

### Tmux plugins not working
Open tmux and press `Ctrl+A I` (capital I) to install plugins.

### ZSH plugins not loading
Check if plugins are installed:
```bash
ls ~/.oh-my-zsh/custom/plugins/
```

Re-run installer if missing:
```bash
cd ~/dotfiles
./install.sh --force
```

### Fonts look weird in Powerlevel10k
Install a [Nerd Font](https://www.nerdfonts.com/):

**macOS:**
```bash
brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font
```

**Linux:**
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
fc-cache -f
```

Then configure your terminal to use "MesloLGS NF".

### Delta not showing colors
Check git config:
```bash
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
```

### Command not found after installation
Restart your terminal or run:
```bash
exec zsh
```

## 📊 Performance

**Installation time (Debian/Ubuntu):**
- Standard mode: ~3-5 minutes (pre-built binaries)
- Force mode: ~2-3 minutes (no backups)

**vs old method (cargo compilation):** 15-20 minutes ❌

## 🏗️ Project Structure

```
~/dotfiles/
├── install.sh          # Main installation script (supports --force)
├── uninstall.sh        # Uninstallation script
├── README.md           # This file
├── .gitignore          # Git ignore patterns
└── config/             # Configuration files
    ├── .zshrc
    ├── .tmux.conf
    ├── .vimrc
    ├── .gitconfig
    ├── .p10k.zsh
    ├── .aliases.md
    └── .tmux.md
```

## 🙏 Credits

Built with:
- [Oh-My-Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [TPM](https://github.com/tmux-plugins/tpm)
- Modern CLI tools community

## 📄 License

MIT

---

**Last updated:** 31/January/2026
**Optimizations:** Pre-built binaries, force mode, server deployment ready
