return {
  {
    "folke/snacks.nvim",
    opts = {
      indent = { enabled = true },
      quickfile = { enabled = true },
      terminal = {
        win = {},
        keys = {
          t = {
            ["<esc>"] = "normal",
          },
        },
      },
      dashboard = { enabled = false },
      picker = {
        enabled = true,
        sources = {
          grep = {
            hidden = true,
          },
          files = {
            hidden = true,
          },
        },
      },
    },
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    keys = {
      {
        "<leader>q",
        function()
          Snacks.terminal.toggle()
        end,
        desc = "Terminal",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader><leader>",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
    },
  },
}
