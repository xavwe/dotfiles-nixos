{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.dotfiles.editor = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable editor configuration";
    };
    default = lib.mkOption {
      type = lib.types.str;
      default = "neovim";
      description = "Default editor";
    };
    neovim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use neovim";
      };
      manpager = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Make neovim default manpager";
      };
    };
  };

  config = lib.mkIf config.dotfiles.editor.enable {
    # Map new structure to old module options for backward compatibility
    modules.neovim = {
      enable = config.dotfiles.editor.neovim.enable;
      default = config.dotfiles.editor.default == "neovim";
      manpager = config.dotfiles.editor.neovim.manpager;
    };
  };
}
