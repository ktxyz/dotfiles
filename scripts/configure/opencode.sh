#!/bin/sh
# Configure opencode provider/auth for this machine.
set -e

SCRIPTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$SCRIPTS_DIR/lib/utils.sh"

if ! has_cmd opencode; then
    PATH="$HOME/.opencode/bin:$PATH"
    export PATH
fi

if ! has_cmd opencode; then
    warn "opencode CLI not found; skipping opencode configure step."
    warn "Install it first with: ./install.sh --opencode"
    exit 0
fi

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
OPENCODE_CONFIG_DIR="$XDG_CONFIG_HOME/opencode"
mkdir -p "$OPENCODE_CONFIG_DIR"

if [ -n "$(find "$OPENCODE_CONFIG_DIR" -type f 2>/dev/null | head -n 1)" ]; then
    ok "opencode config already present in $OPENCODE_CONFIG_DIR"
    exit 0
fi

info "Setting up opencode auth/provider..."
info "In opencode, run /connect and complete provider auth."
printf 'Open opencode now? [y/N]: ' > /dev/tty
read -r open_now < /dev/tty || open_now="n"

case "$open_now" in
    y|Y|yes|YES)
        opencode
        ;;
    *)
        info "Skipped. You can run 'opencode' later and execute /connect."
        ;;
esac

if [ -n "$(find "$OPENCODE_CONFIG_DIR" -type f 2>/dev/null | head -n 1)" ]; then
    ok "opencode appears configured."
else
    warn "No opencode config detected yet in $OPENCODE_CONFIG_DIR"
    warn "Run 'opencode' and complete /connect when ready."
fi
