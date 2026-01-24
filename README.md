# Shell Setup - ZSH + Tmux + Vim + Modern CLI Tools

Modern, powerful shell environment for DevOps workflows with ZSH, Tmux, Vim and modern CLI replacements.

## Features

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

## Supported Platforms

- macOS (Homebrew)
- Debian/Ubuntu (apt + cargo)
- Arch Linux (pacman)

The installer auto-detects your OS and uses the appropriate package manager.

## Installation

### Quick Start

```bash
# Clone this repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Run installation
./install.sh
```

The script will:
1. Detect your OS (macOS/Debian/Arch)
2. Install package manager if needed (Homebrew on macOS)
3. Install all required packages and tools
4. Install Oh-My-Zsh + Powerlevel10k
5. Install ZSH plugins (fzf-tab, autosuggestions, syntax-highlighting, history-substring-search)
6. Install TPM (Tmux Plugin Manager)
7. Create symlinks to configs (backups your existing files)
8. Change default shell to ZSH

### Post-Installation Steps

1. **Restart your terminal** (or run `exec zsh`)

2. **Install Tmux plugins**:
   ```bash
   tmux
   # Press Ctrl+A I (capital I) to install plugins
   ```

3. **Review configs** in `~/dotfiles/config/`

## What Gets Installed

### Packages
| Tool | Purpose | macOS | Debian | Arch |
|------|---------|-------|--------|------|
| zsh | Shell | brew | apt | pacman |
| vim | Editor | brew | apt | pacman |
| tmux | Multiplexer | brew | apt | pacman |
| git | VCS | brew | apt | pacman |
| fzf | Fuzzy finder | brew | git clone | pacman |
| zoxide | Smart cd | brew | cargo | pacman |
| eza | Modern ls | brew | cargo | pacman |
| bat | Cat replacement | brew | cargo | pacman |
| delta | Git diff | brew | .deb | pacman |
| ripgrep | Fast grep | brew | cargo | pacman |
| btop | System monitor | brew | cargo | pacman |

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

## Configuration Files

All configs are stored in `~/dotfiles/config/` and symlinked to your home directory:

```
~/dotfiles/config/
├── .zshrc           # ZSH configuration
├── .p10k.zsh        # Powerlevel10k theme config
├── .tmux.conf       # Tmux configuration
├── .vimrc           # Vim configuration
├── .gitconfig       # Git config with delta
├── .welcome.sh      # Shell welcome message
├── .aliases.md      # Aliases documentation
└── .tmux.md         # Tmux commands reference
```

## Quick Reference

### Aliases

**File Operations:**
```bash
ls              # eza with icons
ll              # detailed list with git status
lt              # tree view (2 levels)
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

### Vim

**Leader key:** `Space`

| Key | Action |
|-----|--------|
| `<Space>w` | Save file |
| `<Space>q` | Quit |
| `<Space>x` | Save and quit |
| `<Space>/` | Clear search highlight |
| `jj` | Exit insert mode |

### Tmux

**Prefix:** `Ctrl+A`

| Key | Action |
|-----|--------|
| `Ctrl+A \|` | Vertical split |
| `Ctrl+A -` | Horizontal split |
| `Ctrl+A h/j/k/l` | Navigate panes (vim-style) |
| `Ctrl+A H/J/K/L` | Resize panes |
| `Ctrl+A r` | Reload config |
| `Alt+Left/Right` | Switch windows (no prefix) |

## Customization

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

### Adding Custom Config

Create `~/dotfiles/config/local.sh` for machine-specific settings:

```bash
# In .zshrc (already included at the end)
[ -f ~/dotfiles/config/local.sh ] && source ~/dotfiles/config/local.sh
```

## Version Control

This is a git repository. Track your changes:

```bash
cd ~/dotfiles

# Check status
git status

# Commit changes
git add -A
git commit -m "Update zsh config"

# Push to remote (if configured)
git push
```

## Uninstallation

```bash
cd ~/dotfiles
./uninstall.sh
```

This will:
- Remove all symlinks
- Optionally restore backups
- Keep installed packages (uninstall manually if needed)

## Troubleshooting

### Tmux plugins not working
Open tmux and press `Ctrl+A I` (capital I) to install plugins.

### ZSH plugins not loading
Check if plugins are installed:
```bash
ls ~/.oh-my-zsh/custom/plugins/
```

Re-run installer if missing:
```bash
./install.sh
```

### Fonts look weird in Powerlevel10k
Install a [Nerd Font](https://www.nerdfonts.com/):
```bash
# macOS
brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font

# Then configure your terminal to use "MesloLGS NF"
```

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

## Structure

```
~/dotfiles/
├── install.sh          # Main installation script
├── uninstall.sh        # Uninstallation script
├── README.md           # This file
├── .gitignore          # Git ignore patterns
└── config/             # Configuration files
    ├── .zshrc
    ├── .tmux.conf
    ├── .vimrc
    ├── .gitconfig
    ├── .p10k.zsh
    ├── .welcome.sh
    ├── .aliases.md
    └── .tmux.md
```

## Credits

Built with:
- [Oh-My-Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [TPM](https://github.com/tmux-plugins/tpm)
- Modern CLI tools community

## License

MIT (or whatever you prefer)

---

**Last updated:** 24/January/2026
