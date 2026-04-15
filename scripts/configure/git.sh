#!/bin/sh
# Configure git user identity (name + email).
# Skips if already set; safe to re-run.
set -e

SCRIPTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$SCRIPTS_DIR/lib/utils.sh"

need_cmd git

current_name="$(git config --global user.name 2>/dev/null || true)"
current_email="$(git config --global user.email 2>/dev/null || true)"

if [ -n "$current_name" ] && [ -n "$current_email" ]; then
    ok "Git identity already configured: $current_name <$current_email>"
    exit 0
fi

info "Setting up git identity..."

if [ -n "$current_name" ]; then
    name="$current_name"
else
    printf 'Git name: '
    read -r name
    [ -z "$name" ] && die "Name cannot be empty."
fi

if [ -n "$current_email" ]; then
    email="$current_email"
else
    printf 'Git email: '
    read -r email
    [ -z "$email" ] && die "Email cannot be empty."
fi

git config --global user.name "$name"
git config --global user.email "$email"

ok "Git identity set: $name <$email>"
