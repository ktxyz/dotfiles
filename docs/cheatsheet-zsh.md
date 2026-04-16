# Zsh Configuration Cheatsheet

## Shell Startup Order

1. Login shell reads `~/.zprofile`
2. Interactive shell reads `~/.zshrc`
3. `~/.zshrc` guards for non-interactive, then sources `~/.config/zsh/*.zsh` in glob order

Files loaded: `aliases.zsh` -> `env.zsh` -> `plugins.zsh` -> `prompt.zsh` (alphabetical)

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
| `lt`   | `ls -lahtr`                              |
| `ll`   | `ls -lAh` or `gls -lAh`                  |
| `grep` | `grep --color=auto` or `ggrep --color=auto` (when available) |
| `..`   | `cd ..`                                  |
| `...`  | `cd ../..`                               |
| `v`    | `nvim`                                   |
| `c`    | `clear`                                  |
| `mkdir`| `mkdir -p`                               |
| `rm`   | `rm -i`                                  |
| `cp`   | `cp -i`                                  |
| `mv`   | `mv -i`                                  |
| `ga`   | `git add`                                |
| `gs`   | `git status`                             |
| `gd`   | `git diff`                               |
| `gdc`  | `git diff --cached`                      |
| `gc`   | `git commit`                             |
| `gco`  | `git checkout`                           |
| `glg`  | `git log --graph --decorate --oneline --all` |
| `gl`   | `git log --oneline --graph --decorate -20` |

## Plugins (plugins.zsh)

Auto-bootstrapped under `~/.local/share/zsh/plugins`:
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`
- `zsh-history-substring-search`
- `fzf-tab`

Completion behavior:
- case-insensitive completion matching
- menu selection enabled

## Prompt (prompt.zsh)

Prompt behavior:
- uses Starship when available (`starship init zsh`)
- falls back to built-in `user@host:path (branch)#` prompt if Starship is missing

- Fallback colors: green host/user, blue path, yellow branch
