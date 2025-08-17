# find . -type f | vidir -
# vidir
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
  home-manager.users.nu = {...}: {
    home.packages = with pkgs; [
      perl540Packages.vidir
    ];
  };
}
