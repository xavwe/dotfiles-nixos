# alias grep to rg

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
    ripgrep
  ];
}