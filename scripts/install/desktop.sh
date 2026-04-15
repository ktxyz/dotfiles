#!/bin/sh
# Install Hyprland desktop stack, audio, and supporting tools.
set -e

SCRIPTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$SCRIPTS_DIR/lib/utils.sh"

OS="$(detect_os)"

if [ "$OS" = "darwin" ]; then
    info "macOS detected, skipping desktop install."
    exit 0
fi

if [ "$OS" != "void" ]; then
    die "desktop.sh only supports Void Linux (detected: $OS)"
fi

need_root

# ---------------------------------------------------------------------------
# Hyprland repository (not in default Void repos)
# ---------------------------------------------------------------------------
HYPR_REPO="/etc/xbps.d/hyprland-void.conf"
HYPR_REPO_URL="https://raw.githubusercontent.com/Makrennel/hyprland-void/repository-x86_64-glibc"

# Always overwrite to fix stale/typo'd URLs from previous runs
info "Configuring Hyprland repository..."
echo "repository=$HYPR_REPO_URL" > "$HYPR_REPO"

# xbps won't auto-accept signing keys even with -y, and stdin may not
# be a terminal inside sudo (causing EAGAIN). Pipe "yes" to accept.
info "Syncing repositories..."
yes | xbps-install -S || die "Failed to sync repos. Try running 'sudo xbps-install -S' manually and accept the key."

# ---------------------------------------------------------------------------
# Packages
# ---------------------------------------------------------------------------
info "Installing desktop packages..."

PACKAGES="
    hyprland
    xdg-desktop-portal-hyprland

    hyprpaper
    hypridle
    hyprlock

    waybar
    foot
    wofi
    mako

    pipewire
    wireplumber

    grim
    slurp
    brightnessctl
    wl-clipboard

    seatd
    dbus
    polkit

    nerd-fonts
"

# shellcheck disable=SC2086
xbps-install -y $PACKAGES

# ---------------------------------------------------------------------------
# Services
# ---------------------------------------------------------------------------
for svc in seatd dbus; do
    if [ ! -e "/var/service/$svc" ]; then
        ln -s "/etc/sv/$svc" /var/service/
        info "Enabled $svc service."
    fi
done

# ---------------------------------------------------------------------------
# User groups
# ---------------------------------------------------------------------------
DESKTOP_USER="${SUDO_USER:-$(whoami)}"

for grp in _seatd audio video input; do
    if ! groups "$DESKTOP_USER" 2>/dev/null | grep -q "$grp"; then
        usermod -aG "$grp" "$DESKTOP_USER"
        info "Added $DESKTOP_USER to $grp group."
    fi
done

# ---------------------------------------------------------------------------
# PipeWire configuration
# ---------------------------------------------------------------------------
info "Configuring PipeWire..."
mkdir -p /etc/pipewire/pipewire.conf.d

for conf in \
    /usr/share/examples/wireplumber/10-wireplumber.conf \
    /usr/share/examples/pipewire/20-pipewire-pulse.conf; do
    if [ -f "$conf" ] && [ ! -e "/etc/pipewire/pipewire.conf.d/$(basename "$conf")" ]; then
        ln -s "$conf" /etc/pipewire/pipewire.conf.d/
    fi
done

ok "Desktop environment installed."
info "Log out and back in for group changes to take effect."
info "Start Hyprland with: Hyprland"
