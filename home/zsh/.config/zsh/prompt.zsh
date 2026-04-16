# Prompt -- user@host:path (branch) $

setopt PROMPT_SUBST

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
    return
fi

__git_branch() {
    local branch
    branch="$(git symbolic-ref --short HEAD 2>/dev/null)" || return
    printf ' (%s)' "$branch"
}

PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%F{yellow}$(__git_branch)%f%# '
