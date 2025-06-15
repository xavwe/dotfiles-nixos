{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.nvd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use nvd";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.nvd.enable {
      environment.systemPackages = with pkgs; [
        nvd
      ];
    })
  ];
}
