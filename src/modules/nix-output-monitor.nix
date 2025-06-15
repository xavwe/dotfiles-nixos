{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.nix-output-monitor = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use nix-output-monitor";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.nix-output-monitor.enable {
      environment.systemPackages = with pkgs; [
        nix-output-monitor
      ];
    })
  ];
}
