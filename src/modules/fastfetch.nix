{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.fastfetch = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use fastfetch";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.fastfetch.enable {
      home-manager.users.nu = {...}: {
        programs.fastfetch = {
          enable = true;
          settings = {};
        };
      };
    })
  ];
}
