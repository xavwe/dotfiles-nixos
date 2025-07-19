{
  inputs,
  lib,
  config,
  pkgs,
  overlays,
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

                  # nvim-treesitter - Syntax highlighting and parsing
                  # check if language present: :lua print(require('nvim-treesitter.parsers').has_parser('lua'))
                  "nvim-treesitter" = {
                    package = pkgs.vimPlugins.nvim-treesitter;
                    lazy = false;
                    setupModule = "nvim-treesitter.configs";
                    setupOpts = {
                      ensure_installed = {};
                      auto_install = false;
                      sync_install = false;
                      prefer_git = false;
                      highlight = {
                        enable = true;
                        disable = ''
                          function(lang, buf)
                            local max_filesize = 100 * 1024 -- 100 KB
                            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                            if ok and stats and stats.size > max_filesize then
                              return true
                            end
                          end
                        '';
                        additional_vim_regex_highlighting = false;
                      };
                    };
                  };

                  # nvim-treesitter-textobjects - Enhanced text objects
                  "nvim-treesitter-textobjects" = {
                    package = pkgs.vimPlugins.nvim-treesitter-textobjects;
                    lazy = true;
                    event = ["BufReadPost" "BufNewFile"];
                    setupModule = "nvim-treesitter.configs";
                    setupOpts = {
                      textobjects = {
                        select = {
                          enable = true;
                          lookahead = true;
                          keymaps = {
                            "af" = "@function.outer";
                            "if" = "@function.inner";
                            "ac" = "@class.outer";
                            "ic" = "@class.inner";
                            "ap" = "@parameter.outer";
                            "ip" = "@parameter.inner";
                          };
                        };
                        move = {
                          enable = true;
                          set_jumps = true;
                          goto_next_start = {
                            "]f" = "@function.outer";
                            "]c" = "@class.outer";
                          };
                          goto_next_end = {
                            "]F" = "@function.outer";
                            "]C" = "@class.outer";
                          };
                          goto_previous_start = {
                            "[f" = "@function.outer";
                            "[c" = "@class.outer";
                          };
                          goto_previous_end = {
                            "[F" = "@function.outer";
                            "[C" = "@class.outer";
                          };
                        };
                      };
                    };
                  };

                  # plenary.nvim - Lua utility library
                  "plenary.nvim" = {
                    package = pkgs.vimPlugins.plenary-nvim;
                    lazy = true;
                  };

                  # todo-comments.nvim - Highlight and navigate TODO comments
                  "todo-comments.nvim" = {
                    package = pkgs.vimPlugins.todo-comments-nvim;
                    lazy = true;
                    cmd = ["TodoTrouble"];
                    setupModule = "todo-comments";
                    setupOpts = {};
                    keys = [
                      {
                        key = "]t";
                        action = "<cmd>lua require('todo-comments').jump_next()<CR>";
                        desc = "Next Todo Comment";
                        mode = "n";
                      }
                      {
                        key = "[t";
                        action = "<cmd>lua require('todo-comments').jump_prev()<CR>";
                        desc = "Previous Todo Comment";
                        mode = "n";
                      }
                      {
                        key = "<leader>t";
                        action = "<cmd>Trouble todo toggle<CR>";
                        desc = "Todo";
                        mode = "n";
                      }
                    ];
                  };

                  # conform.nvim - Code formatting
                  "conform.nvim" = {
                    package = pkgs.vimPlugins.conform-nvim;
                    lazy = false;
                    setupModule = "conform";
                    setupOpts = {
                      formatters_by_ft = {
                        lua = ["stylua"];
                        nix = ["alejandra"];
                        haskell = ["ormolu"];
                        tex = ["latexindent"];
                        latex = ["latexindent"];
                      };
                      formatters = {
                        latexindent = {
                          prepend_args = ["-l" "-m"];
                        };
                      };
                      format_on_save = {
                        timeout_ms = 500;
                        lsp_fallback = true;
                      };
                    };
                  };

                  # lazydev.nvim - Lua development support
                  "lazydev.nvim" = {
                    package = pkgs.vimPlugins.lazydev-nvim;
                    lazy = true;
                    ft = ["lua"];
                    setupModule = "lazydev";
                    setupOpts = {
                      library = [
                        {
                          path = "\${3rd}/luv/library";
                          words = ["vim%.uv"];
                        }
                      ];
                    };
                  };

                  # friendly-snippets - Snippet collection
                  "friendly-snippets" = {
                    package = pkgs.vimPlugins.friendly-snippets;
                    lazy = true;
                  };

                  # blink.cmp - Completion engine
                  "blink.cmp" = {
                    package = pkgs.vimPlugins.blink-cmp;
                    lazy = false;
                    setupModule = "blink.cmp";
                    setupOpts = {
                      keymap = {
                        preset = "default";
                      };
                      appearance = {
                        use_nvim_cmp_as_default = true;
                        nerd_font_variant = "mono";
                      };
                      signature = {
                        enabled = true;
                      };
                    };
                  };

                  # trouble.nvim - Diagnostics list
                  "trouble.nvim" = {
                    package = pkgs.vimPlugins.trouble-nvim;
                    lazy = true;
                    cmd = ["Trouble"];
                    setupModule = "trouble";
                    setupOpts = {};
                    keys = [
                      {
                        key = "<leader>x";
                        action = "<cmd>Trouble diagnostics toggle<cr>";
                        desc = "Diagnostics";
                        mode = "n";
                      }
                    ];
                  };

                  # nvim-lspconfig - LSP configuration
                  "nvim-lspconfig" = {
                    package = pkgs.vimPlugins.nvim-lspconfig;
                    lazy = false;
                    setupModule = null;
                  };
                };
              };

              # Remaining plugins that need to be loaded at startup
              startPlugins = with pkgs.vimPlugins; [
                pkgs.workspace-diagnostics-nvim
              ];

              # Lua configuration for remaining plugins
              luaConfigRC.extra-plugins = ''
                -- Configure which-key groups
                require("which-key").add({
                  { "<leader>g", group = "git", icon = { icon = "", hl = "" } },
                  { "<leader>s", group = "settings", icon = { icon = "", hl = "" } }
                })

                -- LSP Configuration
                local capabilities = require("blink.cmp").get_lsp_capabilities()

                vim.diagnostic.config({
                  underline = true,
                  signs = {
                    text = {
                      [vim.diagnostic.severity.ERROR] = "",
                      [vim.diagnostic.severity.WARN] = "",
                      [vim.diagnostic.severity.HINT] = "",
                      [vim.diagnostic.severity.INFO] = "",
                    },
                  },
                  update_in_insert = false,
                  severity_sort = true,
                })

                -- Lua Language Server
                if vim.fn.executable("lua-language-server") == 1 then
                  require("lspconfig").lua_ls.setup({
                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                      require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                    end,
                    settings = {
                      Lua = {
                        workspace = {
                          checkThirdParty = false,
                          library = vim.api.nvim_get_runtime_file("", true),
                          fileOperations = {
                            didRename = true,
                            willRename = true,
                          },
                          didChangeWatchedFiles = true,
                        },
                        codeLens = {
                          enable = true,
                        },
                        completion = {
                          callSnippet = "Replace",
                        },
                        doc = {
                          privateName = { "^_" },
                        },
                        hint = {
                          enable = true,
                          setType = false,
                          paramType = true,
                          paramName = "Disable",
                          semicolon = "Disable",
                          arrayIndex = "Disable",
                        },
                        telemetry = {
                          enable = false,
                        },
                      },
                    },
                  })
                end

                -- Nixd Language Server
                if vim.fn.executable("nixd") == 1 then
                  require("lspconfig").nixd.setup({
                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                      require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                    end,
                  })
                end

                -- Haskell Language Server
                if vim.fn.executable("haskell-language-server-wrapper") == 1 then
                  require("lspconfig").hls.setup({
                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                      require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                    end,
                  })
                end

                -- TeXLab Language Server
                if vim.fn.executable("texlab") == 1 then
                  require("lspconfig").texlab.setup({
                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                      require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                    end,
                  })
                end

                -- Configure treesitter textobjects for diff mode compatibility
                -- When in diff mode, we want to use the default
                -- vim text objects c & C instead of the treesitter ones.
                vim.api.nvim_create_autocmd("User", {
                  pattern = "LazyDone",
                  callback = function()
                    local ok_move, move = pcall(require, "nvim-treesitter.textobjects.move")
                    local ok_configs, configs = pcall(require, "nvim-treesitter.configs")

                    if ok_move and ok_configs then
                      for name, fn in pairs(move) do
                        if name:find("goto") == 1 then
                          move[name] = function(q, ...)
                            if vim.wo.diff then
                              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                              for key, query in pairs(config or {}) do
                                if q == query and key:find("[%]%[][cC]") then
                                  vim.cmd("normal! " .. key)
                                  return
                                end
                              end
                            end
                            return fn(q, ...)
                          end
                        end
                      end
                    end
                  end,
                 })


                -- Per-directory treesitter grammar support for NixOS
                local function setup_per_directory_treesitter()
                  -- Function to detect available treesitter grammars from nix packages in PATH
                  local function get_available_nix_grammars()
                    local available_grammars = {}

                    -- print("DEBUG: Scanning for nix treesitter grammar packages...")

                    -- Check nativeBuildInputs environment variable which contains the packages
                    local native_build_inputs = vim.env.nativeBuildInputs or ""
                    -- print("DEBUG: nativeBuildInputs = " .. native_build_inputs)

                    -- Parse the nativeBuildInputs to find treesitter grammar packages
                    for store_path in string.gmatch(native_build_inputs, "([^%s]+)") do
                      if string.match(store_path, "tree%-sitter.*grammar") then
                        -- print("DEBUG: Found treesitter grammar package: " .. store_path)

                        -- Check for the parser file (in NixOS it's just called "parser", not "parser.so")
                        local parser_path = store_path .. "/parser"
                        local file = io.open(parser_path, "r")
                        if file then
                          file:close()
                          -- print("DEBUG: Found parser at: " .. parser_path)

                          -- Extract language name from store path
                          local lang = string.match(store_path, "tree%-sitter%-([^-]+)%-grammar")
                          if lang then
                            -- print("DEBUG: Detected language: " .. lang .. " -> " .. parser_path)
                            available_grammars[lang] = parser_path
                          end
                        end
                      end
                    end

                    -- Also check PATH for any additional store paths (backup method)
                    local path = vim.env.PATH or ""
                    local nix_store_paths = {}

                    -- Collect all nix store paths from PATH
                    for dir in string.gmatch(path, "([^:]+)") do
                      if string.match(dir, "/nix/store/") then
                        local store_path = string.match(dir, "(/nix/store/[^/]+)")
                        if store_path then
                          nix_store_paths[store_path] = true
                        end
                      end
                    end

                    -- Also check NIX_PROFILES
                    local nix_profiles = vim.env.NIX_PROFILES or ""
                    for profile in string.gmatch(nix_profiles, "([^%s]+)") do
                      nix_store_paths[profile] = true
                    end

                    -- print("DEBUG: Also checking nix store paths from PATH: " .. vim.inspect(vim.tbl_keys(nix_store_paths)))

                    -- Look for treesitter grammar packages in PATH store paths
                    for store_path, _ in pairs(nix_store_paths) do
                      if string.match(store_path, "tree%-sitter.*grammar") then
                        -- print("DEBUG: Found treesitter grammar package in PATH: " .. store_path)

                        -- Check for the parser file
                        local parser_path = store_path .. "/parser"
                        local file = io.open(parser_path, "r")
                        if file then
                          file:close()
                          -- print("DEBUG: Found parser at: " .. parser_path)

                          -- Extract language name from store path
                          local lang = string.match(store_path, "tree%-sitter%-([^-]+)%-grammar")
                          if lang then
                            -- print("DEBUG: Detected language: " .. lang .. " -> " .. parser_path)
                            available_grammars[lang] = parser_path
                          end
                        end
                      end
                    end

                    -- print("DEBUG: Available grammars: " .. vim.inspect(available_grammars))
                    return available_grammars
                  end

                  -- Function to load available grammars into treesitter
                  local function load_available_grammars()
                    local grammars = get_available_nix_grammars()

                    for lang, grammar_path in pairs(grammars) do
                      -- print("DEBUG: Loading grammar for " .. lang .. " from " .. grammar_path)

                      -- Verify the file exists
                      local file = io.open(grammar_path, "r")
                      if file then
                        file:close()

                        -- Register with nvim-treesitter's parser configs first
                        local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
                        if not parser_configs[lang] then
                          parser_configs[lang] = {
                            install_info = {
                              url = "file://" .. grammar_path,
                              files = { grammar_path },
                              branch = "main",
                            },
                            filetype = lang,
                          }
                          -- print("DEBUG: Registered parser config for " .. lang)
                        end

                        -- Try to register the language with treesitter core
                        local success, err = pcall(function()
                          vim.treesitter.language.add(lang, {
                            path = grammar_path
                          })
                        end)

                        if success then
                          -- print("DEBUG: Successfully loaded " .. lang .. " grammar")

                          -- Also try to set up filetype mapping if it doesn't exist
                          local ft_success, ft_err = pcall(function()
                            if not vim.treesitter.language.get_filetypes(lang)[1] then
                              vim.treesitter.language.register(lang, lang)
                            end
                          end)

                          if ft_success then
                            -- print("DEBUG: Successfully registered filetype for " .. lang)
                          else
                            -- print("DEBUG: Failed to register filetype for " .. lang .. ": " .. tostring(ft_err))
                          end

                          -- Mark as available in nvim-treesitter's internal state
                          local install_success, install_err = pcall(function()
                            local install = require("nvim-treesitter.install")
                            if install and install.commands and install.commands.TSInstall then
                              -- Create a symbolic link or mark as installed in nvim-treesitter's tracking
                              local info = require("nvim-treesitter.info")
                              if info and info.installed_parsers then
                                local installed = info.installed_parsers()
                                if not vim.tbl_contains(installed, lang) then
                                  -- Force refresh nvim-treesitter's installed parser list
                                  vim.schedule(function()
                                    vim.cmd("silent! TSUpdateSync")
                                  end)
                                end
                              end
                            end
                          end)

                          if install_success then
                            -- print("DEBUG: Successfully integrated " .. lang .. " with nvim-treesitter")
                          else
                            -- print("DEBUG: Warning: Could not integrate " .. lang .. " with nvim-treesitter: " .. tostring(install_err))
                          end

                        else
                          -- print("DEBUG: Failed to load " .. lang .. " grammar: " .. tostring(err))
                        end
                      else
                        -- print("DEBUG: Grammar file not accessible: " .. grammar_path)
                      end
                    end

                    -- Refresh treesitter after loading new grammars
                    vim.schedule(function()
                      vim.cmd("silent! doautocmd FileType")
                    end)
                  end

                  -- Initialize on startup
                  load_available_grammars()

                  -- Reload when directory changes (for direnv)
                  vim.api.nvim_create_autocmd({"DirChanged", "VimEnter"}, {
                    group = vim.api.nvim_create_augroup("nix-treesitter-reload", { clear = true }),
                    callback = function()
                      -- print("DEBUG: Directory/environment changed, reloading treesitter grammars...")
                      vim.defer_fn(function()
                        load_available_grammars()

                        -- Refresh syntax for all buffers
                        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                          if vim.api.nvim_buf_is_loaded(buf) then
                            vim.api.nvim_buf_call(buf, function()
                              local ft = vim.bo.filetype
                              if ft and ft ~= "" then
                                -- Trigger treesitter to re-evaluate
                                vim.cmd("edit!")
                              end
                            end)
                          end
                        end
                      end, 300)
                    end,
                  })

                  -- Manual reload command
                  vim.api.nvim_create_user_command("TSReloadNixGrammars", function()
                    -- print("Manually reloading nix treesitter grammars...")
                    load_available_grammars()
                  end, { desc = "Reload treesitter grammars from nix environment" })

                  -- Debug command to show available grammars
                  vim.api.nvim_create_user_command("TSShowNixGrammars", function()
                    local grammars = get_available_nix_grammars()
                    -- print("Available nix treesitter grammars:")
                    for lang, path in pairs(grammars) do
                      -- print("  " .. lang .. " -> " .. path)
                    end
                  end, { desc = "Show available treesitter grammars from nix" })
                end

                -- Initialize nix treesitter support
                setup_per_directory_treesitter()
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
