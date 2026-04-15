#!/bin/sh
# Detect and install GPU + WiFi + Bluetooth drivers.
set -e

SCRIPTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$SCRIPTS_DIR/lib/utils.sh"

OS="$(detect_os)"

if [ "$OS" = "darwin" ]; then
    info "macOS detected, skipping driver install."
    exit 0
fi

if [ "$OS" != "void" ]; then
    die "drivers.sh only supports Void Linux (detected: $OS)"
fi

need_root

# ---------------------------------------------------------------------------
# GPU detection
# ---------------------------------------------------------------------------
detect_gpu() {
    if [ -d /sys/class/drm ]; then
        for card in /sys/class/drm/card*/device/vendor; do
            [ -f "$card" ] || continue
            vendor="$(cat "$card")"
            case "$vendor" in
                0x8086) printf "intel"; return ;;
                0x1002) printf "amd";   return ;;
                0x10de) printf "nvidia"; return ;;
            esac
        done
    fi

    if has_cmd lspci; then
        lspci_out="$(lspci 2>/dev/null)"
        case "$lspci_out" in
            *Intel*VGA*|*Intel*Display*) printf "intel"; return ;;
            *AMD*VGA*|*ATI*VGA*)        printf "amd";   return ;;
            *NVIDIA*VGA*)               printf "nvidia"; return ;;
        esac
    fi

    printf "unknown"
}

GPU="$(detect_gpu)"
info "Detected GPU: $GPU"

case "$GPU" in
    intel)
        info "Installing Intel GPU drivers..."
        xbps-install -y mesa-dri mesa-vulkan-intel vulkan-loader \
                        intel-video-accel linux-firmware-intel
        ;;
    amd)
        info "Installing AMD GPU drivers..."
        xbps-install -y mesa-dri mesa-vulkan-radeon vulkan-loader \
                        mesa-vaapi linux-firmware-amd
        ;;
    nvidia)
        warn "NVIDIA detected. Hyprland has limited NVIDIA support."
        warn "Install proprietary drivers manually if needed."
        ;;
    *)
        warn "Could not detect GPU vendor. Install graphics drivers manually."
        ;;
esac

# ---------------------------------------------------------------------------
# WiFi firmware (Intel AX211 and similar)
# ---------------------------------------------------------------------------
if ! xbps-query linux-firmware-intel >/dev/null 2>&1; then
    info "Installing Intel WiFi firmware..."
    xbps-install -y linux-firmware-intel
else
    ok "Intel WiFi firmware already installed."
fi

# ---------------------------------------------------------------------------
# Bluetooth
# ---------------------------------------------------------------------------
info "Installing Bluetooth stack..."
xbps-install -y bluez libspa-bluetooth

if [ ! -e /var/service/bluetoothd ]; then
    ln -s /etc/sv/bluetoothd /var/service/
    info "Enabled bluetoothd service."
fi

# Add calling user to bluetooth group (SUDO_USER if run via sudo)
BT_USER="${SUDO_USER:-$(whoami)}"
if ! groups "$BT_USER" 2>/dev/null | grep -q bluetooth; then
    usermod -aG bluetooth "$BT_USER"
    info "Added $BT_USER to bluetooth group."
fi

ok "Drivers and firmware installed."
