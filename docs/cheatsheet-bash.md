# Bash Configuration Cheatsheet

## Shell Startup Order

1. Login shell runs `~/.bash_profile` which sources `~/.bashrc`
2. `~/.bashrc` guards for non-interactive, then sources `~/.config/bash/*.sh` in glob order

Files loaded: `aliases.sh` -> `env.sh` -> `prompt.sh` (alphabetical)

## Environment (env.sh)

| Variable            | Value                          |
|---------------------|--------------------------------|
| `XDG_CONFIG_HOME`   | `~/.config`                    |
| `XDG_DATA_HOME`     | `~/.local/share`               |
| `XDG_STATE_HOME`    | `~/.local/state`               |
| `XDG_CACHE_HOME`    | `~/.cache`                     |
| `EDITOR` / `VISUAL` | `nvim`                         |
| `HISTFILE`          | `~/.local/state/bash/history`  |
| `HISTSIZE`          | 10000                          |
| `HISTFILESIZE`      | 20000                          |
| `HISTCONTROL`       | `ignoreboth:erasedups`         |
| `PATH`              | `~/.local/bin` prepended       |

## Aliases (aliases.sh)

| Alias  | Expands To                               |
|--------|------------------------------------------|
| `ls`   | `ls --color=auto`                        |
| `la`   | `ls -A`                                  |
| `ll`   | `ls -lAh`                                |
| `grep` | `grep --color=auto`                      |
| `..`   | `cd ..`                                  |
| `...`  | `cd ../..`                               |
| `v`    | `nvim`                                   |
| `gs`   | `git status`                             |
| `gd`   | `git diff`                               |
| `gl`   | `git log --oneline --graph --decorate -20` |

## Prompt (prompt.sh)

Format: `user@host:path (branch)$`

- Green bold: `user@host`
- Blue bold: working directory
- Yellow: git branch (only shown inside a repo)

## Readline (.inputrc)

- Case-insensitive tab completion
- Show all matches immediately on ambiguous completion
- Hyphens and underscores treated as equivalent
- Colored file stats during completion (like `ls`)
- No bell
