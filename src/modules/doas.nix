# TODO: sudo enable false global?
{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.doas = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use doas";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.doas.enable {
      security = {
        sudo = {
          enable = lib.mkDefault false;
        };
        doas = {
          enable = true;
          extraRules = [
            {
              users = ["nu"];
              keepEnv = true;
              persist = true;
            }
          ];
        };
      };
    })
  ];
}
