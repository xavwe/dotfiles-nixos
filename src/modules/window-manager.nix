{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.dotfiles.window-manager = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable window manager configuration";
    };
    default = lib.mkOption {
      type = lib.types.str;
      default = "hyprland";
      description = "Default window manager";
    };
    hyprland = {
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
  };

  config = lib.mkIf config.dotfiles.window-manager.enable {
    # Map new structure to old module options for backward compatibility
    modules.hyprland = {
      enable = config.dotfiles.window-manager.hyprland.enable;
      xwayland.enable = config.dotfiles.window-manager.hyprland.xwayland.enable;
    };
  };
}
