return {
  {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require("alpha")
      local theme = require("alpha.themes.startify")

      theme.section.header.val = {
        "",
        "  Welcome to Neovim!",
        "",
      }

      if not theme.section.buttons then
        theme.section.buttons = {}
      end
      theme.section.buttons.val = {
        theme.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        theme.button("f", "  Find file", ":SnacksPickerFiles <CR>"),
        theme.button("g", "  Find text", ":SnacksPickerGrep <CR>"),
        theme.button("l", "  Last session", ":lua require('persistence').load() <CR>"),
        theme.button("q", "  Quit", ":qa <CR>"),
      }

      alpha.setup(theme.config)

      vim.cmd("autocmd User AlphaReady echo 'Alpha is ready!'")

      vim.cmd("autocmd VimEnter * Alpha")
    end,
  },
}
