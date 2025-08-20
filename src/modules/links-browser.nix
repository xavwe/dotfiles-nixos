{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.links-browser = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use links-browser";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.links-browser.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          links2
        ];
      };
    })
  ];
}
