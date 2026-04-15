#!/bin/sh
# Main dotfiles installer — run all steps or pick individual ones.
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
export DOTFILES_DIR

. "$DOTFILES_DIR/scripts/lib/utils.sh"

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
do_packages=false
do_python=false
do_link=false
do_configure=false
do_all=true

for arg in "$@"; do
    case "$arg" in
        --packages)   do_packages=true;   do_all=false ;;
        --python)     do_python=true;     do_all=false ;;
        --link)       do_link=true;       do_all=false ;;
        --configure)  do_configure=true;  do_all=false ;;
        --help|-h)
            printf 'Usage: install.sh [--packages] [--python] [--link] [--configure]\n'
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
    run_python
    run_link
    run_configure
else
    [ "$do_packages"  = true ] && run_packages
    [ "$do_python"    = true ] && run_python
    [ "$do_link"      = true ] && run_link
    [ "$do_configure" = true ] && run_configure
fi

ok "Done."
