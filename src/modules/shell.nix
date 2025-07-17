{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.dotfiles.shell = {
    default = lib.mkOption {
      type = lib.types.str;
      default = "zsh";
      description = "Default shell";
    };
    zsh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use zsh";
      };
    };
    bash = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use bash";
      };
    };
  };

  config = {
    # Map new structure to old module options for backward compatibility
    modules.zsh = {
      enable = config.dotfiles.shell.zsh.enable;
      default = config.dotfiles.shell.default == "zsh";
    };
    modules.bash = {
      enable = config.dotfiles.shell.bash.enable;
      default = config.dotfiles.shell.default == "bash";
    };
  };
}
