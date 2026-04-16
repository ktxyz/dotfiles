# Plugin bootstrap and completion setup

ZSH_PLUGIN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
mkdir -p "$ZSH_PLUGIN_DIR"

clone_plugin() {
    repo="$1"
    dir="$2"

    if [ -d "$dir/.git" ]; then
        return
    fi

    if command -v git >/dev/null 2>&1; then
        git clone --depth 1 "$repo" "$dir" >/dev/null 2>&1 || true
    fi
}

clone_plugin https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGIN_DIR/zsh-autosuggestions"
clone_plugin https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting"
clone_plugin https://github.com/zsh-users/zsh-history-substring-search "$ZSH_PLUGIN_DIR/zsh-history-substring-search"
clone_plugin https://github.com/Aloxaf/fzf-tab "$ZSH_PLUGIN_DIR/fzf-tab"

if [ -n "$XDG_CACHE_HOME" ]; then
    mkdir -p "$XDG_CACHE_HOME/zsh"
    autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
else
    autoload -Uz compinit && compinit
fi

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select

if [ -f "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    . "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [ -f "$ZSH_PLUGIN_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh" ]; then
    . "$ZSH_PLUGIN_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh"
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
fi

if [ -f "$ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh" ]; then
    . "$ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh"
fi

# Keep syntax highlighting last to avoid color issues with other widgets.
if [ -f "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    . "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
