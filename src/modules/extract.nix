{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.extract = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use extract";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.extract.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          extract
        ];
      };
    })
  ];
}
