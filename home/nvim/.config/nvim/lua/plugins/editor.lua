return {
  -- Auto-pairs
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Surround operations (sa, sd, sr)
  {
    "echasnovski/mini.surround",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- File browser as a buffer
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>Oil<cr>", desc = "File browser" },
      { "-", "<cmd>Oil<cr>", desc = "File browser" },
    },
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
  },
}
