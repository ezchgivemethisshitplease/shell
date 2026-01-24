#!/bin/bash

# Colors
GRAY='\033[0;90m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Shell Configuration Ready${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${CYAN}📁 Configuration Files:${NC}"
echo -e "${GRAY}  ~/.zshrc              Main ZSH config (156 lines)${NC}"
echo -e "${GRAY}  ~/.p10k.zsh           Powerlevel10k theme${NC}"
echo -e "${GRAY}  ~/.tmux.conf          Tmux config (Ctrl+A prefix)${NC}"
echo -e "${GRAY}  ~/.gitconfig          Git config (delta pager)${NC}"
echo ""

echo -e "${CYAN}📚 Documentation:${NC}"
echo -e "${GRAY}  ref                   Show aliases/functions/hotkeys${NC}"
echo -e "${GRAY}  tmuxref               Show tmux reference${NC}"
echo ""

echo -e "${CYAN}⚡ Quick Start:${NC}"
echo -e "${GRAY}  Ctrl+R                Search command history${NC}"
echo -e "${GRAY}  Ctrl+T                Find files (fzf)${NC}"
echo -e "${GRAY}  z <name>              Smart directory jump${NC}"
echo -e "${GRAY}  fe                    Find and edit file${NC}"
echo -e "${GRAY}  fssh                  SSH with fzf selector${NC}"
echo ""

echo -e "${CYAN}🖥️  Kitty Hotkeys:${NC}"
echo -e "${GRAY}  Cmd+D                 Vertical split${NC}"
echo -e "${GRAY}  Cmd+H/J/K/L           Navigate splits (vim)${NC}"
echo -e "${GRAY}  Cmd+Shift+Z           Zoom split${NC}"
echo -e "${GRAY}  Cmd+T                 New tab${NC}"
echo -e "${GRAY}  Cmd+Shift+E           Open URLs/paths${NC}"
echo -e "${GRAY}  Cmd+Shift+S           SSH with fzf${NC}"
echo ""

echo -e "${CYAN}📦 Tmux:${NC}"
echo -e "${GRAY}  t / ta / tn <name>    Start / Attach / New session${NC}"
echo -e "${GRAY}  Ctrl+A ?              Show all tmux keys${NC}"
echo -e "${GRAY}  Ctrl+A | / -          Split vertical / horizontal${NC}"
echo ""

echo -e "${CYAN}🔧 Plugins:${NC}"
echo -e "${GRAY}  ZSH:  git, fzf-tab, autosuggestions, syntax-highlighting${NC}"
echo -e "${GRAY}  Tmux: resurrect, continuum, yank, fzf (Ctrl+A Ctrl+F)${NC}"
echo ""
