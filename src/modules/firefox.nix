{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.firefox = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use firefox";
    };
    default = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Make firefox default";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.firefox.enable {
      programs.firefox = {
        enable = true;
        policies = {
          PasswordManagerEnabled = false;
          OfferToSaveLogins = false;
        };
      };
    })

    (lib.mkIf config.modules.firefox.default {
      home-manager.users.nu = {...}: {
        xdg.mimeApps = {
          defaultApplications = {
            "text/html" = "firefox.desktop";
            "x-scheme-handler/http" = "firefox.desktop";
            "x-scheme-handler/https" = "firefox.desktop";
            "x-scheme-handler/about" = "firefox.desktop";
            "x-scheme-handler/unknown" = "firefox.desktop";
          };
        };
      };
    })
  ];
}
