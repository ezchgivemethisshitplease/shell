#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        print_info "Detected macOS"
    elif [[ -f /etc/debian_version ]]; then
        OS="debian"
        print_info "Detected Debian/Ubuntu"
    elif [[ -f /etc/arch-release ]]; then
        OS="arch"
        print_info "Detected Arch Linux"
    else
        print_error "Unsupported OS. Supported: macOS, Debian/Ubuntu, Arch Linux"
        exit 1
    fi
}

# Install package manager (if needed)
setup_package_manager() {
    if [[ "$OS" == "macos" ]]; then
        if ! command -v brew &> /dev/null; then
            print_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            # Add Homebrew to PATH for Apple Silicon
            if [[ $(uname -m) == "arm64" ]]; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
            print_success "Homebrew installed"
        else
            print_info "Homebrew already installed"
        fi
    fi
}

# Install packages
install_packages() {
    print_info "Installing packages..."

    if [[ "$OS" == "macos" ]]; then
        brew update
        brew install zsh vim tmux git fzf zoxide eza bat git-delta ripgrep btop
        # Run fzf install script
        $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

    elif [[ "$OS" == "debian" ]]; then
        sudo apt update
        sudo apt install -y zsh vim tmux git curl wget build-essential

        # Install fzf
        if [[ ! -d ~/.fzf ]]; then
            git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
            ~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
        fi

        # Install modern tools via cargo/download
        if ! command -v cargo &> /dev/null; then
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            source "$HOME/.cargo/env"
        fi

        cargo install zoxide eza bat-cat ripgrep btop

        # git-delta
        if ! command -v delta &> /dev/null; then
            DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
            curl -Lo /tmp/delta.deb "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb"
            sudo dpkg -i /tmp/delta.deb
            rm /tmp/delta.deb
        fi

    elif [[ "$OS" == "arch" ]]; then
        sudo pacman -Syu --noconfirm
        sudo pacman -S --noconfirm zsh vim tmux git fzf zoxide eza bat git-delta ripgrep btop

        # Run fzf install
        /usr/share/fzf/key-bindings.zsh
        /usr/share/fzf/completion.zsh
    fi

    print_success "Packages installed"
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        print_info "Installing Oh My Zsh..."
        RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        print_success "Oh My Zsh installed"
    else
        print_info "Oh My Zsh already installed"
    fi
}

# Install Powerlevel10k
install_powerlevel10k() {
    local P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [[ ! -d "$P10K_DIR" ]]; then
        print_info "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
        print_success "Powerlevel10k installed"
    else
        print_info "Powerlevel10k already installed"
    fi
}

# Install ZSH plugins
install_zsh_plugins() {
    local CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

    # fzf-tab
    if [[ ! -d "$CUSTOM_DIR/fzf-tab" ]]; then
        print_info "Installing fzf-tab..."
        git clone https://github.com/Aloxaf/fzf-tab "$CUSTOM_DIR/fzf-tab"
    fi

    # zsh-autosuggestions
    if [[ ! -d "$CUSTOM_DIR/zsh-autosuggestions" ]]; then
        print_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$CUSTOM_DIR/zsh-autosuggestions"
    fi

    # fast-syntax-highlighting
    if [[ ! -d "$CUSTOM_DIR/fast-syntax-highlighting" ]]; then
        print_info "Installing fast-syntax-highlighting..."
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting "$CUSTOM_DIR/fast-syntax-highlighting"
    fi

    # history-substring-search
    if [[ ! -d "$CUSTOM_DIR/history-substring-search" ]]; then
        print_info "Installing history-substring-search..."
        git clone https://github.com/zsh-users/zsh-history-substring-search "$CUSTOM_DIR/history-substring-search"
    fi

    print_success "ZSH plugins installed"
}

# Install TPM (Tmux Plugin Manager)
install_tpm() {
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        print_info "Installing TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        print_success "TPM installed"
    else
        print_info "TPM already installed"
    fi
}

# Create symlinks
create_symlinks() {
    print_info "Creating symlinks..."

    local DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local CONFIG_DIR="$DOTFILES_DIR/config"

    # Backup existing files
    local BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    local files=(".zshrc" ".tmux.conf" ".vimrc" ".gitconfig" ".p10k.zsh" ".welcome.sh" ".aliases.md" ".tmux.md")

    for file in "${files[@]}"; do
        if [[ -f "$HOME/$file" ]] && [[ ! -L "$HOME/$file" ]]; then
            print_warning "Backing up existing $file to $BACKUP_DIR"
            mv "$HOME/$file" "$BACKUP_DIR/"
        elif [[ -L "$HOME/$file" ]]; then
            print_info "Removing existing symlink $file"
            rm "$HOME/$file"
        fi

        print_info "Creating symlink: $file"
        ln -sf "$CONFIG_DIR/$file" "$HOME/$file"
    done

    print_success "Symlinks created (backups in $BACKUP_DIR if any)"
}

# Create necessary directories
create_directories() {
    print_info "Creating necessary directories..."

    # Vim undo directory
    mkdir -p "$HOME/.vim/undodir"

    # Tmux plugins directory (if not exists)
    mkdir -p "$HOME/.tmux/plugins"

    print_success "Directories created"
}

# Change default shell to zsh
change_shell() {
    if [[ "$SHELL" != *"zsh"* ]]; then
        print_info "Changing default shell to zsh..."

        local ZSH_PATH=$(which zsh)

        # Check if zsh is in /etc/shells
        if ! grep -q "$ZSH_PATH" /etc/shells; then
            print_warning "Adding $ZSH_PATH to /etc/shells (requires sudo)"
            echo "$ZSH_PATH" | sudo tee -a /etc/shells
        fi

        chsh -s "$ZSH_PATH"
        print_success "Default shell changed to zsh (restart terminal to apply)"
    else
        print_info "Default shell is already zsh"
    fi
}

# Install tmux plugins
install_tmux_plugins() {
    print_info "Installing tmux plugins..."
    print_warning "After installation, open tmux and press Ctrl+A I (capital I) to install plugins"
}

# Main installation
main() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║         Shell Setup Installation Script                  ║"
    echo "║         ZSH + Tmux + Vim + Modern CLI Tools              ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""

    detect_os
    echo ""

    print_warning "This script will install packages and modify your shell configuration."
    read -p "Continue? (y/n) " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Installation cancelled"
        exit 1
    fi

    echo ""
    print_info "Starting installation..."
    echo ""

    setup_package_manager
    install_packages
    install_oh_my_zsh
    install_powerlevel10k
    install_zsh_plugins
    install_tpm
    create_directories
    create_symlinks
    change_shell
    install_tmux_plugins

    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                 Installation Complete!                   ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    print_success "All done! Please follow these final steps:"
    echo ""
    print_info "1. Restart your terminal (or run: exec zsh)"
    print_info "2. Open tmux and press Ctrl+A I (capital I) to install tmux plugins"
    print_info "3. Review your configs in ~/dotfiles/config/"
    echo ""
    print_warning "Note: Some tools may require you to restart your terminal to work properly"
    echo ""
}

main "$@"
