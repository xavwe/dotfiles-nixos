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

              # Key mappings
              maps = {
                normal = {
                  # File explorer
                  "<leader>e" = {
                    action = "<cmd>Oil<CR>";
                    desc = "Explorer";
                  };
                };
              };

              # Lazy loading configuration
              lazy = {
                enable = true;
                plugins = {
                  # mini.icons - Icon provider for oil.nvim, snacks.nvim, which-key.nvim
                  "mini.nvim" = {
                    package = pkgs.vimPlugins.mini-nvim;
                    lazy = false;
                    setupModule = "mini.icons";
                    setupOpts = {};
                  };

                  # oil.nvim - File explorer
                  "oil.nvim" = {
                    package = pkgs.vimPlugins.oil-nvim;
                    lazy = true;
                    cmd = ["Oil"];
                    keys = [
                      {
                        key = "<leader>e";
                        action = "<cmd>Oil<CR>";
                        desc = "File Explorer";
                        mode = "n";
                      }
                    ];
                    setupModule = "oil";
                    setupOpts = {
                      default_file_explorer = true;
                      view_options = {
                        show_hidden = true;
                      };
                    };
                  };

                  # snacks.nvim - Picker
                  "snacks.nvim" = {
                    package = pkgs.vimPlugins.snacks-nvim;
                    lazy = true;
                    keys = [
                      {
                        key = "<leader><leader>";
                        action = "<cmd>lua Snacks.picker.files()<CR>";
                        desc = "Find Files";
                        mode = "n";
                      }
                      {
                        key = "<leader>/";
                        action = "<cmd>lua Snacks.picker.grep()<CR>";
                        desc = "Grep";
                        mode = "n";
                      }
                    ];
                    setupModule = "snacks";
                    setupOpts = {
                      picker = {
                        enabled = true;
                        sources = {
                          grep = {
                            hidden = true;
                          };
                          files = {
                            hidden = true;
                          };
                        };
                      };
                    };
                  };

                  # flash.nvim - Navigation
                  "flash.nvim" = {
                    package = pkgs.vimPlugins.flash-nvim;
                    lazy = true;
                    keys = [
                      {
                        key = "s";
                        mode = ["n" "x" "o"];
                        action = "<cmd>lua require('flash').jump()<CR>";
                        desc = "Flash";
                      }
                      {
                        key = "S";
                        mode = ["n" "x" "o"];
                        action = "<cmd>lua require('flash').treesitter()<CR>";
                        desc = "Flash Treesitter";
                      }
                    ];
                    setupModule = "flash";
                    setupOpts = {};
                  };

                  # indent-blankline.nvim - Indentation guides
                  "indent-blankline.nvim" = {
                    package = pkgs.vimPlugins.indent-blankline-nvim;
                    lazy = false;
                    setupModule = "ibl";
                    setupOpts = {
                      indent = {
                        char = "│";
                        tab_char = "│";
                      };
                      whitespace = {
                        highlight = ["Whitespace"];
                        remove_blankline_trail = false;
                      };
                      scope = {
                        enabled = false;
                        show_start = false;
                        show_end = false;
                      };
                    };
                  };

                  # which-key.nvim - Key mapping hints
                  "which-key.nvim" = {
                    package = pkgs.vimPlugins.which-key-nvim;
                    lazy = false;
                    setupModule = "which-key";
                    setupOpts = {
                      preset = "classic";
                      delay = 500;
                      icons.group = "";
                    };
                  };

                  # gitsigns.nvim - Git
                  "gitsigns.nvim" = {
                    package = pkgs.vimPlugins.gitsigns-nvim;
                    lazy = true;
                    event = ["BufReadPre" "BufNewFile"];
                    setupModule = "gitsigns";
                    setupOpts = {
                      signs = {
                        add = {text = "┃";};
                        change = {text = "┃";};
                        delete = {text = "_";};
                        topdelete = {text = "‾";};
                        changedelete = {text = "~";};
                        untracked = {text = "┆";};
                      };
                      signs_staged = {
                        add = {text = "┃";};
                        change = {text = "┃";};
                        delete = {text = "_";};
                        topdelete = {text = "‾";};
                        changedelete = {text = "~";};
                        untracked = {text = "┆";};
                      };
                      signs_staged_enable = true;
                      signcolumn = true;
                      numhl = false;
                      linehl = false;
                      word_diff = false;
                      watch_gitdir = {
                        follow_files = true;
                      };
                      auto_attach = true;
                      attach_to_untracked = false;
                      current_line_blame = true;
                      current_line_blame_opts = {
                        virt_text = true;
                        virt_text_pos = "eol";
                        delay = 1000;
                        ignore_whitespace = false;
                        virt_text_priority = 100;
                        use_focus = true;
                      };
                      current_line_blame_formatter = "  <author>, <author_time:%R> - <summary>";
                      sign_priority = 6;
                      update_debounce = 100;
                      status_formatter = null;
                      max_file_length = 40000;
                      preview_config = {
                        style = "minimal";
                        relative = "cursor";
                        row = 0;
                        col = 1;
                      };
                    };
                    keys = [
                      # Navigation
                      {
                        key = "]c";
                        action = "<cmd>lua if vim.wo.diff then vim.cmd.normal({']c', bang = true}) else require('gitsigns').nav_hunk('next') end<CR>";
                        desc = "Next hunk";
                        mode = "n";
                      }
                      {
                        key = "[c";
                        action = "<cmd>lua if vim.wo.diff then vim.cmd.normal({'[c', bang = true}) else require('gitsigns').nav_hunk('prev') end<CR>";
                        desc = "Previous hunk";
                        mode = "n";
                      }
                      # Actions
                      {
                        key = "<leader>gs";
                        action = "<cmd>lua require('gitsigns').stage_hunk()<CR>";
                        desc = "Stage hunk";
                        mode = "n";
                      }
                      {
                        key = "<leader>gr";
                        action = "<cmd>lua require('gitsigns').reset_hunk()<CR>";
                        desc = "Reset hunk";
                        mode = "n";
                      }
                      {
                        key = "<leader>gs";
                        action = "<cmd>lua require('gitsigns').stage_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>";
                        desc = "Stage hunk";
                        mode = "v";
                      }
                      {
                        key = "<leader>gr";
                        action = "<cmd>lua require('gitsigns').reset_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>";
                        desc = "Reset hunk";
                        mode = "v";
                      }
                      {
                        key = "<leader>gS";
                        action = "<cmd>lua require('gitsigns').stage_buffer()<CR>";
                        desc = "Stage buffer";
                        mode = "n";
                      }
                      {
                        key = "<leader>gR";
                        action = "<cmd>lua require('gitsigns').reset_buffer()<CR>";
                        desc = "Reset buffer";
                        mode = "n";
                      }
                      {
                        key = "<leader>gp";
                        action = "<cmd>lua require('gitsigns').preview_hunk()<CR>";
                        desc = "Preview hunk";
                        mode = "n";
                      }
                      {
                        key = "<leader>gi";
                        action = "<cmd>lua require('gitsigns').preview_hunk_inline()<CR>";
                        desc = "Preview hunk inline";
                        mode = "n";
                      }
                      {
                        key = "<leader>gQ";
                        action = "<cmd>lua require('gitsigns').setqflist('all')<CR>";
                        desc = "Quickfix all";
                        mode = "n";
                      }
                      {
                        key = "<leader>gq";
                        action = "<cmd>lua require('gitsigns').setqflist()<CR>";
                        desc = "Quickfix hunks";
                        mode = "n";
                      }
                      {
                        key = "<leader>gb";
                        action = "<cmd>Gitsigns blame<CR>";
                        desc = "Show Blame";
                        mode = "n";
                      }
                      # Toggles
                      {
                        key = "<leader>sb";
                        action = "<cmd>lua require('gitsigns').toggle_current_line_blame()<CR>";
                        desc = "Toggle blame";
                        mode = "n";
                      }
                      {
                        key = "<leader>sw";
                        action = "<cmd>lua require('gitsigns').toggle_word_diff()<CR>";
                        desc = "Toggle word diff";
                        mode = "n";
                      }
                      # Text object
                      {
                        key = "ih";
                        action = "<cmd>lua require('gitsigns').select_hunk()<CR>";
                        desc = "Select hunk";
                        mode = ["o" "x"];
                      }
                    ];
                  };
                };
              };

              # Remaining plugins that need to be loaded at startup
              startPlugins = with pkgs.vimPlugins; [
                vim-wakatime # Time tracking - needs to be loaded at startup
              ];

              # Lua configuration for remaining plugins
              luaConfigRC.extra-plugins = ''
                -- Configure which-key groups
                require("which-key").add({
                  { "<leader>g", group = "git", icon = { icon = "", hl = "" } },
                  { "<leader>s", group = "settings", icon = { icon = "", hl = "" } }
                })
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
