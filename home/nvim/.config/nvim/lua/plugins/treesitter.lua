local parsers = {
  "c", "cpp", "zig",
  "python",
  "lua", "vim", "vimdoc", "query",
  "bash", "json", "yaml", "toml", "markdown", "markdown_inline",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = parsers,
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      local map = vim.keymap.set

      -- Textobject selection
      local objects = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      }
      for key, query in pairs(objects) do
        map({ "x", "o" }, key, function()
          select.select_textobject(query, "textobjects")
        end)
      end

      -- Movement
      local next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
      }
      local prev_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
      }
      for key, query in pairs(next_start) do
        map({ "n", "x", "o" }, key, function()
          move.goto_next_start(query, "textobjects")
        end)
      end
      for key, query in pairs(prev_start) do
        map({ "n", "x", "o" }, key, function()
          move.goto_previous_start(query, "textobjects")
        end)
      end
    end,
  },
}
