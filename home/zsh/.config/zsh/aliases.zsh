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
alias lt='ls -lahtr'

if grep --color=auto '' /dev/null >/dev/null 2>&1; then
    alias grep='grep --color=auto'
elif command -v ggrep >/dev/null 2>&1; then
    alias grep='ggrep --color=auto'
fi

alias ..='cd ..'
alias ...='cd ../..'

alias v='nvim'
alias c='clear'

alias mkdir='mkdir -p'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gdc='git diff --cached'
alias gc='git commit'
alias gco='git checkout'
alias glg='git log --graph --decorate --oneline --all'
alias gl='git log --oneline --graph --decorate -20'
