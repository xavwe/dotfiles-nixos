{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.libreoffice = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use libreoffice";
    };
    default = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Make libreoffice xdg default";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.libreoffice.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          libreoffice-fresh
          hunspell
          hunspellDicts.de_DE
          hunspellDicts.en_GB-ise
        ];
      };
    })

    (lib.mkIf config.modules.libreoffice.default {
      home-manager.users.nu = {
        xdg.mimeApps = {
          defaultApplications = {
            "application/vnd.ms-powerpoint" = "libreoffice.desktop";
            "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "libreoffice.desktop";
            "application/msword" = "libreoffice.desktop";
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "libreoffice.desktop";
            "application/vnd.ms-excel" = "libreoffice.desktop";
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "libreoffice.desktop";
          };
        };
      };
    })
  ];
}
