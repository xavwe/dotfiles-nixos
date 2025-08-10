{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.graphite = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use graphite.dev cli";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.graphite.enable {
      environment.systemPackages = with pkgs; [
        unfree.graphite-cli
      ];
    })
  ];
}
