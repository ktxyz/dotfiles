#!/bin/sh
# Install opencode CLI.
set -e

SCRIPTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$SCRIPTS_DIR/lib/utils.sh"

OS="$(detect_os)"
XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"
OPENCODE_FALLBACK_BIN="$HOME/.opencode/bin"

PATH="$XDG_BIN_HOME:$OPENCODE_FALLBACK_BIN:$PATH"
export PATH

if has_cmd opencode; then
    ok "opencode already installed: $(opencode --version 2>/dev/null || printf 'unknown')"
    exit 0
fi

install_with_package_manager() {
    case "$OS" in
        darwin)
            need_cmd brew
            info "Installing opencode with Homebrew..."
            if brew install anomalyco/tap/opencode; then
                return 0
            fi
            brew install opencode
            ;;
        *)
            if has_cmd brew; then
                info "Installing opencode with Homebrew..."
                if brew install anomalyco/tap/opencode; then
                    return 0
                fi
                brew install opencode
                return 0
            fi
            ;;
    esac

    return 1
}

install_with_script() {
    need_cmd curl
    need_cmd bash

    mkdir -p "$XDG_BIN_HOME"

    info "Installing opencode via official install script..."
    OPENCODE_INSTALL_DIR="$XDG_BIN_HOME" curl -fsSL https://opencode.ai/install | bash
}

if ! install_with_package_manager; then
    install_with_script
fi

need_cmd opencode
ok "opencode installed: $(opencode --version 2>/dev/null || printf 'unknown')"
