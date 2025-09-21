{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.calibre = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use calibre ebook management";
    };
    default = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Make calibre xdg default for ebook formats";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.calibre.enable {
      home-manager.users.nu = {lib, ...}: {
        home.packages = with pkgs; [
          calibre
        ];

        # Install Calibre plugins using development mode (directory installation)
        home.activation.installCalibrePlugins = lib.hm.dag.entryAfter ["writeBoundary"] ''
          # Ensure calibre config directory exists
          mkdir -p $HOME/.config/calibre

          # List of plugins to install: name, package, zip_filename
          plugins=(
            "WordDumb:${pkgs.calibre-plugin-worddumb}:WordDumb.zip"
            "EpubSplit:${pkgs.calibre-plugin-epubsplit}:EpubSplit.zip"
            "DeDRM:${pkgs.calibre-plugin-dedrm}:DeDRM.zip"
            "Obok:${pkgs.calibre-plugin-dedrm}:Obok.zip"
            "EpubMerge:${pkgs.calibre-plugin-epubmerge}:EpubMerge.zip"
          )

          for plugin_info in "''${plugins[@]}"; do
            IFS=':' read -r plugin_name plugin_package zip_filename <<< "$plugin_info"

            if ! ${pkgs.calibre}/bin/calibre-customize --list-plugins | grep -q "$plugin_name"; then
              echo "Installing $plugin_name plugin from ZIP file..."
              ${pkgs.calibre}/bin/calibre-customize -a "$plugin_package/share/calibre-plugins/$zip_filename"
            else
              echo "$plugin_name plugin already installed"
            fi
          done
        '';

        # Set up default library location
        home.file.".config/calibre/global.py".text = ''
          # Default library location
          library_path = '/home/nu/book'
        '';
      };
    })

    (lib.mkIf config.modules.calibre.default {
      home-manager.users.nu = {...}: {
        xdg.mimeApps = {
          defaultApplications = {
            "application/epub+zip" = "calibre-ebook-viewer.desktop";
            "application/x-mobipocket-ebook" = "calibre-ebook-viewer.desktop";
            "application/vnd.amazon.ebook" = "calibre-ebook-viewer.desktop";
            "application/pdf" = "calibre-ebook-viewer.desktop";
            "text/plain" = "calibre-ebook-viewer.desktop";
            "application/x-cbr" = "calibre-ebook-viewer.desktop";
            "application/x-cbz" = "calibre-ebook-viewer.desktop";
          };
        };
      };
    })
  ];
}