return {
  {
    "folke/snacks.nvim",
    opts = {
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
      explorer = {
        enabled = true,
        replace_netrw = true,
      },
      bigfile = {
        enabled = true,
        notify = true,
      },
    },
    keys = {
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    },
  },
}
