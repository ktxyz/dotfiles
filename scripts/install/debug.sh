#!/bin/sh
# Install debugger tooling with optional GDB enhancements.
set -e

SCRIPTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$SCRIPTS_DIR/lib/utils.sh"

OS="$(detect_os)"
XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"

PATH="$XDG_BIN_HOME:$PATH"
export PATH

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

ensure_readelf() {
    readelf_src=""

    if has_cmd readelf; then
        ok "readelf already available."
        return
    fi

    mkdir -p "$XDG_BIN_HOME"

    if has_cmd greadelf; then
        readelf_src="$(command -v greadelf)"
    fi

    if [ -z "$readelf_src" ] && has_cmd brew; then
        binutils_prefix="$(brew --prefix binutils 2>/dev/null || true)"
        if [ -n "$binutils_prefix" ] && [ -x "$binutils_prefix/bin/greadelf" ]; then
            readelf_src="$binutils_prefix/bin/greadelf"
        fi
    fi

    if [ -z "$readelf_src" ] && has_cmd llvm-readelf; then
        readelf_src="$(command -v llvm-readelf)"
    fi

    if [ -z "$readelf_src" ]; then
        die "Could not find greadelf or llvm-readelf to provide readelf."
    fi

    info "Creating readelf shim: $readelf_src"
    ln -sf "$readelf_src" "$XDG_BIN_HOME/readelf"
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
        info "Installing binutils (for readelf)..."
        brew install binutils
        ensure_readelf
        install_gef
        warn "macOS requires codesigning gdb before attach/debug works."
        warn "See docs/cheatsheet-install.md section: Debugger Tools."
        ;;
    *)
        die "Unsupported OS for debugger tooling: $OS"
        ;;
esac

ok "Debugger tooling installed."
