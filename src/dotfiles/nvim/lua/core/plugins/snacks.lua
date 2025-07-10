return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
  },
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
      -- {
      --   "<leader>b",
      --   function()
      --     Snacks.picker.buffers()
      --   end,
      --   desc = "Buffers",
      -- },
    },
  },
}
