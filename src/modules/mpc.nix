# ncmpcpp extra file
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
  environment.sessionVariables = lib.mkMerge [
    {
      MPD_PORT = "6600";
    }
  ];
  home-manager.users.nu = {pkgs, ...}: {
    home.packages = [pkgs.mpc-cli];
  };
}