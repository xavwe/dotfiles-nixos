vim.g.mapleader = " "

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Define filetype-specific keybindings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",  -- Specify the filetype
  callback = function()
    require("which-key").add({
      { "<leader>x", "<CMD>.lua<CR>", buffer = 0, mode = "n", desc = "Execute line" },
      { "<leader>x", "<CMD>lua<CR>", buffer = 0, mode = "v", desc = "Execute line" },
    })
  end,
})
