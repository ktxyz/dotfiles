# Neovim Configuration Cheatsheet

Leader key: `Space`

## General Keymaps

### Navigation

| Key        | Action                    |
|------------|---------------------------|
| `Ctrl-h/j/k/l` | Navigate between splits |
| `Ctrl-d`   | Half-page down (centered) |
| `Ctrl-u`   | Half-page up (centered)   |
| `n` / `N`  | Next/prev search (centered) |

### Splits

| Key           | Action                |
|---------------|-----------------------|
| `Ctrl-Up`     | Increase height       |
| `Ctrl-Down`   | Decrease height       |
| `Ctrl-Left`   | Decrease width        |
| `Ctrl-Right`  | Increase width        |

### Buffers

| Key          | Action          |
|--------------|-----------------|
| `Shift-h`    | Previous buffer |
| `Shift-l`    | Next buffer     |
| `<leader>bd` | Delete buffer   |

### Editing

| Key          | Mode   | Action                      |
|--------------|--------|-----------------------------|
| `J` / `K`    | Visual | Move selected lines up/down |
| `<leader>p`  | Visual | Paste without yanking       |
| `Esc`        | Normal | Clear search highlight      |

### Diagnostics

| Key          | Action              |
|--------------|---------------------|
| `[d`         | Previous diagnostic |
| `]d`         | Next diagnostic     |
| `<leader>d`  | Float diagnostic    |

## LSP (active when a server attaches)

| Key          | Action            |
|--------------|-------------------|
| `gd`         | Go to definition  |
| `gD`         | Go to declaration |
| `gr`         | References        |
| `gi`         | Implementation    |
| `K`          | Hover docs        |
| `<leader>ca` | Code action       |
| `<leader>cr` | Rename symbol     |
| `<leader>cs` | Signature help    |
| `Ctrl-s`     | Signature help (insert mode) |

Format on save is automatic for languages with LSP formatting support.

### Configured LSP Servers (auto-installed via Mason)

No npm or Javascript required. All servers are standalone binaries or pip-installed.

| Server    | Languages | Install Method | Notes                           |
|-----------|-----------|----------------|---------------------------------|
| `zls`     | Zig       | Binary         |                                 |
| `clangd`  | C, C++    | Binary         | clang-tidy enabled, background index |
| `pylsp`   | Python    | pip            | pycodestyle max line length 100 |

## Telescope (fuzzy finder)

| Key          | Action                      |
|--------------|-----------------------------|
| `<leader>ff` | Find files                  |
| `<leader>fg` | Live grep                   |
| `<leader>fb` | Open buffers                |
| `<leader>fh` | Help tags                   |
| `<leader>fr` | Recent files                |
| `<leader>fs` | Document symbols (LSP)      |
| `<leader>fw` | Workspace symbols (LSP)     |
| `<leader>fd` | All diagnostics             |
| `<leader>/`  | Fuzzy find in current buffer |

Ignored patterns: `node_modules`, `.git/`, `zig-cache`, `zig-out`

## Completion (nvim-cmp)

| Key          | Action                |
|--------------|-----------------------|
| `Ctrl-n`     | Next item             |
| `Ctrl-p`     | Previous item         |
| `Ctrl-y`     | Confirm selection     |
| `Ctrl-e`     | Abort completion      |
| `Ctrl-Space` | Trigger completion    |
| `Ctrl-b/f`   | Scroll docs up/down   |
| `Tab`        | Expand/jump snippet   |
| `Shift-Tab`  | Jump snippet backward |

Source priority: LSP > Snippets > Path > Buffer

## Git (gitsigns)

| Key          | Action           |
|--------------|------------------|
| `]h`         | Next hunk        |
| `[h`         | Previous hunk    |
| `<leader>gs` | Stage hunk       |
| `<leader>gr` | Reset hunk       |
| `<leader>gS` | Stage buffer     |
| `<leader>gu` | Undo stage hunk  |
| `<leader>gp` | Preview hunk     |
| `<leader>gb` | Blame line       |
| `<leader>gd` | Diff this        |

## Treesitter Textobjects

### Selection (works with d, c, y, v)

| Key  | Object           |
|------|------------------|
| `af` | Function (outer) |
| `if` | Function (inner) |
| `ac` | Class (outer)    |
| `ic` | Class (inner)    |
| `aa` | Parameter (outer)|
| `ia` | Parameter (inner)|

### Movement

| Key  | Action                  |
|------|-------------------------|
| `]f` | Next function start     |
| `[f` | Previous function start |
| `]c` | Next class start        |
| `[c` | Previous class start    |

### Incremental Selection

| Key          | Action          |
|--------------|-----------------|
| `Ctrl-Space` | Init / expand   |
| `Backspace`  | Shrink          |

## File Explorer (neo-tree)

| Key          | Action                          |
|--------------|---------------------------------|
| `<leader>e`  | Toggle sidebar tree             |

Follows the current file. Shows dotfiles and gitignored files.

## Oil (buffer-based file browser)

| Key          | Action                          |
|--------------|---------------------------------|
| `<leader>-`  | Open oil                        |

Edits to the oil buffer (rename, delete, create) apply to the filesystem on save.

## Editor Utilities

### mini.surround

| Key        | Action                  |
|------------|-------------------------|
| `sa{motion}{char}` | Add surround   |
| `sd{char}` | Delete surround         |
| `sr{old}{new}` | Replace surround    |

### mini.pairs

Auto-closes `(`, `[`, `{`, `"`, `'`, `` ` `` in insert mode.

## UI

- Theme: Tokyo Night (night variant)
- Statusline: lualine (branch, diff, diagnostics, filename with path, filetype)
- Indent guides: visible vertical lines with scope highlighting

## Options Summary

| Setting        | Value   |
|----------------|---------|
| Tab width      | 4 spaces |
| Line numbers   | Relative |
| Color column   | 100     |
| Clipboard      | System (`unnamedplus`) |
| Undo           | Persistent (`undofile`) |
| Swap files     | Disabled |
| Search         | Case-insensitive (smart-case) |
| Splits         | Open below / right |
| Scroll offset  | 8 lines |

## Autocommands

- Highlight yanked text briefly (200ms)
- Trim trailing whitespace on save
- Restore cursor to last edit position
- Auto-resize splits on terminal resize
