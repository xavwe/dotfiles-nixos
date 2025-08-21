{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  home-manager,
  overlays,
  sops-nix,
  ...
}: {
  home-manager.users.nu = {
    programs.ags = {
      enable = true;
      configDir = ../ressources/ags;
    };
  };
}
