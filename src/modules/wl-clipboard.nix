{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.wl-clipboard = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use wl-clipboard";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.wl-clipboard.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          wl-clipboard
        ];
      };
    })
  ];
}
