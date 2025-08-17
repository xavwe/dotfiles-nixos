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
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          unfree.graphite-cli
        ];
      };
    })
  ];
}
