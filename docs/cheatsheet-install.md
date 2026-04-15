# Installation & Structure Cheatsheet

## Quick Bootstrap

```sh
curl -fsSL https://raw.githubusercontent.com/ktxyz/dotfiles/master/bootstrap.sh | sh
```

This installs git (if missing), clones to `~/.dotfiles`, and runs `install.sh`.

## install.sh Flags

| Flag          | What It Does                              |
|---------------|-------------------------------------------|
| (no flags)    | Run everything                            |
| `--packages`  | Install system packages via xbps          |
| `--python`    | Install python3 + UV package manager      |
| `--link`      | Stow all configs from `home/` into `$HOME`|
| `--configure` | Run interactive setup scripts (git identity, etc.) |

## Stow Packages

Each directory under `home/` is a GNU Stow package. The directory structure
inside mirrors `$HOME`.

| Package | What It Links                                    |
|---------|--------------------------------------------------|
| `bash`  | `.bashrc`, `.bash_profile`, `.bash_logout`, `.inputrc`, `.config/bash/` |
| `git`   | `.gitconfig`                                     |
| `nvim`  | `.config/nvim/` (full neovim config)             |

### Adding a New Package

1. Create `home/<name>/` with files mirroring their location under `$HOME`
2. Run `./install.sh --link`

### Stow Conflict Resolution

The installer uses `stow --adopt` which moves existing files into the stow
package, then `git checkout -- home/` restores the repo versions. This means
the repo always wins over pre-existing files.

## System Packages (Void Linux)

Installed via `xbps-install`:

- **Base**: curl, wget, git, stow, make
- **Search/nav**: ripgrep, fd, bat, fzf
- **Dev**: neovim, tmux
- **Toolchain**: base-devel (includes gcc, make)

## Python Setup

- `python3` installed via xbps
- [UV](https://docs.astral.sh/uv/) installed via official script
- Binaries land in `~/.local/bin` (already in PATH via `env.sh`)

## Configure Scripts

Scripts in `scripts/configure/` run interactively after linking.
Currently: `git.sh` prompts for name/email (skips if already set).

Drop new `*.sh` files into `scripts/configure/` and they run automatically.

## Directory Layout

```
~/.dotfiles/
├── bootstrap.sh
├── install.sh
├── docs/                     # cheatsheets and docs
├── home/                     # stow packages
│   ├── bash/
│   ├── git/
│   └── nvim/
└── scripts/
    ├── lib/utils.sh
    ├── install/
    │   ├── packages.sh
    │   └── python.sh
    └── configure/
        └── git.sh
```

## XDG Directories

All configs respect XDG. Bash history goes to `~/.local/state/bash/history`
instead of `~/.bash_history`.

| Variable           | Path              |
|--------------------|-------------------|
| `XDG_CONFIG_HOME`  | `~/.config`       |
| `XDG_DATA_HOME`    | `~/.local/share`  |
| `XDG_STATE_HOME`   | `~/.local/state`  |
| `XDG_CACHE_HOME`   | `~/.cache`        |
