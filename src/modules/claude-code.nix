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
    unfree.claude-code
  ];
}
