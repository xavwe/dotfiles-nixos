{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.dotfiles.reverse-proxy = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable reverse proxy configuration";
    };
    default = lib.mkOption {
      type = lib.types.str;
      default = "traefik";
      description = "Default reverse proxy";
    };
    traefik = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use traefik";
      };
    };
    nginx-reverse-proxy = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use nginx as reverse proxy";
      };
    };
  };

  config = lib.mkIf config.dotfiles.reverse-proxy.enable {
    # Map new structure to old module options for backward compatibility
    modules.traefik = {
      enable = config.dotfiles.reverse-proxy.traefik.enable;
      default = config.dotfiles.reverse-proxy.default == "traefik";
    };
    # Note: nginx as reverse proxy - this would need to be handled differently
    # as the current nginx module is a web server, not specifically a reverse proxy
  };
}
