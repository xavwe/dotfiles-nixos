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
      programs.neovim = {
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        ripgrep
        fd
      ];
    })

    (lib.mkIf config.modules.neovim.default {
      programs.neovim.defaultEditor = true;
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
