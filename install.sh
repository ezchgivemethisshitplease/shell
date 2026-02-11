#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Flags
FORCE_MODE=false

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

# Parse arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --force|-f)
                FORCE_MODE=true
                print_warning "Force mode enabled: will overwrite existing configs without backup"
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  -f, --force    Force mode: overwrite configs without backup"
                echo "  -h, --help     Show this help message"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        ARCH=$(uname -m)
        print_info "Detected macOS ($ARCH)"
    elif [[ -f /etc/debian_version ]]; then
        OS="debian"
        ARCH=$(dpkg --print-architecture)
        print_info "Detected Debian/Ubuntu ($ARCH)"
    elif [[ -f /etc/arch-release ]]; then
        OS="arch"
        ARCH=$(uname -m)
        print_info "Detected Arch Linux ($ARCH)"
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
            if [[ "$ARCH" == "arm64" ]]; then
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
        sudo apt install -y zsh vim tmux git curl wget unzip

        # Install fzf
        if [[ ! -d ~/.fzf ]]; then
            git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
            ~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
        fi

        # Install zoxide (pre-built binary)
        if ! command -v zoxide &> /dev/null; then
            print_info "Installing zoxide..."
            ZOXIDE_VERSION=$(curl -sL "https://api.github.com/repos/ajeetdsouza/zoxide/releases/latest" | sed -n 's/.*"tag_name": "v\([^"]*\)".*/\1/p')
            if [[ -z "$ZOXIDE_VERSION" ]]; then
                print_error "Failed to get zoxide version from GitHub API"
                exit 1
            fi
            # Map dpkg arch to zoxide arch naming
            if [[ "$ARCH" == "amd64" ]]; then
                ZOXIDE_ARCH="x86_64"
            elif [[ "$ARCH" == "arm64" ]]; then
                ZOXIDE_ARCH="aarch64"
            else
                ZOXIDE_ARCH="$ARCH"
            fi
            curl -Lo /tmp/zoxide.tar.gz "https://github.com/ajeetdsouza/zoxide/releases/download/v${ZOXIDE_VERSION}/zoxide-${ZOXIDE_VERSION}-${ZOXIDE_ARCH}-unknown-linux-musl.tar.gz"
            if ! file /tmp/zoxide.tar.gz | grep -q gzip; then
                print_error "Downloaded zoxide file is not a valid gzip archive"
                rm -f /tmp/zoxide.tar.gz
                exit 1
            fi
            sudo tar xzf /tmp/zoxide.tar.gz -C /usr/local/bin zoxide
            sudo chmod +x /usr/local/bin/zoxide
            rm -f /tmp/zoxide.tar.gz
        fi

        # Install eza (pre-built binary)
        if ! command -v eza &> /dev/null; then
            print_info "Installing eza..."
            EZA_VERSION=$(curl -sL "https://api.github.com/repos/eza-community/eza/releases/latest" | sed -n 's/.*"tag_name": "v\([^"]*\)".*/\1/p')
            if [[ -z "$EZA_VERSION" ]]; then
                print_error "Failed to get eza version from GitHub API"
                exit 1
            fi
            # Map dpkg arch to eza arch naming
            if [[ "$ARCH" == "amd64" ]]; then
                EZA_ARCH="x86_64"
            elif [[ "$ARCH" == "arm64" ]]; then
                EZA_ARCH="aarch64"
            else
                EZA_ARCH="$ARCH"
            fi
            curl -Lo /tmp/eza.tar.gz "https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/eza_${EZA_ARCH}-unknown-linux-gnu.tar.gz"
            if ! file /tmp/eza.tar.gz | grep -q gzip; then
                print_error "Downloaded eza file is not a valid gzip archive"
                rm -f /tmp/eza.tar.gz
                exit 1
            fi
            sudo tar xzf /tmp/eza.tar.gz -C /usr/local/bin
            sudo chmod +x /usr/local/bin/eza
            rm -f /tmp/eza.tar.gz
        fi

        # Install bat (pre-built deb)
        if ! command -v bat &> /dev/null; then
            print_info "Installing bat..."
            BAT_VERSION=$(curl -sL "https://api.github.com/repos/sharkdp/bat/releases/latest" | sed -n 's/.*"tag_name": "v\([^"]*\)".*/\1/p')
            if [[ -z "$BAT_VERSION" ]]; then
                print_error "Failed to get bat version from GitHub API"
                exit 1
            fi
            curl -Lo /tmp/bat.deb "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_${ARCH}.deb"
            sudo dpkg -i /tmp/bat.deb
            rm -f /tmp/bat.deb
        fi

        # Install ripgrep (pre-built deb)
        if ! command -v rg &> /dev/null; then
            print_info "Installing ripgrep..."
            RG_VERSION=$(curl -sL "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | sed -n 's/.*"tag_name": "\([^"]*\)".*/\1/p')
            if [[ -z "$RG_VERSION" ]]; then
                print_error "Failed to get ripgrep version from GitHub API"
                exit 1
            fi
            curl -Lo /tmp/ripgrep.deb "https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep_${RG_VERSION}-1_${ARCH}.deb"
            sudo dpkg -i /tmp/ripgrep.deb
            rm -f /tmp/ripgrep.deb
        fi

        # Install delta (pre-built deb)
        if ! command -v delta &> /dev/null; then
            print_info "Installing git-delta..."
            DELTA_VERSION=$(curl -sL "https://api.github.com/repos/dandavison/delta/releases/latest" | sed -n 's/.*"tag_name": "\([^"]*\)".*/\1/p')
            if [[ -z "$DELTA_VERSION" ]]; then
                print_error "Failed to get delta version from GitHub API"
                exit 1
            fi
            curl -Lo /tmp/delta.deb "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_${ARCH}.deb"
            sudo dpkg -i /tmp/delta.deb
            rm -f /tmp/delta.deb
        fi

        # Install btop (pre-built binary)
        if ! command -v btop &> /dev/null; then
            print_info "Installing btop..."
            BTOP_VERSION=$(curl -sL "https://api.github.com/repos/aristocratos/btop/releases/latest" | sed -n 's/.*"tag_name": "v\([^"]*\)".*/\1/p')
            if [[ -z "$BTOP_VERSION" ]]; then
                print_error "Failed to get btop version from GitHub API"
                exit 1
            fi
            # Determine correct arch name for btop
            if [[ "$ARCH" == "amd64" ]]; then
                BTOP_ARCH="x86_64"
            elif [[ "$ARCH" == "arm64" ]]; then
                BTOP_ARCH="aarch64"
            else
                BTOP_ARCH="$ARCH"
            fi
            curl -Lo /tmp/btop.tbz "https://github.com/aristocratos/btop/releases/download/v${BTOP_VERSION}/btop-${BTOP_ARCH}-unknown-linux-musl.tbz"
            if ! file /tmp/btop.tbz | grep -q bzip2; then
                print_error "Downloaded btop file is not a valid bzip2 archive"
                rm -f /tmp/btop.tbz
                exit 1
            fi
            sudo tar xjf /tmp/btop.tbz -C /tmp
            sudo mv /tmp/btop/bin/btop /usr/local/bin/
            rm -rf /tmp/btop /tmp/btop.tbz
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
        
        if [[ "$FORCE_MODE" == true ]]; then
            # Force mode: remove existing zsh config
            rm -rf "$HOME/.zshrc" "$HOME/.zsh_history" 2>/dev/null || true
        fi
        
        RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        print_success "Oh My Zsh installed"
    else
        print_info "Oh My Zsh already installed"
        
        if [[ "$FORCE_MODE" == true ]]; then
            print_warning "Force mode: cleaning Oh My Zsh custom plugins/themes"
            rm -rf "$HOME/.oh-my-zsh/custom/plugins/"* 2>/dev/null || true
            rm -rf "$HOME/.oh-my-zsh/custom/themes/"* 2>/dev/null || true
        fi
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
        
        if [[ "$FORCE_MODE" == true ]]; then
            print_warning "Force mode: updating Powerlevel10k"
            git -C "$P10K_DIR" pull
        fi
    fi
}

# Install ZSH plugins
install_zsh_plugins() {
    local CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

    # fzf-tab
    if [[ ! -d "$CUSTOM_DIR/fzf-tab" ]]; then
        print_info "Installing fzf-tab..."
        git clone https://github.com/Aloxaf/fzf-tab "$CUSTOM_DIR/fzf-tab"
    elif [[ "$FORCE_MODE" == true ]]; then
        print_warning "Force mode: updating fzf-tab"
        git -C "$CUSTOM_DIR/fzf-tab" pull
    fi

    # zsh-autosuggestions
    if [[ ! -d "$CUSTOM_DIR/zsh-autosuggestions" ]]; then
        print_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$CUSTOM_DIR/zsh-autosuggestions"
    elif [[ "$FORCE_MODE" == true ]]; then
        print_warning "Force mode: updating zsh-autosuggestions"
        git -C "$CUSTOM_DIR/zsh-autosuggestions" pull
    fi

    # fast-syntax-highlighting
    if [[ ! -d "$CUSTOM_DIR/fast-syntax-highlighting" ]]; then
        print_info "Installing fast-syntax-highlighting..."
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting "$CUSTOM_DIR/fast-syntax-highlighting"
    elif [[ "$FORCE_MODE" == true ]]; then
        print_warning "Force mode: updating fast-syntax-highlighting"
        git -C "$CUSTOM_DIR/fast-syntax-highlighting" pull
    fi

    # history-substring-search
    if [[ ! -d "$CUSTOM_DIR/history-substring-search" ]]; then
        print_info "Installing history-substring-search..."
        git clone https://github.com/zsh-users/zsh-history-substring-search "$CUSTOM_DIR/history-substring-search"
    elif [[ "$FORCE_MODE" == true ]]; then
        print_warning "Force mode: updating history-substring-search"
        git -C "$CUSTOM_DIR/history-substring-search" pull
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
        
        if [[ "$FORCE_MODE" == true ]]; then
            print_warning "Force mode: updating TPM"
            git -C "$HOME/.tmux/plugins/tpm" pull
        fi
    fi
}

# Create symlinks
create_symlinks() {
    print_info "Creating symlinks..."

    local DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local CONFIG_DIR="$DOTFILES_DIR/config"

    # Backup existing files (unless force mode)
    if [[ "$FORCE_MODE" == false ]]; then
        local BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$BACKUP_DIR"
        
        local files=(".zshrc" ".tmux.conf" ".vimrc" ".gitconfig" ".p10k.zsh" ".aliases.md" ".tmux.md")
        
        for file in "${files[@]}"; do
            if [[ -f "$HOME/$file" ]] && [[ ! -L "$HOME/$file" ]]; then
                print_warning "Backing up existing $file to $BACKUP_DIR"
                mv "$HOME/$file" "$BACKUP_DIR/"
            elif [[ -L "$HOME/$file" ]]; then
                print_info "Removing existing symlink $file"
                rm "$HOME/$file"
            fi
        done
        
        print_success "Backups created in $BACKUP_DIR"
    else
        # Force mode: just remove everything
        print_warning "Force mode: removing existing configs without backup"
        local files=(".zshrc" ".tmux.conf" ".vimrc" ".gitconfig" ".p10k.zsh" ".aliases.md" ".tmux.md")
        
        for file in "${files[@]}"; do
            rm -f "$HOME/$file"
        done
    fi

    # Create symlinks
    local files=(".zshrc" ".tmux.conf" ".vimrc" ".gitconfig" ".p10k.zsh" ".aliases.md" ".tmux.md")
    
    for file in "${files[@]}"; do
        if [[ -f "$CONFIG_DIR/$file" ]]; then
            print_info "Creating symlink: $file"
            ln -sf "$CONFIG_DIR/$file" "$HOME/$file"
        else
            print_warning "Config file not found, skipping: $file"
        fi
    done

    print_success "Symlinks created"
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
        if ! grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
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
    parse_args "$@"
    
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║         Shell Setup Installation Script                  ║"
    echo "║         ZSH + Tmux + Vim + Modern CLI Tools              ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""

    detect_os
    echo ""

    if [[ "$FORCE_MODE" == false ]]; then
        print_warning "This script will install packages and modify your shell configuration."
        read -p "Continue? (y/n) " -n 1 -r
        echo ""

        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Installation cancelled"
            exit 1
        fi
    else
        print_warning "FORCE MODE ENABLED: will overwrite all configs without confirmation"
        sleep 2
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
    print_info "Quick reference commands:"
    print_info "  ref       - show aliases and shortcuts"
    print_info "  tmuxref   - show tmux commands"
    echo ""
    
    if [[ "$FORCE_MODE" == false ]]; then
        print_warning "Note: Your old configs were backed up to ~/.dotfiles_backup_*"
    fi
    echo ""
}

main "$@"
