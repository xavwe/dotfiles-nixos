{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.neovim = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use neovim";
    };
    default = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Make neovim default";
    };
    manpager = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Make neovim default manpager";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.neovim.enable {
      environment.systemPackages = with pkgs; [
        ripgrep
        fd
        tree-sitter
        nodejs
      ];
      home-manager.users.nu = {
        programs.nvf = {
          enable = true;
          settings = {
            vim = {
              # General vim settings
              viAlias = false;
              vimAlias = false;

              # Vim options via lua configuration
              luaConfigRC.options = ''
                -- Leader keys
                vim.g.mapleader = " "
                vim.g.maplocalleader = " "

                -- Clipboard
                vim.opt.clipboard = "unnamedplus"

                -- Search
                vim.opt.hlsearch = true
                vim.opt.incsearch = true
                vim.opt.inccommand = "split"

                -- Line numbers
                vim.opt.number = true
                vim.opt.relativenumber = true

                -- Indentation
                vim.opt.expandtab = true
                vim.opt.tabstop = 2
                vim.opt.softtabstop = 2
                vim.opt.shiftwidth = 2
                vim.opt.autoindent = true

                -- Wrapping
                vim.opt.wrap = false

                -- Swap/backup/undo
                vim.opt.swapfile = false
                vim.opt.backup = false
                vim.opt.undofile = true

                -- Visual
                vim.opt.termguicolors = true
                vim.opt.background = "dark"
                vim.opt.scrolloff = 10
                vim.opt.signcolumn = "yes"
                vim.opt.cursorline = true

                -- Folding
                vim.o.foldenable = true
                vim.o.foldmethod = "manual"
                vim.o.foldlevel = 99
                vim.o.foldcolumn = "0"

                -- Backspace
                vim.opt.backspace = { "start", "eol", "indent" }

                -- Split windows
                vim.opt.splitright = true
                vim.opt.splitbelow = true

                -- Misc
                vim.opt.updatetime = 50
                vim.opt.mouse = "a"
                vim.opt.laststatus = 3

                -- List chars
                vim.opt.list = true
                vim.opt.listchars = { space = "•", tab = ">~", eol = "↵" }

                -- Globals
                vim.g.have_nerd_font = true
                vim.g.editorconfig = true
                vim.g.loaded_netrw = 1
                vim.g.loaded_netrwPlugin = 1

                -- Highlight on yank
                vim.api.nvim_create_autocmd("TextYankPost", {
                  desc = "Highlight when yanking (copying) text",
                  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
                  callback = function()
                    vim.highlight.on_yank()
                  end,
                })

                -- Custom cursor line highlight
                vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2C2E34" })
              '';
            };
          };
        };
      };
    })

    (lib.mkIf config.modules.neovim.default {
      programs.neovim.defaultEditor = true;
      home-manager.users.nu = {
        home.sessionVariables = {
          VISUAL = "nvim";
          EDITOR = "$VISUAL";
        };
      };
    })

    (lib.mkIf config.modules.neovim.manpager {
      environment.sessionVariables = lib.mkMerge [
        {
          MANPAGER = "nvim +Man!";
        }
      ];
    })
  ];
}
