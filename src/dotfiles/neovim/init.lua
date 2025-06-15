--- vim.cmd("set clipboard=wl-clipboard"); --- not needed https://www.reddit.com/r/Fedora/comments/ax9p9t/vim_and_system_clipboard_under_wayland/?rdt=44798
vim.cmd("set number");
vim.cmd("set expandtab");
vim.cmd("set tabstop=2");
vim.cmd("set softtabstop=2");
vim.cmd("set shiftwidth=2");

-- source: https://vi.stackexchange.com/questions/31811/neovim-lua-config-how-to-append-to-listchars
vim.opt.listchars = { space = '•', tab = '>~', eol = '↵' }
vim.opt.list = true
