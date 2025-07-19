{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.nvim-treesitter = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use nvim-treesitter";
    };
  };

  config = lib.mkIf config.modules.nvim-treesitter.enable {
    home-manager.users.nu = {
      programs.nvf.settings.vim.lazy.plugins = {
        # nvim-treesitter - Syntax highlighting and parsing
        "nvim-treesitter" = {
          package = pkgs.vimPlugins.nvim-treesitter;
          lazy = false;
          setupModule = "nvim-treesitter.configs";
          setupOpts = {
            ensure_installed = ["lua" "nix"];
            auto_install = false;
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

        # nvim-treesitter-textobjects - Text objects based on treesitter
        "nvim-treesitter-textobjects" = {
          package = pkgs.vimPlugins.nvim-treesitter-textobjects;
          lazy = true;
          event = "VeryLazy";
          luaConfig = ''
            -- When in diff mode, we want to use the default
            -- vim text objects c & C instead of the treesitter ones.
            local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
            local configs = require("nvim-treesitter.configs")
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
          '';
        };
      };
    };
  };
}