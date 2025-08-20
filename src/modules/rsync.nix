{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.rsync = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use rsync";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.rsync.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          rsync
        ];
      };
    })
  ];
}
