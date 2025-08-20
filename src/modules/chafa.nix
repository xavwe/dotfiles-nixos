{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.chafa = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use chafa";
    };
    default = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Make chafa xdg default";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.chafa.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          chafa
          librsvg
        ];
        xdg.desktopEntries.chafa = {
          name = "chafa";
          exec = "${pkgs.chafa}/bin/chafa";
        };
      };
    })

    (lib.mkIf config.modules.chafa.default {
      home-manager.users.nu = {
        xdg.mimeApps = {
          defaultApplications = {
            "image/jpeg" = "chafa.desktop";
            "image/png" = "chafa.desktop";
          };
        };
      };
    })
  ];
}
