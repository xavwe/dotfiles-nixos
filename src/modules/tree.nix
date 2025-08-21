# tree -C
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.tree = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use tree";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.tree.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          tree
        ];
      };
    })
  ];
}
