#!/bin/sh
# Build and install ZLS from source.
set -e

SCRIPTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$SCRIPTS_DIR/lib/utils.sh"

need_cmd git

OS="$(detect_os)"

XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"

# Ensure zigup path-link target is available and takes precedence.
PATH="$XDG_BIN_HOME:$PATH"
export PATH

ZLS_SRC_DIR="$XDG_DATA_HOME/zls-src"
ZLS_REPO_URL="https://github.com/zigtools/zls"
ZLS_REF="${ZLS_REF:-master}"
ZIG_VERSION=""
ZIG_REQUIRED_VERSION=""

zls_required_zig_version() {
    zon_file="$1/build.zig.zon"
    if [ ! -f "$zon_file" ]; then
        return
    fi

    sed -n 's/.*\.minimum_zig_version = "\([^"]*\)".*/\1/p' "$zon_file" | head -n 1
}

ensure_zig_toolchain() {
    case "$OS" in
        darwin)
            if ! has_cmd zigup; then
                need_cmd brew
                info "Installing zigup..."
                brew install zigup
            fi

            if [ "$ZLS_REF" = "master" ]; then
                if [ -n "$ZIG_REQUIRED_VERSION" ]; then
                    info "Installing Zig required by ZLS: $ZIG_REQUIRED_VERSION"
                    mkdir -p "$XDG_BIN_HOME"
                    zigup --path-link "$XDG_BIN_HOME/zig" "$ZIG_REQUIRED_VERSION"
                else
                    info "Installing/updating Zig nightly via zigup..."
                    mkdir -p "$XDG_BIN_HOME"
                    zigup --path-link "$XDG_BIN_HOME/zig" master
                fi
            elif [ -n "$ZIG_REQUIRED_VERSION" ]; then
                info "Installing Zig required by ZLS ref: $ZIG_REQUIRED_VERSION"
                mkdir -p "$XDG_BIN_HOME"
                zigup --path-link "$XDG_BIN_HOME/zig" "$ZIG_REQUIRED_VERSION"
            fi
            ;;
    esac

    need_cmd zig
    ZIG_VERSION="$(zig version)"
}

mkdir -p "$XDG_DATA_HOME" "$XDG_BIN_HOME"

if [ -d "$ZLS_SRC_DIR/.git" ]; then
    info "Updating ZLS source checkout..."
    git -C "$ZLS_SRC_DIR" fetch --all --tags --prune
else
    info "Cloning ZLS source..."
    git clone "$ZLS_REPO_URL" "$ZLS_SRC_DIR"
fi

info "Checking out ZLS ref: $ZLS_REF"
git -C "$ZLS_SRC_DIR" checkout "$ZLS_REF"

ZIG_REQUIRED_VERSION="$(zls_required_zig_version "$ZLS_SRC_DIR")"

ensure_zig_toolchain

if [ "$ZLS_REF" = "master" ]; then
    case "$ZIG_VERSION" in
        *-dev.*) ;;
        *)
            warn "ZLS master currently expects a Zig development build."
            warn "Your Zig version is: $ZIG_VERSION"
            warn "Use a nightly Zig toolchain, then re-run ./install.sh --zls"
            warn "Or pin ZLS to a release tag: ZLS_REF=0.15.1 ./install.sh --zls"
            die "Cannot build ZLS master with stable Zig toolchain."
            ;;
    esac
fi

info "Building ZLS with zig..."
if ! (
    cd "$ZLS_SRC_DIR"
    zig build -Doptimize=ReleaseSafe
); then
    die "ZLS build failed. Set ZLS_REF to a compatible tag or use Zig nightly for master."
fi

if [ ! -x "$ZLS_SRC_DIR/zig-out/bin/zls" ]; then
    die "ZLS build completed but binary was not found at zig-out/bin/zls"
fi

info "Installing ZLS binary to $XDG_BIN_HOME/zls"
cp "$ZLS_SRC_DIR/zig-out/bin/zls" "$XDG_BIN_HOME/zls"
chmod +x "$XDG_BIN_HOME/zls"

ok "ZLS installed from source."
info "Version: $($XDG_BIN_HOME/zls --version 2>/dev/null || printf 'unknown')"
