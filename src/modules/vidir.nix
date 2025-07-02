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
  environment.systemPackages = with pkgs; [
    perl540Packages.vidir
  ];
}
