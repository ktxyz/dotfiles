#!/bin/sh
# Install Python 3 and UV package manager.
set -e

SCRIPTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$SCRIPTS_DIR/lib/utils.sh"

need_cmd curl

OS="$(detect_os)"

# --- Install python3 via system package manager ---
if ! has_cmd python3; then
    info "Installing python3..."
    case "$OS" in
        void) sudo xbps-install -y python3 ;;
        darwin)
            need_cmd brew
            brew install python
            ;;
        *)    die "Unsupported OS for python install: $OS" ;;
    esac
else
    ok "python3 already installed."
fi

# --- Install UV ---
if ! has_cmd uv; then
    info "Installing UV..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    ok "UV already installed."
fi

ok "Python + UV ready."
