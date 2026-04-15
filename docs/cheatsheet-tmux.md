# Tmux Cheatsheet

Prefix key: `Ctrl-Space` (shown as `<P>` below)

## Core Concepts

- **Session** -- a collection of windows, persists in background when detached
- **Window** -- a tab within a session, shown in the status bar
- **Pane** -- a split within a window

## Sessions

| Command / Key     | Action                           |
|-------------------|----------------------------------|
| `tmux`            | Start new session                |
| `tmux new -s dev` | Start named session              |
| `tmux ls`         | List sessions                    |
| `tmux a -t dev`   | Attach to named session          |
| `tmux a`          | Attach to last session           |
| `<P> d`           | Detach from session              |
| `<P> $`           | Rename session                   |
| `<P> s`           | (overridden -- see Panes below)  |
| `tmux kill-session -t dev` | Kill a session          |

## Windows

| Key       | Action                       |
|-----------|------------------------------|
| `<P> c`   | New window (keeps cwd)       |
| `<P> n`   | Next window                  |
| `<P> p`   | Previous window              |
| `<P> 1-9` | Switch to window by number   |
| `<P> ,`   | Rename window                |
| `<P> &`   | Kill window                  |

## Panes

### Creating

| Key     | Action                              |
|---------|-------------------------------------|
| `<P> v` | Split vertically (side by side)     |
| `<P> s` | Split horizontally (top and bottom) |

### Navigating (vim-style)

| Key     | Action     |
|---------|------------|
| `<P> h` | Move left  |
| `<P> j` | Move down  |
| `<P> k` | Move up    |
| `<P> l` | Move right |

### Resizing (hold prefix, repeatable)

| Key     | Action          |
|---------|-----------------|
| `<P> H` | Resize left 5   |
| `<P> J` | Resize down 5   |
| `<P> K` | Resize up 5     |
| `<P> L` | Resize right 5  |

### Other Pane Operations

| Key     | Action                    |
|---------|---------------------------|
| `<P> x` | Kill pane (with confirm)  |
| `<P> z` | Toggle pane zoom (fullscreen) |
| `<P> q` | Show pane numbers         |
| `<P> !` | Convert pane to window    |

## Copy Mode

Enter copy mode with `<P> Enter` (or scroll up with mouse).

| Key (in copy mode) | Action              |
|---------------------|---------------------|
| `v`                 | Begin selection     |
| `y`                 | Copy and exit       |
| `q`                 | Exit copy mode      |
| `/`                 | Search forward      |
| `?`                 | Search backward     |
| `n` / `N`           | Next / prev match   |
| `h/j/k/l`           | Navigate (vi keys)  |
| `Ctrl-u` / `Ctrl-d` | Page up / down     |

## Session Persistence (resurrect + continuum)

| Key              | Action                        |
|------------------|-------------------------------|
| `<P> Ctrl-s`     | Save session                  |
| `<P> Ctrl-r`     | Restore session               |

Continuum auto-saves every 15 minutes and auto-restores on tmux start.
Sessions persist across reboots.

## Plugin Management (TPM)

| Key          | Action                |
|--------------|-----------------------|
| `<P> I`      | Install new plugins   |
| `<P> U`      | Update plugins        |
| `<P> alt-u`  | Remove unused plugins |

TPM auto-bootstraps on first tmux launch (clones itself from GitHub).

## Config

| Key     | Action        |
|---------|---------------|
| `<P> r` | Reload config |

Config lives at `~/.config/tmux/tmux.conf` (XDG-compliant).

## Quick Workflow Example

```sh
# Start a dev session
tmux new -s dev

# Split into editor + terminal
# <P> v        (side by side panes)
# <P> s        (split the right pane horizontally)

# Navigate between panes
# <P> h/j/k/l

# Detach and come back later
# <P> d
# tmux a -t dev

# Session survives reboots via resurrect/continuum
```
