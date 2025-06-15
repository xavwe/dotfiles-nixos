{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.tldr = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use tldr";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.tldr.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          tealdeer
        ];
      };
    })
  ];
}
