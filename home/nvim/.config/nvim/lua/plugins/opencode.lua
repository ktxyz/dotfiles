return {
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    keys = {
      {
        "<leader>oa",
        function()
          require("opencode").ask("@diagnostics @this: ", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "Opencode ask",
      },
      {
        "<leader>ox",
        function()
          require("opencode").select()
        end,
        mode = { "n", "x" },
        desc = "Opencode actions",
      },
      {
        "<leader>ot",
        function()
          require("opencode").toggle()
        end,
        mode = { "n", "t" },
        desc = "Opencode toggle",
      },
      {
        "<leader>or",
        function()
          require("opencode").prompt("review")
        end,
        mode = { "n", "x" },
        desc = "Opencode review",
      },
      {
        "<leader>of",
        function()
          require("opencode").prompt("fix")
        end,
        mode = { "n", "x" },
        desc = "Opencode fix diagnostics",
      },
      {
        "<leader>oT",
        function()
          require("opencode").prompt("test")
        end,
        mode = { "n", "x" },
        desc = "Opencode add tests",
      },
      {
        "<leader>oc",
        function()
          require("opencode").command("session.compact")
        end,
        mode = "n",
        desc = "Opencode compact session",
      },
    },
    config = function()
      vim.o.autoread = true

      ---@type opencode.Opts
      vim.g.opencode_opts = {
        events = {
          reload = true,
        },
        lsp = {
          enabled = false,
        },
      }
    end,
  },
}
