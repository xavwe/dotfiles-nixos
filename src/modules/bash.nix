{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  stylix,
  ...
}: {
  options.modules.bash = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use bash";
    };
    default = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Make bash default";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.bash.enable {
      home-manager.users.nu = {...}: {
        programs.direnv.enableBashIntegration = lib.mkIf config.modules.direnv.enable true;
        programs.bash.enable = true;
      };
    })

    (lib.mkIf config.modules.bash.default {
      users.users.nu.shell = pkgs.bash;
    })
  ];
}
