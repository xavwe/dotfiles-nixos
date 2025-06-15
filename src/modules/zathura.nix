{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.zathura = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use zathura";
    };
    default = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Make zathura xdg default";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.zathura.enable {
      home-manager.users.nu = {...}: {
        programs.zathura.enable = true;
      };
    })

    (lib.mkIf config.modules.zathura.default {
      home-manager.users.nu = {...}: {
        xdg.mimeApps = {
          defaultApplications = {
            "application/pdf" = "zathura.desktop";
          };
        };
      };
    })
  ];
}
