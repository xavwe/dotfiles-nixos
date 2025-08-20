{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.tor-browser = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use tor-browser";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.tor-browser.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          tor-browser
        ];
      };
    })
  ];
}
