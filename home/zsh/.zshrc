# ~/.zshrc -- interactive shell configuration

# If not running interactively, bail early.
case $- in
    *i*) ;;
      *) return ;;
esac

# Source modular config fragments in order.
for f in "$HOME/.config/zsh/"*.zsh; do
    [ -r "$f" ] && . "$f"
done
unset f
