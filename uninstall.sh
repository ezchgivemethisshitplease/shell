#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Remove symlinks
remove_symlinks() {
    print_info "Removing symlinks..."

    local files=(".zshrc" ".tmux.conf" ".vimrc" ".gitconfig" ".p10k.zsh" ".welcome.sh" ".aliases.md" ".tmux.md")

    for file in "${files[@]}"; do
        if [[ -L "$HOME/$file" ]]; then
            print_info "Removing symlink: $file"
            rm "$HOME/$file"
        else
            print_warning "$file is not a symlink, skipping"
        fi
    done

    print_success "Symlinks removed"
}

# Restore backups
restore_backups() {
    print_info "Looking for backups..."

    # Find most recent backup directory
    local BACKUP_DIR=$(ls -dt "$HOME"/.dotfiles_backup_* 2>/dev/null | head -1)

    if [[ -z "$BACKUP_DIR" ]]; then
        print_warning "No backup directory found"
        return
    fi

    print_info "Found backup: $BACKUP_DIR"
    read -p "Restore files from backup? (y/n) " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for file in "$BACKUP_DIR"/*; do
            local filename=$(basename "$file")
            print_info "Restoring $filename"
            cp "$file" "$HOME/$filename"
        done
        print_success "Backup restored"
    else
        print_info "Backup not restored"
    fi
}

# Main uninstallation
main() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║         Shell Setup Uninstallation Script                ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""

    print_warning "This will remove all symlinks created by the installation script."
    print_warning "It will NOT uninstall packages or Oh My Zsh."
    echo ""
    read -p "Continue? (y/n) " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Uninstallation cancelled"
        exit 1
    fi

    echo ""
    remove_symlinks
    restore_backups

    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║              Uninstallation Complete!                    ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    print_info "Symlinks have been removed."
    print_info "To completely remove Oh My Zsh, run: uninstall_oh_my_zsh"
    print_info "To remove packages, use your package manager (brew/apt/pacman)"
    echo ""
}

main "$@"
