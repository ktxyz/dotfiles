#!/bin/sh
# Main dotfiles installer — run all steps or pick individual ones.
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
export DOTFILES_DIR

# Ensure all scripts are executable (git may not preserve +x on clone)
chmod +x "$DOTFILES_DIR/scripts/install/"*.sh 2>/dev/null || true
chmod +x "$DOTFILES_DIR/scripts/configure/"*.sh 2>/dev/null || true

. "$DOTFILES_DIR/scripts/lib/utils.sh"

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
do_packages=false
do_drivers=false
do_desktop=false
do_python=false
do_link=false
do_configure=false
do_all=true

for arg in "$@"; do
    case "$arg" in
        --packages)   do_packages=true;   do_all=false ;;
        --drivers)    do_drivers=true;    do_all=false ;;
        --desktop)    do_desktop=true;    do_all=false ;;
        --python)     do_python=true;     do_all=false ;;
        --link)       do_link=true;       do_all=false ;;
        --configure)  do_configure=true;  do_all=false ;;
        --help|-h)
            printf 'Usage: install.sh [--packages] [--drivers] [--desktop] [--python] [--link] [--configure]\n'
            printf '  No flags = run everything.\n'
            exit 0
            ;;
        *) die "Unknown option: $arg" ;;
    esac
done

# ---------------------------------------------------------------------------
# Steps
# ---------------------------------------------------------------------------
run_packages() {
    info "Installing system packages..."
    sudo sh "$DOTFILES_DIR/scripts/install/packages.sh"
}

run_drivers() {
    if [ "$(detect_os)" = "darwin" ]; then
        info "macOS detected, skipping drivers."
        return
    fi
    info "Installing hardware drivers..."
    sudo sh "$DOTFILES_DIR/scripts/install/drivers.sh"
}

run_desktop() {
    if [ "$(detect_os)" = "darwin" ]; then
        info "macOS detected, skipping desktop."
        return
    fi
    info "Installing desktop environment..."
    sh "$DOTFILES_DIR/scripts/install/desktop.sh"
}

run_python() {
    info "Setting up Python + UV..."
    sh "$DOTFILES_DIR/scripts/install/python.sh"
}

run_link() {
    need_cmd stow
    info "Linking config with GNU Stow..."

    backup_dir="$DOTFILES_DIR/.backup/$(date +%Y%m%d%H%M%S)"

    # Collect every file that stow would manage and back up existing
    # non-symlink copies before stow touches them.
    cd "$DOTFILES_DIR/home"
    for pkg in */; do
        pkg="${pkg%/}"
        # Walk the package to find every target file
        find "$pkg" -type f | while read -r rel; do
            target="$HOME/${rel#"$pkg"/}"
            if [ -f "$target" ] && [ ! -L "$target" ]; then
                dest="$backup_dir/$rel"
                mkdir -p "$(dirname "$dest")"
                cp "$target" "$dest"
            fi
        done
    done

    if [ -d "$backup_dir" ]; then
        info "Backed up existing configs to $backup_dir"
    fi

    # Now stow is safe — adopt pulls existing files in, then we restore
    # repo versions so the symlinks point to our config.
    for pkg in */; do
        pkg="${pkg%/}"
        info "  stow $pkg"
        stow -v --target="$HOME" --adopt "$pkg"
    done
    git -C "$DOTFILES_DIR" checkout -- home/

    ok "All configs linked."
}

run_configure() {
    info "Running configure scripts..."
    for f in "$DOTFILES_DIR/scripts/configure/"*.sh; do
        [ -r "$f" ] && sh "$f"
    done
}

# ---------------------------------------------------------------------------
# Execute
# ---------------------------------------------------------------------------
if [ "$do_all" = true ]; then
    run_packages
    run_drivers
    run_desktop
    run_python
    run_link
    run_configure
else
    [ "$do_packages"  = true ] && run_packages
    [ "$do_drivers"   = true ] && run_drivers
    [ "$do_desktop"   = true ] && run_desktop
    [ "$do_python"    = true ] && run_python
    [ "$do_link"      = true ] && run_link
    [ "$do_configure" = true ] && run_configure
fi

ok "Done."
