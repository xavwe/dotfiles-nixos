-- clipboard
--- vim.cmd("set clipboard=wl-clipboard"); --- not needed https://www.reddit.com/r/Fedora/comments/ax9p9t/vim_and_system_clipboard_under_wayland/?rdt=44798
vim.opt.hlsearch = true

vim.cmd("let g:netrw_banner = 0")

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
vim.opt.listchars = { space = '•', tab = '>~', eol = '↵' }
vim.opt.list = true
-- vim.cmd("set showbreak=↳")

vim.opt.incsearch = true
vim.opt.inccommand = "split"

vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- Enable folding ( setup in nvim-ufo )
vim.o.foldenable = true     -- Enable folding by default
vim.o.foldmethod = "manual" -- Default fold method (change as needed)
vim.o.foldlevel = 99        -- Open most folds by default
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

