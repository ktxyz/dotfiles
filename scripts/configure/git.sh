#!/bin/sh
# Configure git user identity in a local file that .gitconfig includes.
# This keeps the repo-tracked .gitconfig clean.
set -e

SCRIPTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$SCRIPTS_DIR/lib/utils.sh"

need_cmd git

GIT_LOCAL="$HOME/.config/git/local"
mkdir -p "$(dirname "$GIT_LOCAL")"

current_name="$(git config --file "$GIT_LOCAL" user.name 2>/dev/null || true)"
current_email="$(git config --file "$GIT_LOCAL" user.email 2>/dev/null || true)"

if [ -n "$current_name" ] && [ -n "$current_email" ]; then
    ok "Git identity already configured: $current_name <$current_email>"
    exit 0
fi

info "Setting up git identity..."

if [ -n "$current_name" ]; then
    name="$current_name"
else
    printf 'Git name: '
    read -r name </dev/tty
    [ -z "$name" ] && die "Name cannot be empty."
fi

if [ -n "$current_email" ]; then
    email="$current_email"
else
    printf 'Git email: '
    read -r email </dev/tty
    [ -z "$email" ] && die "Email cannot be empty."
fi

git config --file "$GIT_LOCAL" user.name "$name"
git config --file "$GIT_LOCAL" user.email "$email"

ok "Git identity set: $name <$email>"
