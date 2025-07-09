return {
  {
    "stevearc/oil.nvim",
    ---@module "oil"
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
    },
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    keys = {
      {
        "<leader>e",
        "<cmd>Oil<CR>",
        desc = "Explorer",
      },
    },
  },
}
