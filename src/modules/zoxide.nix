{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  stylix,
  ...
}: {
  options.modules.zoxide = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use zoxide";
    };
    default = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Make zoxide default";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.zoxide.enable {
      home-manager.users.nu = {...}: {
        programs.zoxide = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = lib.mkIf config.modules.zsh.enable true;
        };
      };
    })
    (lib.mkIf config.modules.zoxide.default {
      home-manager.users.nu = {...}: {
        home = {
          shellAliases = {
            cd = "z";
            cdi = "zi";
          };
        };
      };
    })
  ];
}
