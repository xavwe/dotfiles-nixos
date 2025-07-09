return {
  {
    "folke/snacks.nvim",
    opts = {
      indent = { enabled = true },
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
