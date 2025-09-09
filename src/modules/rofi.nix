{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: let
  appEntries = with config.modules; [
    (lib.optionalString firefox.enable "Firefox|${pkgs.firefox}/bin/firefox")
    (lib.optionalString foot.enable "Foot|${pkgs.foot}/bin/foot")
    (lib.optionalString libreoffice.enable "LibreOffice|${pkgs.libreoffice}/bin/libreoffice")
    (lib.optionalString calibre.enable "Calibre|${pkgs.calibre}/bin/calibre")
  ];
  apps = lib.concatStringsSep "\n" (lib.filter (s: s != "") appEntries);
  rofiLauncherScript = pkgs.writeShellScriptBin "rofi-launcher" ''
    #!/usr/bin/env bash

    # Main rofi launcher with mode selection
    # Usage: rofi-launcher [mode]

    mode="$1"

    # If no mode provided, show mode selector
    if [ -z "$mode" ]; then
        selected=$(echo -e "emoji\ncalc\nnerd\nwindow\napp" | rofi -dmenu -p "Select mode")
        if [ -n "$selected" ]; then
            exec "$0" "$selected"
        fi
        exit 0
    fi

    case "$mode" in
        "emoji")
            rofi -modi emoji -show emoji
            ;;
        "calc")
            rofi -modi calc -show calc -no-show-match -no-sort -no-history -no-persist-history -calc-command "echo -n '{result}' | ${pkgs.wl-clipboard}/bin/wl-copy"
            ;;
        "nerd")
            rofi -modi nerdy -show nerdy
            ;;
        "window")
            hyprctl clients -j | ${pkgs.jq}/bin/jq -r '.[] | "\(.address)\t\(.workspace.id)\t\(.title)"' | rofi -dmenu -p "Address | Workspace | Title" | cut -f 1 | xargs -r -I {} hyprctl dispatch focuswindow address:{}
            ;;
        "app")
            # Curated list of applications from enabled modules.
            apps="${apps}"
            selected_line=$(echo -e "$apps" | rofi -dmenu -p "App" -i)
            if [ -n "$selected_line" ]; then
                app_cmd=$(echo "$selected_line" | cut -d'|' -f2)
                hyprctl dispatch exec -- "$app_cmd"
            fi
            ;;
        *)
            # Everything mode - combine all options
            {
                echo "🔢 calc"
                echo "😀 emoji"
                echo "🤓 nerd"
                echo "🪟 window"
                echo "📱 app"
                echo "---"
                rofi -modi drun -show drun -dump | tail -n +2
            } | rofi -dmenu -p "Everything" | while read -r selection; do
                case "$selection" in
                    "🔢 calc") exec "$0" calc ;;
                    "😀 emoji") exec "$0" emoji ;;
                    "🤓 nerd") exec "$0" nerd ;;
                    "🪟 window") exec "$0" window ;;
                    "📱 app") exec "$0" app ;;
                    *)
                        # If it's an application, launch it
                        app_command=$(echo "$selection" | cut -d' ' -f2-)
                        exec $app_command
                        ;;
                esac
            done
            ;;
    esac
  '';
in {
  options.modules.rofi = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable rofi with hierarchical launcher";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.rofi.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          jq
          wl-clipboard
          rofiLauncherScript
        ];

        programs.rofi = {
          enable = true;
          package = pkgs.rofi-wayland;
          plugins = with pkgs; [
            rofi-emoji
            rofi-calc
            rofi-nerdy
          ];
        };
      };
    })
  ];
}
