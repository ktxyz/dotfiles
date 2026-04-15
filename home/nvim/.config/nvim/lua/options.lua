local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.colorcolumn = "100"

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Undo / swap
opt.undofile = true
opt.swapfile = false

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Misc
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.wrap = false
opt.showmode = false
