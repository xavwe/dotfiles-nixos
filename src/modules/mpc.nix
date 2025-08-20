# ncmpcpp extra file
{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.mpc = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use mpc";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.mpc.enable {
      environment.sessionVariables = lib.mkMerge [
        {
          MPD_PORT = "6600";
        }
      ];
      home-manager.users.nu = {pkgs, ...}: {
        home.packages = [pkgs.mpc-cli];
      };
    })
  ];
}
