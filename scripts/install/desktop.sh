#!/bin/sh
# Install Hyprland desktop stack, audio, and supporting tools.
# Runs as normal user; uses sudo for privileged commands.
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

# ---------------------------------------------------------------------------
# Hyprland repository (not in default Void repos)
# ---------------------------------------------------------------------------
HYPR_REPO="/etc/xbps.d/hyprland-void.conf"
HYPR_REPO_URL="https://github.com/void-land/hyprland-void-packages/releases/latest/download/"

# Remove stale Makrennel repo if present (has shlib version conflicts)
sudo rm -f /etc/xbps.d/hyprland-void.conf

info "Configuring Hyprland repository (void-land)..."
sudo sh -c "echo 'repository=$HYPR_REPO_URL' > '$HYPR_REPO'"

info "Syncing repositories (accept the signing key if prompted)..."
sudo xbps-install -S

# Full system update first — shlib mismatches happen when the base
# system is behind the third-party repo.
info "Updating system..."
sudo xbps-install -yu

# ---------------------------------------------------------------------------
# Packages
# ---------------------------------------------------------------------------
# Install all hyprland ecosystem packages in one transaction so their
# shared libraries resolve against each other.
info "Installing Hyprland ecosystem..."
sudo xbps-install -y \
    hyprland hyprutils hyprlang hyprcursor aquamarine \
    hyprland-protocols hyprwayland-scanner \
    xdg-desktop-portal-hyprland \
    hyprpaper hypridle hyprlock

info "Installing desktop tools..."
sudo xbps-install -y \
    Waybar foot wofi mako \
    pipewire wireplumber \
    grim slurp brightnessctl wl-clipboard \
    seatd dbus polkit \
    nerd-fonts

# ---------------------------------------------------------------------------
# Services
# ---------------------------------------------------------------------------
for svc in seatd dbus; do
    if [ ! -e "/var/service/$svc" ]; then
        sudo ln -s "/etc/sv/$svc" /var/service/
        info "Enabled $svc service."
    fi
done

# ---------------------------------------------------------------------------
# User groups
# ---------------------------------------------------------------------------
DESKTOP_USER="$(whoami)"

for grp in _seatd audio video input; do
    if ! groups "$DESKTOP_USER" 2>/dev/null | grep -q "$grp"; then
        sudo usermod -aG "$grp" "$DESKTOP_USER"
        info "Added $DESKTOP_USER to $grp group."
    fi
done

# ---------------------------------------------------------------------------
# PipeWire configuration
# ---------------------------------------------------------------------------
info "Configuring PipeWire..."
sudo mkdir -p /etc/pipewire/pipewire.conf.d

for conf in \
    /usr/share/examples/wireplumber/10-wireplumber.conf \
    /usr/share/examples/pipewire/20-pipewire-pulse.conf; do
    if [ -f "$conf" ] && [ ! -e "/etc/pipewire/pipewire.conf.d/$(basename "$conf")" ]; then
        sudo ln -s "$conf" /etc/pipewire/pipewire.conf.d/
    fi
done

ok "Desktop environment installed."
info "Log out and back in for group changes to take effect."
info "Start Hyprland with: Hyprland"
