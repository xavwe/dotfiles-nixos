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
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      nixway.flake = inputs.nixway;
      dev.flake = inputs.dev-templates;
    };
    package = pkgs.nixVersions.stable;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  nixpkgs = {
    overlays = [
      overlays.stable-packages
      overlays.packages
    ];
    config = {
      allowUnfree = true;
      system = "x86_64-linux";
    };
  };
}
