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
    cd "$DOTFILES_DIR/home"

    for pkg in */; do
        pkg="${pkg%/}"
        info "  stow $pkg"
        stow -v --target="$HOME" --adopt "$pkg"
    done

    # --adopt pulled existing user files into home/, dirtying the repo.
    # Stash them so we can restore repo versions but keep the user's
    # originals recoverable.
    if ! git -C "$DOTFILES_DIR" diff --quiet -- home/; then
        info "Backing up adopted user configs to git stash..."
        git -C "$DOTFILES_DIR" stash push -m "adopted-configs-$(date +%Y%m%d%H%M%S)" -- home/
    fi

    ok "All configs linked."
    info "If you need to recover previous configs: git stash list / git stash show -p"
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
