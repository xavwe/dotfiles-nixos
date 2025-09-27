{
  config,
  pkgs,
  lib,
  inputs,
  home-manager,
  ...
}: {
  options.modules.niri = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use niri";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.niri.enable {
      services.dbus.enable = true;

      environment.sessionVariables = lib.mkMerge [
        {
          WLR_NO_HARDWARE_CURSORS = "1";
          NIXOS_OZONE_WL = "1";
        }
      ];

      programs.niri.enable = true;
      programs.hyprlock.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ];
        config.common.default = "*";
      };

      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          hyprpicker
          xdg-utils
          capitaine-cursors
          mako
          libnotify
          xwayland-satellite
        ];
        programs.wayprompt.enable = true;
        home.file.".config/mako/config".text = ''
          font= monospace 10
          background-color=#000000FF
          padding=10
          border-size=2
          border-color=#9F9F9FFF
          margin=18
          border-radius=10
          max-icon-size=52
          sort=-time
          layer=overlay
          default-timeout=5000
          ignore-timeout=1
          format=<b>%s</b>\n%b1

          [urgency=high]
          border-color=#bf616a
          default-timeout=0
        '';
        home.file.".config/hypr/hyprlock.conf".text = ''
          $font = Monospace

          general {
              hide_cursor = false
              # fail_timeout = 10
          }

          animations {
              enabled = false
          }

          background {
              monitor =
              blur_passes = 3
          }

          input-field {
              monitor =
              size = 20%, 5%
              outline_thickness = 2
              inner_color = rgba(0, 0, 0, 0.0) # no fill

              outer_color = rgba(33ccffee)
              check_color = rgba(00ff99ee)
              fail_color = rgba(ff6633ee)

              font_color = rgb(143, 143, 143)
              fade_on_empty = false
              rounding = 15

              font_family = $font
              placeholder_text = Input password...
              fail_text = $PAMFAIL

              # fade_timeout = 10

              # uncomment to use a letter instead of a dot to indicate the typed password
              # dots_text_format = *
              # dots_size = 0.4
              dots_spacing = 0.3

              position = 0, -25
              halign = center
              valign = center
          }

          # TIME
          label {
              monitor =
              text = $TIME # ref. https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/#variable-substitution
              font_size = 90
              font_family = $font

              position = 0, 75
              halign = center
              valign = center
          }

          # DATE
          label {
              monitor =
              text = cmd[update:60000] date +"%A, %d %B %Y" # update every 60 seconds
              font_size = 25
              font_family = $font

              position = 0, 175
              halign = center
              valign = center
          }
        '';
        home.file.".config/niri/config.kdl".text = ''
          input {
              keyboard {
                  xkb {
                      layout "eu"
                      options "caps:escape"
                  }
                  numlock
              }
              warp-mouse-to-focus
              focus-follows-mouse
          }

          cursor {
              xcursor-theme "capitaine-cursors"
              xcursor-size 20

              hide-when-typing
              hide-after-inactive-ms 1000
          }

          prefer-no-csd

          spawn-at-startup "mako"

          layout {
              gaps 20
              center-focused-column "always"
              background-color "#000000"
              preset-column-widths {
                  proportion 0.33333
                  proportion 0.5
                  proportion 0.66667
              }
              default-column-width { proportion 0.8; }
              focus-ring {
                  off
              }
              border {
                  width 2
                  active-color "#595959"
                  inactive-color "#595959"
                  urgent-color "#9b0000"
              }
          }

          hotkey-overlay {
              skip-at-startup
              hide-not-bound
          }

          screenshot-path "~/screenshot/%Y-%m-%d_%H-%M-%S.png"

          window-rule {
              match app-id=r#"firefox$"# title="^Picture-in-Picture$"
              open-floating true
          }

          window-rule {
              geometry-corner-radius 10
              clip-to-geometry true
          }

          window-rule {
              match is-active=false
              opacity 0.75
          }

          clipboard {
            disable-primary
          }

          binds {
              // Mod-Shift-/, which is usually the same as Mod-?,
              Mod+Shift+Slash { show-hotkey-overlay; }

              Mod+Q hotkey-overlay-title="open terminal emulator" { spawn-sh "foot --working-directory ~"; }
              Mod+W hotkey-overlay-title="open web browser" { spawn "firefox"; }
              Mod+Shift+W hotkey-overlay-title="open private web browser" { spawn "tor-browser"; }
              // TODO: virtmanager, audiomanager, screenshot

              Mod+Space hotkey-overlay-title="show launcher" { spawn-sh "rofi-launcher"; }

              // Mod+O hotkey-overlay-title="colorpicker" { spawn-sh "hyprpicker | tr -d \'\\n\' | wl-copy"; }

              Mod+Y hotkey-overlay-title="lock screen" { spawn "hyprlock"; }

              Mod+D repeat=false { toggle-overview; }

              Mod+C repeat=false { close-window; }

              Mod+Left  { focus-column-left; }
              Mod+Down  { focus-window-down; }
              Mod+Up    { focus-window-up; }
              Mod+Right { focus-column-right; }
              Mod+H     { focus-column-left; }
              Mod+J     { focus-window-down; }
              Mod+K     { focus-window-up; }
              Mod+L     { focus-column-right; }

              Mod+Ctrl+Left  { move-column-left; }
              Mod+Ctrl+Down  { move-window-down; }
              Mod+Ctrl+Up    { move-window-up; }
              Mod+Ctrl+Right { move-column-right; }
              Mod+Ctrl+H     { move-column-left; }
              Mod+Ctrl+J     { move-window-down; }
              Mod+Ctrl+K     { move-window-up; }
              Mod+Ctrl+L     { move-column-right; }

              // Mod+Home { focus-column-first; }
              // Mod+End  { focus-column-last; }
              // Mod+Ctrl+Home { move-column-to-first; }
              // Mod+Ctrl+End  { move-column-to-last; }

              Mod+Page_Down      { focus-workspace-down; }
              Mod+Page_Up        { focus-workspace-up; }
              Mod+U              { focus-workspace-down; }
              Mod+I              { focus-workspace-up; }
              Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
              Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
              Mod+Ctrl+U         { move-column-to-workspace-down; }
              Mod+Ctrl+I         { move-column-to-workspace-up; }

              Mod+Shift+Page_Down { move-workspace-down; }
              Mod+Shift+Page_Up   { move-workspace-up; }
              Mod+Shift+U         { move-workspace-down; }
              Mod+Shift+I         { move-workspace-up; }

              // You can bind mouse wheel scroll ticks using the following syntax.
              // These binds will change direction based on the natural-scroll setting.
              //
              // To avoid scrolling through workspaces really fast, you can use
              // the cooldown-ms property. The bind will be rate-limited to this value.
              // You can set a cooldown on any bind, but it's most useful for the wheel.
              Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
              Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
              Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
              Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

              Mod+WheelScrollRight      { focus-column-right; }
              Mod+WheelScrollLeft       { focus-column-left; }
              Mod+Ctrl+WheelScrollRight { move-column-right; }
              Mod+Ctrl+WheelScrollLeft  { move-column-left; }

              // Usually scrolling up and down with Shift in applications results in
              // horizontal scrolling; these binds replicate that.
              Mod+Shift+WheelScrollDown      { focus-column-right; }
              Mod+Shift+WheelScrollUp        { focus-column-left; }
              Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
              Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

              Mod+1 { focus-workspace 1; }
              Mod+2 { focus-workspace 2; }
              Mod+3 { focus-workspace 3; }
              Mod+4 { focus-workspace 4; }
              Mod+5 { focus-workspace 5; }
              Mod+6 { focus-workspace 6; }
              Mod+7 { focus-workspace 7; }
              Mod+8 { focus-workspace 8; }
              Mod+9 { focus-workspace 9; }
              Mod+Shift+1 { move-column-to-workspace 1; }
              Mod+Shift+2 { move-column-to-workspace 2; }
              Mod+Shift+3 { move-column-to-workspace 3; }
              Mod+Shift+4 { move-column-to-workspace 4; }
              Mod+Shift+5 { move-column-to-workspace 5; }
              Mod+Shift+6 { move-column-to-workspace 6; }
              Mod+Shift+7 { move-column-to-workspace 7; }
              Mod+Shift+8 { move-column-to-workspace 8; }
              Mod+Shift+9 { move-column-to-workspace 9; }

              // Alternatively, there are commands to move just a single window:
              // Mod+Ctrl+1 { move-window-to-workspace 1; }

              // Switches focus between the current and the previous workspace.
              // Mod+Tab { focus-workspace-previous; }

              // The following binds move the focused window in and out of a column.
              // If the window is alone, they will consume it into the nearby column to the side.
              // If the window is already in a column, they will expel it out.
              Mod+BracketLeft  { consume-or-expel-window-left; }
              Mod+BracketRight { consume-or-expel-window-right; }

              // Consume one window from the right to the bottom of the focused column.
              Mod+Comma  { consume-window-into-column; }
              // Expel the bottom window from the focused column to the right.
              Mod+Period { expel-window-from-column; }

              Mod+R { switch-preset-column-width; }
              // Cycling through the presets in reverse order is also possible.
              // Mod+R { switch-preset-column-width-back; }
              Mod+Shift+R { switch-preset-window-height; }
              Mod+Ctrl+R { reset-window-height; }
              Mod+F { maximize-column; }
              Mod+Shift+F { fullscreen-window; }

              // Expand the focused column to space not taken up by other fully visible columns.
              // Makes the column "fill the rest of the space".
              Mod+Ctrl+F { expand-column-to-available-width; }

              // Mod+C { center-column; }

              // Center all fully visible columns on screen.
              Mod+Ctrl+C { center-visible-columns; }

              // Finer width adjustments.
              // This command can also:
              // * set width in pixels: "1000"
              // * adjust width in pixels: "-5" or "+5"
              // * set width as a percentage of screen width: "25%"
              // * adjust width as a percentage of screen width: "-10%" or "+10%"
              // Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
              // set-column-width "100" will make the column occupy 200 physical screen pixels.
              Mod+Minus { set-column-width "-10%"; }
              Mod+Equal { set-column-width "+10%"; }

              // Finer height adjustments when in column with other windows.
              Mod+Shift+Minus { set-window-height "-10%"; }
              Mod+Shift+Equal { set-window-height "+10%"; }

              // Move the focused window between the floating and the tiling layout.
              Mod+V       { toggle-window-floating; }
              Mod+Shift+V { switch-focus-between-floating-and-tiling; }

              // Toggle tabbed column display mode.
              // Windows in this column will appear as vertical tabs,
              // rather than stacked on top of each other.
              // Mod+W { toggle-column-tabbed-display; }

              // Actions to switch layouts.
              // Note: if you uncomment these, make sure you do NOT have
              // a matching layout switch hotkey configured in xkb options above.
              // Having both at once on the same hotkey will break the switching,
              // since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
              // Mod+Space       { switch-layout "next"; }
              // Mod+Shift+Space { switch-layout "prev"; }

              Print { screenshot; }
              Ctrl+Print { screenshot-screen; }
              Alt+Print { screenshot-window; }

              // Applications such as remote-desktop clients and software KVM switches may
              // request that niri stops processing the keyboard shortcuts defined here
              // so they may, for example, forward the key presses as-is to a remote machine.
              // It's a good idea to bind an escape hatch to toggle the inhibitor,
              // so a buggy application can't hold your session hostage.
              //
              // The allow-inhibiting=false property can be applied to other binds as well,
              // which ensures niri always processes them, even when an inhibitor is active.
              Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

              // The quit action will show a confirmation dialog to avoid accidental exits.
              Mod+Shift+C { quit; }
              Ctrl+Alt+Delete { quit; }

              // Powers off the monitors. To turn them back on, do any input like
              // moving the mouse or pressing any other key.
              Mod+Shift+P { power-off-monitors; }
          }
        '';
      };
    })
  ];
}
