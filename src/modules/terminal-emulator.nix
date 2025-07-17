{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.dotfiles.terminal-emulator = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable terminal emulator configuration";
    };
    default = lib.mkOption {
      type = lib.types.str;
      default = "foot";
      description = "Default terminal emulator";
    };
    foot = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use foot";
      };
    };
  };

  config = lib.mkIf config.dotfiles.terminal-emulator.enable {
    # Map new structure to old module options for backward compatibility
    modules.foot = {
      enable = config.dotfiles.terminal-emulator.foot.enable;
      default = config.dotfiles.terminal-emulator.default == "foot";
    };
  };
}
