# dotfiles

Portable, modular dotfiles targeting Void Linux. GNU Stow manages symlinks;
each directory under `home/` is an independent config package.

## Quick start

On a fresh machine with `curl`:

```sh
curl -fsSL https://raw.githubusercontent.com/ktxyz/dotfiles/master/bootstrap.sh | sh
```

This will install `git` if missing, clone the repo to `~/.dotfiles`, install
packages, set up Python/UV, and link all configs into `$HOME`.

## Manual usage

```sh
git clone https://github.com/ktxyz/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Everything at once
./install.sh

# Or pick what you need
./install.sh --packages   # system packages (xbps)
./install.sh --python     # python3 + uv
./install.sh --link       # stow configs into $HOME
./install.sh --configure  # interactive setup (git identity, etc.)
```

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
│   └── git/
│       └── .gitconfig
└── scripts/
    ├── lib/
    │   └── utils.sh          # shared helpers
    ├── install/
    │   ├── packages.sh       # void linux packages
    │   └── python.sh         # python3 + uv
    └── configure/
        └── git.sh            # prompts for name/email
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
