# Installation & Structure Cheatsheet

## Quick Bootstrap

```sh
curl -fsSL https://raw.githubusercontent.com/ktxyz/dotfiles/master/bootstrap.sh | sh
```

This installs git (if missing), clones to `~/.dotfiles`, and runs `install.sh`.
On macOS, install Homebrew first (`https://brew.sh`).

## install.sh Flags

| Flag          | What It Does                              |
|---------------|-------------------------------------------|
| (no flags)    | Run everything                            |
| `--packages`  | Install system packages via xbps or brew  |
| `--drivers`   | Detect GPU + install drivers, WiFi/BT firmware |
| `--desktop`   | Install Hyprland desktop stack + audio    |
| `--python`    | Install python3 + UV package manager      |
| `--debug`     | Install debugger tooling (gdb + GEF)      |
| `--zls`       | Build and install ZLS from source         |
| `--link`      | Stow all configs from `home/` into `$HOME`|
| `--configure` | Run interactive setup scripts (git identity, etc.) |
| `--shell zsh\|bash` | Select shell package + login shell target (default: zsh) |

`--drivers` and `--desktop` auto-skip on macOS.

If shell is not explicitly set, installer prompts for `zsh` or `bash` and defaults to `zsh`.

## Stow Packages

Each directory under `home/` is a GNU Stow package. The directory structure
inside mirrors `$HOME`.

| Package | What It Links                                    |
|---------|--------------------------------------------------|
| `bash`   | `.bashrc`, `.bash_profile`, `.bash_logout`, `.inputrc`, `.config/bash/` |
| `zsh`    | `.zshrc`, `.zprofile`, `.config/zsh/`            |
| `git`    | `.gitconfig`                                     |
| `nvim`   | `.config/nvim/` (full neovim config)             |
| `tmux`   | `.config/tmux/tmux.conf` (TPM auto-bootstraps)   |
| `ghostty`| `.config/ghostty/config` (macOS terminal config) |
| `hypr`   | `.config/hypr/` (Hyprland, hypridle, hyprlock)   |
| `waybar` | `.config/waybar/` (status bar config + CSS)      |
| `foot`   | `.config/foot/foot.ini` (terminal + Tokyo Night) |
| `mako`   | `.config/mako/config` (notifications)            |
| `wofi`   | `.config/wofi/` (app launcher config + CSS)      |

Shell packages are mutually exclusive per install run:
- default links `zsh`
- `--shell bash` links `bash`

On macOS, Linux desktop packages are skipped during linking by default:
`hypr`, `waybar`, `mako`, `wofi`, `foot`.

On non-macOS systems, `ghostty` package is skipped during linking.

### Adding a New Package

1. Create `home/<name>/` with files mirroring their location under `$HOME`
2. Run `./install.sh --link`

### Stow Conflict Resolution

The installer uses `stow --adopt` which moves existing files into the stow
package, then `git checkout -- home/` restores the repo versions. This means
the repo always wins over pre-existing files.

## System Packages

Void Linux (`xbps-install`):
- **Base**: curl, wget, git, stow, make
- **Search/nav**: ripgrep, fd, bat, fzf
- **Dev**: neovim, tmux
- **Prompt**: starship
- **Toolchain**: base-devel (includes gcc, make)

macOS (`brew`):
- **Base**: curl, wget, git, stow, make
- **Search/nav**: ripgrep, fd, bat, fzf
- **Dev**: neovim, tmux
- **Zig manager**: zigup
- **Prompt**: starship
- **Terminal**: ghostty
- **GNU utils support**: coreutils (for color alias parity)
- **Font**: font-jetbrains-mono-nerd-font (icons/glyphs for Neovim UI)

## Icons and Nerd Fonts

If icons are missing in Neovim, the shell font is usually the issue.

- Run `./install.sh --packages` to install Nerd Font packages.
- In your terminal app profile, set the font to **JetBrainsMono Nerd Font**.
- Restart terminal + Neovim after changing the font.

For Ghostty, this is automated in stowed config under `.config/ghostty/config`.

## Python Setup

- `python3` installed via xbps (Void) or brew (macOS)
- [UV](https://docs.astral.sh/uv/) installed via official script
- Binaries land in `~/.local/bin` (already in PATH via `env.sh`)

## Debugger Tools

`./install.sh --debug` installs:
- `gdb`
- [GEF](https://github.com/hugsy/gef) at `~/.config/gdb/gef.py`

On macOS, `gdb` also requires code-signing before process attach works.
After install, run your signing flow and then verify with `gdb --version`.

## Zig / ZLS

`./install.sh --zls` builds ZLS directly from source (default ref: `master`) and installs to:
- `~/.local/bin/zls`

Requirements:
- `zig`
- `git`

On macOS, `./install.sh --packages` installs `zigup` and sets Zig nightly (`master`) in `~/.local/bin/zig`.
`./install.sh --zls` reads ZLS's required Zig version from `build.zig.zon` and auto-switches Zig to that exact version.

Optional ref override:
```sh
ZLS_REF=<tag-or-branch> ./install.sh --zls
```

Compatibility note:
- ZLS `master` may require a specific Zig **dev/nightly** build, not just "latest nightly".
- Installer auto-pins to ZLS required version on macOS via `zigup`.

Neovim LSP is configured to prefer `~/.local/bin/zls` over Mason-managed ZLS.

## Configure Scripts

Scripts in `scripts/configure/` run interactively after linking.
Currently: `git.sh` prompts for name/email and writes to `~/.config/git/local`
(not the repo-tracked `.gitconfig`). Skips if already set.

Drop new `*.sh` files into `scripts/configure/` and they run automatically.

## Git Identity

The stowed `.gitconfig` includes `~/.config/git/local` via `[include]`.
Machine-specific settings (name, email, signing key) go in that local file
so the repo stays clean and `git pull` never conflicts.

To change your identity:

```sh
git config --file ~/.config/git/local user.name "New Name"
git config --file ~/.config/git/local user.email "new@email.com"
```

## Directory Layout

```
~/.dotfiles/
├── bootstrap.sh
├── install.sh
├── docs/                     # cheatsheets and docs
├── home/                     # stow packages
│   ├── bash/
│   ├── zsh/
│   ├── git/
│   ├── nvim/
│   ├── tmux/
│   ├── ghostty/
│   ├── hypr/
│   ├── waybar/
│   ├── foot/
│   ├── mako/
│   └── wofi/
└── scripts/
    ├── lib/utils.sh
    ├── install/
    │   ├── packages.sh
    │   ├── drivers.sh
    │   ├── desktop.sh
    │   ├── python.sh
    │   ├── debug.sh
    │   └── zls.sh
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
