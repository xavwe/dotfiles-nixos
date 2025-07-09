return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble" },
  event = "VeryLazy",
  opts = {},
  dependencies = { { "nvim-lua/plenary.nvim", lazy = true } },
  -- stylua: ignore
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
    { "<leader>t", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
  },
}
