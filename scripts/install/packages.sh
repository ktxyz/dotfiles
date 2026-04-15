#!/bin/sh
# Install system packages on Void Linux via xbps.
set -e

SCRIPTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$SCRIPTS_DIR/lib/utils.sh"

OS="$(detect_os)"
if [ "$OS" != "void" ]; then
    die "packages.sh only supports Void Linux (detected: $OS)"
fi

need_root

info "Syncing repositories and updating system..."
xbps-install -Syu

PACKAGES="
    curl
    wget
    git
    stow
    make

    ripgrep
    fd
    bat
    fzf

    neovim
    tmux

    base-devel
"

info "Installing packages..."
# shellcheck disable=SC2086
xbps-install -y $PACKAGES

ok "System packages installed."
