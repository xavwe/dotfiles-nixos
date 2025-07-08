return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      picker = {
        enabled = true,
      },
      explorer = {
        enabled = true,
        replace_netrw = false, --no difference
      },
      bigfile = {
        enabled = true,
        notify = true,
      },
    },
    keys = {
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      { "<leader>f", function() Snacks.picker.files() end, desc = "Find Files" },
    },
  },
}
