{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.printing = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable printing";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.printing.enable {
      services.printing.enable = true;
    })
  ];
}
