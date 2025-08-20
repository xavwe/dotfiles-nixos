{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.pavucontrol = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use pavucontrol";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.pavucontrol.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          pavucontrol
        ];
      };
    })
  ];
}
