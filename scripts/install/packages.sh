#!/bin/sh
# Install system packages.
set -e

SCRIPTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$SCRIPTS_DIR/lib/utils.sh"

OS="$(detect_os)"

case "$OS" in
    void)
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

        info "Installing packages with xbps..."
        # shellcheck disable=SC2086
        xbps-install -y $PACKAGES
        ;;
    darwin)
        need_cmd brew

        BREW_PACKAGES="
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
            coreutils
        "

        info "Updating Homebrew metadata..."
        brew update

        info "Installing packages with brew..."
        # shellcheck disable=SC2086
        brew install $BREW_PACKAGES
        ;;
    *)
        die "Unsupported OS for packages install: $OS"
        ;;
esac

ok "System packages installed."
