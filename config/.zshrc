# ============================================================================
# Powerlevel10k instant prompt
# ============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================================
# Oh My Zsh
# ============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  fzf-tab
  zsh-autosuggestions
  fast-syntax-highlighting
  history-substring-search
)

source $ZSH/oh-my-zsh.sh

# ============================================================================
# FZF Configuration
# ============================================================================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --inline-info
  --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7
  --color=fg+:#c0caf5,bg+:#292e42,hl+:#7dcfff
  --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
  --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a'

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"

# ============================================================================
# Zoxide (smart cd)
# ============================================================================
export _ZO_DOCTOR=0  # Disable zoxide doctor warnings
eval "$(zoxide init zsh)"

# ============================================================================
# Aliases
# ============================================================================

# Modern replacements
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'
alias cat='bat --paging=never'
alias less='bat'

# System
alias top='btop'

# Tmux
alias t='tmux'
alias ta='tmux attach'
alias tn='tmux new -s'
alias tl='tmux ls'
alias tk='tmux kill-session -t'

# Documentation
alias ref='bat ~/.aliases.md'
alias tmuxref='bat ~/.tmux.md'

# ============================================================================
# Functions
# ============================================================================

# Find and edit file with fzf
function fe() {
  local file
  file=$(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

# cd to directory of selected file
function fcd() {
  local file
  local dir
  file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# Kill process with fzf
function fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

# SSH with fzf from ~/.ssh/config
function fssh() {
  local host
  host=$(grep "^Host " ~/.ssh/config 2>/dev/null | grep -v "\*" | cut -d' ' -f2 | fzf)
  [ -n "$host" ] && ssh "$host"
}

# Activate Python venv from ~/VSC
function venv() {
  source ~/VSC/venv/bin/activate
}

# ============================================================================
# History Configuration
# ============================================================================
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

# ============================================================================
# FZF-tab Configuration
# ============================================================================
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group ',' '.'

# ============================================================================
# Powerlevel10k
# ============================================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================================================
# Welcome message (not in tmux or SSH)
# ============================================================================
if [[ -z "$TMUX" ]] && [[ -z "$SSH_CONNECTION" ]]; then
  ~/.welcome.sh
fi

# ============================================================================
# SDKMAN
# ============================================================================
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ============================================================================
# Custom PATH
# ============================================================================
export PATH="$HOME/assreaper/hashcat:$PATH"
