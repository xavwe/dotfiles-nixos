{
  config,
  pkgs,
  lib,
  inputs,
  home-manager,
  ...
}: {
  options.modules.dark-mode = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use dark-mode";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.dark-mode.enable {
      home-manager.users.nu = {
        dconf.settings = {
          "org/gnome/desktop/background" = {
            picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
          };
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };

        gtk = {
          enable = true;
          theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome-themes-extra;
          };
        };

        # Wayland, X, etc. support for session vars
        systemd.user.sessionVariables = config.home-manager.users.nu.home.sessionVariables;
      };

      qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
      };
    })
  ];
}
