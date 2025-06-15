{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.distrobox = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use distrobox";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.distrobox.enable {
      modules.podman.enable = true;
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          distrobox
        ];
      };
    })
  ];
}
