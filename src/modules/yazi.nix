{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.yazi = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use yazi";
    };
    default = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Make yazi xdg default";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.yazi.enable {
      home-manager.users.nu = {...}: {
        programs.yazi = {
          enable = true;
          settings = {
            manager = {
              show_hidden = true;
            };
          };
        };
      };
    })
    (lib.mkIf config.modules.yazi.default {
      home-manager.users.nu = {...}: {
        xdg.mimeApps = {
          defaultApplications = {
            "inode/directory" = "yazi.desktop";
            "inode/mount-point" = "yazi.desktop";
          };
        };
      };
    })
  ];
}
