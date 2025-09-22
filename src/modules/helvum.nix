{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.helvum = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use helvum";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.helvum.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          helvum
        ];
      };
    })
  ];
}
