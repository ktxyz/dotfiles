# Prompt — user@host:path (branch) $

__git_branch() {
    local branch
    branch="$(git symbolic-ref --short HEAD 2>/dev/null)" || return
    printf ' (%s)' "$branch"
}

PS1='\[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0;33m\]$(__git_branch)\[\033[0m\]\$ '
