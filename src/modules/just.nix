{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.just = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use just";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.just.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          just
        ];
      };
    })
  ];
}
