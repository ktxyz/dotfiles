#!/bin/sh
# Shared utilities sourced by all install scripts.

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
_color() {
    printf '\033[%sm%s\033[0m\n' "$1" "$2"
}

info()  { _color "34" "[info]  $*"; }
ok()    { _color "32" "[ok]    $*"; }
warn()  { _color "33" "[warn]  $*"; }
err()   { _color "31" "[error] $*"; }
die()   { err "$@"; exit 1; }

# ---------------------------------------------------------------------------
# OS detection (reads /etc/os-release)
# ---------------------------------------------------------------------------
detect_os() {
    if [ -f /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        printf '%s' "$ID"
    else
        printf '%s' "unknown"
    fi
}

# ---------------------------------------------------------------------------
# Command helpers
# ---------------------------------------------------------------------------
has_cmd() { command -v "$1" >/dev/null 2>&1; }

need_cmd() {
    if ! has_cmd "$1"; then
        die "Required command '$1' not found."
    fi
}

need_root() {
    if [ "$(id -u)" -ne 0 ]; then
        die "This script must be run as root (or via sudo)."
    fi
}
