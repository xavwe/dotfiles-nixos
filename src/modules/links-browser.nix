{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  home-manager,
  overlays,
  sops-nix,
  ...
}: {
  options.modules.links-browser = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use links browser";
    };
    default = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Make links default browser";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.links-browser.enable {
      environment.systemPackages = with pkgs; [
        links2
      ];
    })

    (lib.mkIf config.modules.links-browser.default {
      environment.variables.BROWSER = "links2";
    })
  ];
}
