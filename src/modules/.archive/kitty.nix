{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.kitty = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use kitty";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.kitty.enable {
      home-manager.users.nu = {...}: {
        programs.kitty = {
          enable = true;
          font = {
            name = "monospace";
            size = 13;
          };
          settings = {
            scrollback_lines = 5000;
          };
        };
      };
    })
  ];
}
