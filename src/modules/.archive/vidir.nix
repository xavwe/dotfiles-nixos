# find . -type f | vidir -
# vidir
{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.vidir = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use vidir";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.vidir.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          perl540Packages.vidir
        ];
      };
    })
  ];
}
