{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  stylix,
  ...
}: {
  home-manager.users.nu = {...}: {
    programs.direnv.enableBashIntegration = lib.mkIf config.modules.direnv.enable true;
  };
}
