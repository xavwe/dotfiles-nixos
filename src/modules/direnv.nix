{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  stylix,
  ...
}: {
  options.modules.direnv = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use direnv";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.direnv.enable {
      home-manager.users.nu = {...}: {
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
          silent = lib.mkIf config.modules.starship.enable true;
        };
      };
    })
  ];
}
