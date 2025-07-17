{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.dotfiles.browser = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable browser configuration";
    };
    default = lib.mkOption {
      type = lib.types.str;
      default = "firefox";
      description = "Default browser";
    };
    firefox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use firefox";
      };
    };
    links = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use links";
      };
    };
  };

  config = lib.mkIf config.dotfiles.browser.enable {
    # Map new structure to old module options for backward compatibility
    modules.firefox = {
      enable = config.dotfiles.browser.firefox.enable;
      default = config.dotfiles.browser.default == "firefox";
    };
    modules.links-browser = {
      enable = config.dotfiles.browser.links.enable;
      default = config.dotfiles.browser.default == "links";
    };
  };
}
