# Aliases

if ls --color=auto >/dev/null 2>&1; then
    alias ls='ls --color=auto'
    alias ll='ls -lAh'
elif command -v gls >/dev/null 2>&1; then
    alias ls='gls --color=auto'
    alias ll='gls -lAh'
else
    alias ls='ls'
    alias ll='ls -lAh'
fi

alias la='ls -A'

if grep --color=auto '' /dev/null >/dev/null 2>&1; then
    alias grep='grep --color=auto'
elif command -v ggrep >/dev/null 2>&1; then
    alias grep='ggrep --color=auto'
fi

alias ..='cd ..'
alias ...='cd ../..'

alias v='nvim'

alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
