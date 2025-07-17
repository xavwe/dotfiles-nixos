{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.dotfiles.container-engine = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable container engine configuration";
    };
    default = lib.mkOption {
      type = lib.types.str;
      default = "podman";
      description = "Default container engine";
    };
    podman = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use podman";
      };
    };
  };

  config = lib.mkIf config.dotfiles.container-engine.enable {
    # Map new structure to old module options for backward compatibility
    modules.podman = {
      enable = config.dotfiles.container-engine.podman.enable;
      default = config.dotfiles.container-engine.default == "podman";
    };
  };
}
