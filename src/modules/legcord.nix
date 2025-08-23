{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.legcord = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use legcord";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.legcord.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          legcord
        ];
      };
    })
  ];
}
