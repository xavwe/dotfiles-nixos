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
  sops.defaultSopsFile = ../secrets.yaml;
  sops.defaultSopsFormat = "yaml";
}
