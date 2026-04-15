# Dotfiles — AI Agent Guidelines

Instructions for AI agents (Cursor, Copilot, Codex, etc.) working on this repository.

## Repository Purpose

Personal dotfiles for Void Linux (primary), with future Mac/zsh support planned.
GNU Stow manages symlinks from `home/<package>/` into `$HOME`.

## Architecture Rules

### Directory Structure

- `home/<package>/` — stow packages, directory tree mirrors `$HOME`
- `scripts/lib/` — shared shell utilities (sourced, never executed directly)
- `scripts/install/` — idempotent install scripts (one per concern)
- `scripts/configure/` — interactive setup scripts (run after stow)
- `docs/` — cheatsheets and reference documentation

### Conventions

1. **All shell scripts must use `#!/bin/sh`** — POSIX sh, not bash. No bashisms
   in install/configure/bootstrap scripts. The bash config files under
   `home/bash/` are the exception since they only run in bash.

2. **Scripts must be idempotent** — running them twice produces the same result.
   Check before acting (`has_cmd`, `[ -f ... ]`, etc.).

3. **Use `scripts/lib/utils.sh`** — source it for logging (`info`, `ok`, `warn`,
   `err`, `die`), OS detection (`detect_os`), and command checks (`has_cmd`,
   `need_cmd`).

4. **Interactive input must read from `/dev/tty`** — scripts may be called from
   subshells where stdin is not a terminal.

5. **Stow packages are atomic** — each directory under `home/` is one stow
   package. Don't create cross-dependencies between packages.

6. **No secrets in the repo** — no API keys, tokens, passwords, or private SSH
   keys. Use `scripts/configure/` for machine-specific values.

7. **XDG compliance** — respect XDG base directories. Don't put state or cache
   files directly in `$HOME`. Use `$XDG_STATE_HOME`, `$XDG_CACHE_HOME`, etc.

### Neovim Config

- Plugin manager: **lazy.nvim** (bootstraps itself in `init.lua`)
- Structure: `init.lua` loads `lua/options.lua`, `lua/keymaps.lua`,
  `lua/autocmds.lua`, then `lazy.setup("plugins")` auto-loads all files in
  `lua/plugins/`
- Each file in `lua/plugins/` returns a lazy.nvim spec table (or list of tables)
- LSP servers are managed by **Mason** (`ensure_installed` in `plugins/lsp.lua`)
- **No npm or Javascript dependencies** — all LSP servers must be standalone binaries
  or pip-installed. Never add a server that requires npm or Javascript.
- Leader key is `Space`

#### Keymap Namespaces

| Prefix       | Domain       |
|--------------|--------------|
| `<leader>f`  | Telescope / find |
| `<leader>g`  | Git          |
| `<leader>c`  | Code / LSP   |
| `<leader>b`  | Buffers      |
| `<leader>d`  | Diagnostics  |
| `<leader>e`  | File browser |
| `gd/gr/gi/K` | LSP nav (standard) |
| `]` / `[`    | Next/prev (hunks, diagnostics, functions, classes) |

#### Adding a Plugin

1. Create a new file in `lua/plugins/` returning a spec table
2. lazy.nvim auto-discovers it — no imports to update
3. Prefer `opts = {}` over `config = function()` when possible
4. Use lazy-loading (`event`, `cmd`, `keys`, `ft`) to keep startup fast

#### Adding an LSP Server

1. **Verify the server does NOT require npm or Javascript** — only standalone binaries
   or pip-installable servers are allowed
2. Add the server name to `ensure_installed` in `plugins/lsp.lua`
3. Add a config entry in the `servers` table in the same file
4. Mason handles the binary installation

### Bash Config

- `~/.bashrc` sources all `~/.config/bash/*.sh` files in glob order
- Add new config fragments as separate `.sh` files in `home/bash/.config/bash/`
- Filename determines load order (alphabetical): `aliases.sh` < `env.sh` < `prompt.sh`

### Tmux Config

- Single file: `home/tmux/.config/tmux/tmux.conf` (XDG path, no `~/.tmux.conf`)
- Prefix: `Ctrl-Space`
- Plugins managed by TPM (auto-bootstraps on first launch)
- Vim-style pane navigation (`h/j/k/l`), splits with `v`/`s`
- Session persistence via tmux-resurrect + tmux-continuum
- Theme: tokyonight (matches nvim)

## Documentation Requirements

**Cheatsheets must stay in sync with the actual configuration.**

When making changes:

- If you add/remove/change a nvim keybind, update `docs/cheatsheet-nvim.md`
- If you add/remove/change a bash alias or env var, update `docs/cheatsheet-bash.md`
- If you add/remove/change a tmux keybind, update `docs/cheatsheet-tmux.md`
- If you change the install flow or add a stow package, update `docs/cheatsheet-install.md`
- If you add a new stow package, update the package table in `docs/cheatsheet-install.md`

## Common Tasks Reference

| Task | How |
|------|-----|
| Add a system package | Add to the list in `scripts/install/packages.sh` |
| Add a stow package | Create `home/<name>/`, run `./install.sh --link` |
| Add a configure step | Create `scripts/configure/<name>.sh` |
| Add a nvim plugin | Create `lua/plugins/<name>.lua` returning a spec |
| Add an LSP server | Add to `ensure_installed` + `servers` in `plugins/lsp.lua` |
| Add a bash alias | Add to `home/bash/.config/bash/aliases.sh` |
| Add a PATH entry | Add to `home/bash/.config/bash/env.sh` (use dedup guard) |
| Add a tmux keybind | Add to `home/tmux/.config/tmux/tmux.conf` |
| Add a tmux plugin | Add `set -g @plugin '...'` in tmux.conf, then `<prefix> I` to install |
