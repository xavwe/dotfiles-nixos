{
  inputs,
  lib,
  config,
  pkgs,
  overlays,
  home-manager,
  ...
}: {
  options.modules.btop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use btop";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.btop.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          btop-gpu
          intel-gpu-tools
        ];
      };
    })
  ];
}
