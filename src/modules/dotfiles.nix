{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./window-manager.nix
    ./shell.nix
    ./browser.nix
    ./terminal-emulator.nix
    ./editor.nix
    ./container-engine.nix
    ./reverse-proxy.nix
  ];

  options.dotfiles = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable dotfiles configuration";
    };
    locales = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "Default locale";
    };
    theme = lib.mkOption {
      type = lib.types.str;
      default = "darknight";
      description = "Color theme";
    };
  };

  config = lib.mkIf config.dotfiles.enable {
    # Map global settings to existing module options
    modules.colors.theme = config.dotfiles.theme;

    # Set locale (this would need to be handled in the locale module)
    # i18n.defaultLocale = config.dotfiles.locales;
  };
}
