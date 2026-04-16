# Zsh Configuration Cheatsheet

## Shell Startup Order

1. Login shell reads `~/.zprofile`
2. Interactive shell reads `~/.zshrc`
3. `~/.zshrc` guards for non-interactive, then sources `~/.config/zsh/*.zsh` in glob order

Files loaded: `aliases.zsh` -> `env.zsh` -> `prompt.zsh` (alphabetical)

## Environment (env.zsh)

| Variable            | Value                         |
|---------------------|-------------------------------|
| `XDG_CONFIG_HOME`   | `~/.config`                   |
| `XDG_DATA_HOME`     | `~/.local/share`              |
| `XDG_STATE_HOME`    | `~/.local/state`              |
| `XDG_CACHE_HOME`    | `~/.cache`                    |
| `EDITOR` / `VISUAL` | `nvim`                        |
| `HISTFILE`          | `~/.local/state/zsh/history`  |
| `HISTSIZE`          | 10000                         |
| `SAVEHIST`          | 20000                         |
| `PATH`              | `~/.local/bin` prepended      |

History options:
- `APPEND_HISTORY`
- `HIST_IGNORE_ALL_DUPS`
- `HIST_IGNORE_SPACE`

## Aliases (aliases.zsh)

| Alias  | Expands To                               |
|--------|------------------------------------------|
| `ls`   | `ls --color=auto` or `gls --color=auto` (macOS fallback) |
| `la`   | `ls -A`                                  |
| `ll`   | `ls -lAh` or `gls -lAh`                  |
| `grep` | `grep --color=auto` or `ggrep --color=auto` (when available) |
| `..`   | `cd ..`                                  |
| `...`  | `cd ../..`                               |
| `v`    | `nvim`                                   |
| `gs`   | `git status`                             |
| `gd`   | `git diff`                               |
| `gl`   | `git log --oneline --graph --decorate -20` |

## Prompt (prompt.zsh)

Format: `user@host:path (branch)#`

- Green: `user@host`
- Blue: working directory
- Yellow: git branch (only shown inside a repo)
- Prompt character: `%#` (`#` as root, `%` as user)
