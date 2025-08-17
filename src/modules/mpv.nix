{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.mpv = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use mpv";
    };
    default = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Make mpv xdg default";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.mpv.enable {
      home-manager.users.nu = {
        home.packages = with pkgs; [
          mpv
        ];
        xdg.desktopEntries.mpv = {
          name = "mpv";
          exec = "${pkgs.mpv}/bin/mpv";
        };
      };
    })

    (lib.mkIf config.modules.mpv.default {
      home-manager.users.nu = {
        xdg.mimeApps = {
          defaultApplications = {
            "video/mp4" = "mpv.desktop";
            "video/mpeg" = "mpv.desktop";
          };
        };
      };
    })
  ];
}
