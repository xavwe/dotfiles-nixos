{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.ags = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use ags";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.ags.enable {
      home-manager.users.nu = {
        programs.ags = {
          enable = true;
          configDir = ../ressources/ags;
        };
      };
    })
  ];
}