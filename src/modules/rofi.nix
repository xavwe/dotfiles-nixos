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
        selected=$(echo -e "emoji\ncalc\nnerd\napp" | rofi -dmenu -p "select mode")
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
        "app")
            # Curated list of applications from enabled modules.
            apps="${apps}"
            selected_line=$(echo -e "$apps" | rofi -dmenu -p "App" -i)
            if [ -n "$selected_line" ]; then
                app_cmd=$(echo "$selected_line" | cut -d'|' -f2)
                $app_cmd &
            fi
            ;;
        *)
            # Everything mode - combine all options
            {
                echo "🔢 calc"
                echo "😀 emoji"
                echo "🤓 nerd"
                echo "📱 app"
                echo "---"
                rofi -modi drun -show drun -dump | tail -n +2
            } | rofi -dmenu -p "Everything" | while read -r selection; do
                case "$selection" in
                    "🔢 calc") exec "$0" calc ;;
                    "😀 emoji") exec "$0" emoji ;;
                    "🤓 nerd") exec "$0" nerd ;;
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
          plugins = with pkgs; [
            rofi-emoji
            rofi-calc
            rofi-nerdy
          ];
          terminal = "\${pkgs.foot}/bin/foot";
          modes = [
            "drun"
            "emoji"
            "nerdy"
            "calc"
          ];
          extraConfig = {
            lines = 2;
            font = "monospace 12";
            show-icons = false;
            icon-theme = "Haptic Dark";
            drun-display-format = "{name}";
            location = 0;
            disable-history = false;
            hide-scrollbar = true;
            display-drun = "󰗍 run";
          };
          theme = "custom";
        };
        home.file.".config/rofi/themes/custom.rasi".text = ''
          element-text, element-icon , mode-switcher {
            background-color: inherit;
            text-color:       inherit;
          }

          window {
            height: 280px;
            border: 2px;
            location: center;
            x-offset: 0px;
            y-offset: 0px;
            border-color: @border-col;
            background-color: @bg-col;
            border-radius: 6px;
          }

          mainbox {
            background-color: @transparent;
          }

          inputbar {
            children: [prompt,entry];
            background-color: @transparent;
            color: @green;
            border-radius: 4px;
            font: "monospace Bold 13";
            padding: 2px;
          }

          prompt {
            background-color: @transparent;
            padding: 6px;
            text-color: white;
            border-radius: 5px;
            margin: 20px 0px 0px 20px;
          }

          textbox-prompt-colon {
            expand: false;
            str: ":";
          }

          entry {
            padding: 6px;
            margin: 20px 0px 0px 10px;
            background-color: @transparent;
            color: white;
          }

          listview {
            border: 0px 0px 0px;
            padding: 6px;
            margin: 10px;
            columns: 1;
            lines: 4;
            background-color: @transparent;
          }

          element {
            padding: 10px;
            background-color: @transparent;
            text-color: @fg-col;
          }

          element-icon {
            size: 25px;
          }

          element selected {
            border-radius: 5px;
            text-color: #000000;
            background-color: @magenta;
          }

          mode-switcher {
            spacing: 0;
          }

          button {
            padding: 10px;
            background-color: @bg-col-light;
            text-color: @grey;
            vertical-align: 0.5;
            horizontal-align: 0.5;
          }

          button selected {
            background-color: @bg-col;
            text-color: @blue;
          }
          * {
            bg-col:  #000000;
            transparent: #000000;
            bg-col-light: #1e2229;
            border-col: #9F9F9FFF;
            selected-col: #1e2229;
            blue: #aab2ec;
            green: #aaecad;
            magenta: #c1aaec;
            fg-col: #e3e3e3;
            fg-col2: #f8f8f8;
            grey: #38474a;
            width: 400;
          }
        '';
      };
    })
  ];
}
