#!/bin/sh
# Install debugger tooling with optional GDB enhancements.
set -e

SCRIPTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$SCRIPTS_DIR/lib/utils.sh"

OS="$(detect_os)"

install_gef() {
    need_cmd curl

    gdbinit="$HOME/.gdbinit"
    gef_dir="$HOME/.config/gdb"
    gef_file="$gef_dir/gef.py"

    mkdir -p "$gef_dir"

    if [ ! -f "$gef_file" ]; then
        info "Installing GEF plugin..."
        curl -fsSL https://raw.githubusercontent.com/hugsy/gef/main/gef.py -o "$gef_file"
    else
        ok "GEF plugin already installed."
    fi

    if ! grep -q 'source ~/.config/gdb/gef.py' "$gdbinit" 2>/dev/null; then
        info "Enabling GEF in ~/.gdbinit..."
        {
            printf '\n# GEF plugin\n'
            printf 'source ~/.config/gdb/gef.py\n'
        } >> "$gdbinit"
    else
        ok "GEF already enabled in ~/.gdbinit."
    fi
}

case "$OS" in
    void)
        need_root
        info "Installing gdb with xbps..."
        xbps-install -y gdb
        install_gef
        ;;
    darwin)
        need_cmd brew
        info "Installing gdb with Homebrew..."
        brew install gdb
        install_gef
        warn "macOS requires codesigning gdb before attach/debug works."
        warn "See docs/cheatsheet-install.md section: Debugger Tools."
        ;;
    *)
        die "Unsupported OS for debugger tooling: $OS"
        ;;
esac

ok "Debugger tooling installed."
