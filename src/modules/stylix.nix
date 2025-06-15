{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  stylix,
  ...
}: {
  options.modules.stylix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use stylix";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.stylix.enable {
      home-manager.users.nu = {...}: {
        stylix.enable = true;
      };
    })
  ];
}
