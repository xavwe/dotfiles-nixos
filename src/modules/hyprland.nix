{
  config,
  pkgs,
  lib,
  inputs,
  home-manager,
  ...
}: let
  hyprVars = {
    terminal = "foot";
    browser = "firefox";
    private-browser = "tor-browser";
    virt-manager = "virt-manager";
    note = "obsidian";
    colorpicker = "echo -n hyprpicker | wl-copy";
    mainMod = "SUPER";
  };
in {
  options.modules.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use hyprland";
    };
    xwayland.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use xwayland";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.hyprland.enable {
      services.dbus.enable = true;

      environment.sessionVariables = lib.mkMerge [
        {
          WLR_NO_HARDWARE_CURSORS = "1";
          NIXOS_OZONE_WL = "1";
          GRIM_DEFAULT_DIR = "~/screenshot";
        }
      ];

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
        ];
        config.common.default = "*";
      };

      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          grim
          slurp
          rofi-wayland
          jq
          xdg-utils
          nushell
          waybar
        ];
        programs.wayprompt.enable = true;
        wayland.windowManager.hyprland = {
          enable = true;
          xwayland.enable = config.modules.hyprland.xwayland.enable;
          settings = {
            monitor = [",preferred,auto,auto"];

            #exec-once = ''hypridle'';

            env = [
              "XCURSOR_SIZE,24"
              "HYPRCURSOR_SIZE,24"
            ];

            general = {
              gaps_in = 5;
              gaps_out = 20;
              border_size = 2;
              "col.active_border" = "${lib.hexToRgb config.colors.base01} ${lib.hexToRgb config.colors.base01}";
              "col.inactive_border" = "${lib.hexToRgb config.colors.base01} ${lib.hexToRgb config.colors.base01}";
              resize_on_border = true;
              allow_tearing = false;
              layout = "master";
            };

            decoration = {
              rounding = 10;
              active_opacity = 1.0;
              inactive_opacity = 0.75;

              blur = {
                enabled = true;
                size = 10;
                passes = 1;
                vibrancy = 0.1696;
              };
            };

            animations = {
              enabled = false;
              bezier = ["myBezier, 0.05, 0.9, 0.1, 1.05"];
              animation = [
                "windows, 1, 7, myBezier"
                "windowsOut, 1, 7, default, popin 80%"
                "border, 1, 10, default"
                "borderangle, 1, 8, default"
                "fade, 1, 7, default"
                "workspaces, 1, 6, default"
              ];
            };

            dwindle = {
              pseudotile = true;
              preserve_split = true;
              default_split_ratio = 1.3;
            };

            master = {
              mfact = 0.6;
              new_status = "master";
            };

            misc = {
              force_default_wallpaper = 0;
              disable_hyprland_logo = true;
              background_color = lib.hexToRgb config.colors.base00;
            };

            input = {
              numlock_by_default = true;
              kb_layout = "eu";
              kb_options = "caps:escape";
              follow_mouse = 1;
              sensitivity = 0;

              touchpad = {
                natural_scroll = false;
              };
            };

            gestures = {
              workspace_swipe = false;
            };

            ecosystem = {
              no_update_news = true;
            };

            device = [
              {
                name = "epic-mouse-v1";
                sensitivity = -0.5;
              }
            ];

            bind = [
              "${hyprVars.mainMod}, Q, exec, ${hyprVars.terminal}"
              "${hyprVars.mainMod}, W, exec, ${hyprVars.browser}"
              "${hyprVars.mainMod} SHIFT, W, exec, ${hyprVars.private-browser}"
              "${hyprVars.mainMod}, N, exec, ${hyprVars.note}"
              "${hyprVars.mainMod}, V, exec, ${hyprVars.virt-manager}"
              "${hyprVars.mainMod}, A, exec, ${hyprVars.colorpicker}"
              "${hyprVars.mainMod}, C, killactive,"
              "${hyprVars.mainMod} SHIFT, C, exit,"
              "${hyprVars.mainMod}, G, togglegroup,"
              "${hyprVars.mainMod}, Tab, changegroupactive, +1"
              "${hyprVars.mainMod} SHIFT, Tab, changegroupactive, -1"
              "${hyprVars.mainMod}, O, togglefloating,"
              "${hyprVars.mainMod}, H, togglesplit," # dwindle
              "${hyprVars.mainMod}, Y, exec, hyprlock"
              ''${hyprVars.mainMod}, S, exec, IMG=~/screenshot/$(date +%Y-%m-%d_%H-%m-%s).png && grim -g "$(slurp)" $IMG && wl-copy < $IMG''
              ''${hyprVars.mainMod}, F, exec, hyprctl clients -j | jq -r '.[] | "\(.address)\t\(.workspace.id)\t\(.title)"' | rofi -dmenu -p "Address | Workspace | Title" | cut -f 1 | xargs -r -I {} hyprctl dispatch focuswindow address:{}''

              "${hyprVars.mainMod}, left, movefocus, l"
              "${hyprVars.mainMod}, H, movefocus, l"
              "${hyprVars.mainMod}, right, movefocus, r"
              "${hyprVars.mainMod}, L, movefocus, r"
              "${hyprVars.mainMod}, up, movefocus, u"
              "${hyprVars.mainMod}, K, movefocus, u"
              "${hyprVars.mainMod}, down, movefocus, d"
              "${hyprVars.mainMod}, J, movefocus, d"

              "${hyprVars.mainMod}, 1, workspace, 1"
              "${hyprVars.mainMod}, 2, workspace, 2"
              "${hyprVars.mainMod}, 3, workspace, 3"
              "${hyprVars.mainMod}, 4, workspace, 4"
              "${hyprVars.mainMod}, 5, workspace, 5"
              "${hyprVars.mainMod}, 6, workspace, 6"
              "${hyprVars.mainMod}, 7, workspace, 7"
              "${hyprVars.mainMod}, 8, workspace, 8"
              "${hyprVars.mainMod}, 9, workspace, 9"
              "${hyprVars.mainMod}, 0, workspace, 10"

              "${hyprVars.mainMod} SHIFT, 1, movetoworkspace, 1"
              "${hyprVars.mainMod} SHIFT, 2, movetoworkspace, 2"
              "${hyprVars.mainMod} SHIFT, 3, movetoworkspace, 3"
              "${hyprVars.mainMod} SHIFT, 4, movetoworkspace, 4"
              "${hyprVars.mainMod} SHIFT, 5, movetoworkspace, 5"
              "${hyprVars.mainMod} SHIFT, 6, movetoworkspace, 6"
              "${hyprVars.mainMod} SHIFT, 7, movetoworkspace, 7"
              "${hyprVars.mainMod} SHIFT, 8, movetoworkspace, 8"
              "${hyprVars.mainMod} SHIFT, 9, movetoworkspace, 9"
              "${hyprVars.mainMod} SHIFT, 0, movetoworkspace, 10"

              "${hyprVars.mainMod}, mouse_down, workspace, e+1"
              "${hyprVars.mainMod}, mouse_up, workspace, e-1"
            ];

            bindm = [
              "${hyprVars.mainMod}, mouse:272, movewindow"
              "${hyprVars.mainMod}, mouse:273, resizewindow"
            ];

            /*
            # Laptop multimedia keys for volume and LCD brightness
            bindel = ,XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+
            bindel = ,XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-
            bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
            bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
            bindel = ,XF86MonBrightnessUp, exec, current=$(ddcutil getvcp 10 | grep -Po '(?<=current value =    )\d+'); new=$((current + 10)); [ $new -gt 100 ] && new=100; ddcutil setvcp 10 $new
            bindel = ,XF86MonBrightnessDown, exec, current=$(ddcutil getvcp 10 | grep -Po '(?<=current value =    )\d+'); new=$((current - 10)); [ $new -lt 0 ] && new=0; ddcutil setvcp 10 $new
            bindl =, XF86AudioPlay, exec, playerctl play-pause # the stupid key is called play , but it toggles
            # bindl =, XF86AudioNext, exec, playerctl next
            bindl =, XF86AudioNext, exec, playerctl position 5+
            # bindl =, XF86AudioPrev, exec, playerctl previous
            bindl =, XF86AudioPrev, exec, playerctl position 5-
            # bindl =, XF86Calculator, exec,
            */

            windowrulev2 = [
              "suppressevent maximize, class:.*"
            ];
          };
        };
        programs.hyprlock = {
          enable = true;
          settings = {};
        };
        services.hypridle = {
          enable = true;
          settings = {
            general = {
              lock_cmd = "pidof hyprlock || hyprlock";
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = "hyprctl dispatch dpms on";
            };

            listener = [
              {
                timeout = 150;
                on-timeout = "brightnessctl -s set 10";
                on-resume = "brightnessctl -r";
              }

              {
                timeout = 150;
                on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
                on-resume = "brightnessctl -rd rgb:kbd_backlight";
              }

              {
                timeout = 300;
                on-timeout = "loginctl lock-session";
              }

              {
                timeout = 330;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
              }

              {
                timeout = 1800;
                on-timeout = "systemctl suspend";
              }
            ];
          };
        };
      };
    })
  ];
}
