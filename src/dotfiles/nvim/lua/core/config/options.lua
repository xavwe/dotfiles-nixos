--keymaps
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- clipboard
vim.opt.clipboard = "unnamedplus"
vim.opt.hlsearch = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- source: https://vi.stackexchange.com/questions/31811/neovim-lua-config-how-to-append-to-listchars
vim.opt.listchars = { space = "•", tab = ">~", eol = "↵" }
vim.opt.list = true
-- vim.cmd("set showbreak=↳")

vim.opt.incsearch = true
vim.opt.inccommand = "split"

vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"

-- Enable folding ( setup in nvim-ufo )
vim.o.foldenable = true -- Enable folding by default
vim.o.foldmethod = "manual" -- Default fold method (change as needed)
vim.o.foldlevel = 99 -- Open most folds by default
vim.o.foldcolumn = "0"

-- backspace
vim.opt.backspace = { "start", "eol", "indent" }

--split windows
vim.opt.splitright = true --split vertical window to the right
vim.opt.splitbelow = true --split horizontal window to the bottom

vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
-- vim.opt.colorcolumn = "80"

-- gets rid of line with white spaces
vim.g.editorconfig = true

-- for easy mouse resizing, just incase
vim.opt.mouse = "a"

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.have_nerd_font = true

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.o.laststatus = 3

vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2C2E34" })
