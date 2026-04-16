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
do_debug=false
do_zls=false
do_link=false
do_configure=false
do_all=true
shell_choice=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        --packages)   do_packages=true;   do_all=false ;;
        --drivers)    do_drivers=true;    do_all=false ;;
        --desktop)    do_desktop=true;    do_all=false ;;
        --python)     do_python=true;     do_all=false ;;
        --debug)      do_debug=true;      do_all=false ;;
        --zls)        do_zls=true;        do_all=false ;;
        --link)       do_link=true;       do_all=false ;;
        --configure)  do_configure=true;  do_all=false ;;
        --shell)
            shift
            [ -n "$1" ] || die "--shell requires a value: zsh or bash"
            shell_choice="$1"
            ;;
        --help|-h)
            printf 'Usage: install.sh [--packages] [--drivers] [--desktop] [--python] [--debug] [--zls] [--link] [--configure] [--shell zsh|bash]\n'
            printf '  No flags = run everything.\n'
            exit 0
            ;;
        *) die "Unknown option: $1" ;;
    esac
    shift
done

normalize_shell_choice() {
    case "$shell_choice" in
        "") ;;
        zsh|bash) ;;
        *) die "Unsupported shell: $shell_choice (expected zsh or bash)" ;;
    esac
}

prompt_shell_choice() {
    [ -n "$shell_choice" ] && return

    shell_choice="zsh"
    if [ -r /dev/tty ]; then
        while :; do
            printf 'Select shell [zsh/bash] (default: zsh): ' > /dev/tty
            if ! IFS= read -r answer < /dev/tty; then
                break
            fi

            case "$answer" in
                ""|zsh|ZSH) shell_choice="zsh"; break ;;
                bash|BASH)   shell_choice="bash"; break ;;
                *)
                    printf 'Invalid choice. Please use zsh or bash.\n' > /dev/tty
                    ;;
            esac
        done
    fi
}

selected_shell_path() {
    if [ "$shell_choice" = "zsh" ]; then
        command -v zsh 2>/dev/null || true
    else
        command -v bash 2>/dev/null || true
    fi
}

maybe_set_login_shell() {
    target_shell="$(selected_shell_path)"

    if [ -z "$target_shell" ]; then
        warn "Selected shell '$shell_choice' is not installed; skipping login-shell change."
        return
    fi

    if [ "$SHELL" = "$target_shell" ]; then
        ok "Login shell already set to $target_shell"
        return
    fi

    if ! grep -qx "$target_shell" /etc/shells 2>/dev/null; then
        warn "$target_shell is not listed in /etc/shells; skipping login-shell change."
        return
    fi

    info "Setting login shell to $target_shell..."
    if chsh -s "$target_shell" >/dev/null 2>&1; then
        ok "Login shell changed to $target_shell"
    else
        warn "Could not change login shell automatically. Run: chsh -s $target_shell"
    fi
}

should_stow_package() {
    pkg="$1"
    os="$2"

    if [ "$pkg" = "bash" ] && [ "$shell_choice" != "bash" ]; then
        return 1
    fi

    if [ "$pkg" = "zsh" ] && [ "$shell_choice" != "zsh" ]; then
        return 1
    fi

    if [ "$os" = "darwin" ]; then
        case "$pkg" in
            hypr|waybar|mako|wofi|foot)
                return 1
                ;;
        esac
    else
        case "$pkg" in
            ghostty)
                return 1
                ;;
        esac
    fi

    return 0
}

# ---------------------------------------------------------------------------
# Steps
# ---------------------------------------------------------------------------
run_packages() {
    info "Installing system packages..."
    if [ "$(detect_os)" = "void" ]; then
        sudo sh "$DOTFILES_DIR/scripts/install/packages.sh"
    else
        sh "$DOTFILES_DIR/scripts/install/packages.sh"
    fi
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

run_debug() {
    info "Installing debugger tooling..."
    sh "$DOTFILES_DIR/scripts/install/debug.sh"
}

run_zls() {
    info "Installing ZLS from source..."
    sh "$DOTFILES_DIR/scripts/install/zls.sh"
}

run_link() {
    need_cmd stow

    if [ -z "$shell_choice" ]; then
        prompt_shell_choice
    fi

    info "Linking config with GNU Stow..."

    backup_dir="$DOTFILES_DIR/.backup/$(date +%Y%m%d%H%M%S)"
    os="$(detect_os)"

    # Collect managed target roots and move existing unmanaged
    # files/directories/symlinks out of the way before stow runs.
    cd "$DOTFILES_DIR/home"
    for pkg in */; do
        pkg="${pkg%/}"

        if ! should_stow_package "$pkg" "$os"; then
            continue
        fi

        # Derive stow roots from package files: one path component for
        # top-level files, two components for nested trees (e.g. .config/nvim).
        find "$pkg" -type f | while read -r rel; do
            rel="${rel#"$pkg"/}"
            old_ifs="$IFS"
            IFS='/'
            set -- $rel
            IFS="$old_ifs"

            if [ "$#" -ge 2 ]; then
                printf '%s/%s\n' "$1" "$2"
            else
                printf '%s\n' "$1"
            fi
        done | sort -u | while read -r root; do
            target="$HOME/$root"
            if [ -e "$target" ] || [ -L "$target" ]; then
                dest="$backup_dir/$root"
                mkdir -p "$(dirname "$dest")"
                mv "$target" "$dest"
            fi
        done
    done

    if [ -d "$backup_dir" ]; then
        info "Backed up existing configs to $backup_dir"
    fi

    # Targets were backed up and conflicting files/symlinks moved above.
    # Use adopt to safely handle existing unmanaged directories.
    for pkg in */; do
        pkg="${pkg%/}"

        if ! should_stow_package "$pkg" "$os"; then
            continue
        fi

        info "  stow $pkg"
        stow -v --target="$HOME" --adopt "$pkg"
    done
    git -C "$DOTFILES_DIR" checkout -- home/

    ok "All configs linked."
    maybe_set_login_shell
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
normalize_shell_choice

if [ "$do_all" = true ]; then
    prompt_shell_choice
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
    [ "$do_debug"     = true ] && run_debug
    [ "$do_zls"       = true ] && run_zls
    [ "$do_link"      = true ] && run_link
    [ "$do_configure" = true ] && run_configure
fi

ok "Done."
