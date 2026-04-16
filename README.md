# dotfiles

Portable, modular dotfiles targeting Void Linux and macOS. GNU Stow manages symlinks;
each directory under `home/` is an independent config package.

## Quick start

On a fresh machine with `curl`:

```sh
curl -fsSL https://raw.githubusercontent.com/ktxyz/dotfiles/master/bootstrap.sh | sh
```

This will install `git` if missing, clone the repo to `~/.dotfiles`, install
packages, set up Python/UV, and link configs into `$HOME`.

On macOS, Homebrew is required before running bootstrap.
The installer also sets up Ghostty + Nerd Font for terminal icons.

## Manual usage

```sh
git clone https://github.com/ktxyz/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Everything at once
./install.sh

# Or pick what you need
./install.sh --packages   # system packages (xbps/brew)
./install.sh --python     # python3 + uv
./install.sh --debug      # gdb + GEF debugger tooling
./install.sh --zls        # build/install ZLS from source
./install.sh --opencode   # install opencode CLI
./install.sh --link       # stow configs into $HOME
./install.sh --configure  # interactive setup (git identity, etc.)

# Shell choice (default is zsh)
./install.sh --shell zsh
./install.sh --shell bash
```

Note: `--zls` defaults to ZLS `master`, which can require a Zig nightly/dev compiler.
Use `ZLS_REF=<tag>` if you want to pin a specific release tag.
On macOS, `./install.sh --packages` installs `zigup` and sets Zig nightly in `~/.local/bin/zig`.
When running `./install.sh --zls`, Zig is pinned to the exact version required by that ZLS ref.

## Structure

```
dotfiles/
├── bootstrap.sh              # curl | sh entry point
├── install.sh                # orchestrator
├── home/                     # stow packages → $HOME
│   ├── bash/
│   │   ├── .bash_profile
│   │   ├── .bashrc
│   │   └── .config/bash/
│   │       ├── aliases.sh
│   │       ├── env.sh
│   │       └── prompt.sh
│   ├── zsh/
│   │   ├── .zprofile
│   │   ├── .zshrc
│   │   └── .config/zsh/
│   │       ├── aliases.zsh
│   │       ├── env.zsh
│   │       └── prompt.zsh
│   ├── ghostty/
│   │   └── .config/ghostty/config
│   └── git/
│       └── .gitconfig
└── scripts/
    ├── lib/
    │   └── utils.sh          # shared helpers
    ├── install/
    │   ├── packages.sh       # system packages (void + macOS)
    │   ├── opencode.sh       # opencode CLI install
    │   ├── python.sh         # python3 + uv
    │   ├── debug.sh          # gdb + gef setup
    │   └── zls.sh            # zls source build/install
    └── configure/
        ├── git.sh            # prompts for name/email
        └── opencode.sh       # prompts for opencode provider setup
```

## Adding a new config

1. Create `home/<name>/` mirroring the file layout relative to `$HOME`.
2. Run `./install.sh --link` (or `cd home && stow <name>`).

## After first install

The installer prompts for your git name and email automatically. Identity is
stored in `~/.config/git/local` (not the repo), so re-running bootstrap or
pulling updates never conflicts. To change values later:

```sh
./install.sh --configure
# or directly:
git config --file ~/.config/git/local user.name "New Name"
```
