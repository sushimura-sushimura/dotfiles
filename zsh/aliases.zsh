# =========================================================
# Alias Settings - Improved Command Tools
# This file is sourced by .zshrc
# =========================================================

# cat replacement - with syntax highlighting
alias cat='bat'

# ls replacement - with colors and icons (eza)
alias ls='eza --icons --git'
alias ll='eza -alF --icons --git'
alias la='eza -A --icons --git'

# tree display - eza based
alias tree='eza --tree --icons --git'
alias tree2='eza --tree --level=2 --icons --git'
alias tree3='eza --tree --level=3 --icons --git'

# find replacement - fast search
alias find='fd'

# grep replacement - fast grep
alias grep='rg'

# Git convenience aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias glog='git log --oneline --graph --decorate'

# System
alias reload='source ~/.zshrc'

# Claude Code convenience aliases
# Make sure ~/.claude/local/claude exists and is executable.
alias claude="~/.claude/local/claude"
alias cc='claude'
alias yolo="claude --dangerously-skip-permissions"

# rm replacement - move to trash (safe-rm)
# Ensure safe-rm is installed.
alias rm='safe-rm'