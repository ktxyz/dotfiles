#!/bin/sh
# Bootstrap script — pipe from curl on a fresh machine:
#   curl -fsSL https://raw.githubusercontent.com/ktxyz/dotfiles/main/bootstrap.sh | sh
set -e

DOTFILES_DIR="$HOME/.dotfiles"
REPO="https://github.com/ktxyz/dotfiles.git"

_info() { printf '\033[34m[info]  %s\033[0m\n' "$*"; }
_err()  { printf '\033[31m[error] %s\033[0m\n' "$*"; exit 1; }

# --- Ensure git is available ---
if ! command -v git >/dev/null 2>&1; then
    _info "git not found, installing..."
    if [ -f /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        case "$ID" in
            void)   sudo xbps-install -Sy git ;;
            *)      _err "Unsupported OS for bootstrap: $ID" ;;
        esac
    else
        _err "Cannot detect OS — install git manually and re-run."
    fi
fi

# --- Clone or update the repo ---
if [ -d "$DOTFILES_DIR" ]; then
    _info "Dotfiles already cloned, pulling latest..."
    if ! git -C "$DOTFILES_DIR" diff --quiet 2>/dev/null; then
        _info "Stashing local changes..."
        git -C "$DOTFILES_DIR" stash push -m "bootstrap-$(date +%Y%m%d%H%M%S)"
    fi
    git -C "$DOTFILES_DIR" pull --ff-only
else
    _info "Cloning dotfiles..."
    git clone "$REPO" "$DOTFILES_DIR"
fi

# --- Hand off to the full installer ---
# When piped from curl, stdin is not a terminal. Some install steps
# (e.g. xbps key import) need interactive input. Use exec so the
# installer gets a real TTY from /dev/tty.
_info "Running installer..."
exec sh "$DOTFILES_DIR/install.sh" </dev/tty
