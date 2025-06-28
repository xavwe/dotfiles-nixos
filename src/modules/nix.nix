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
  sops.secrets.github = {};
  sops.templates.nix-tokens.content = ''
    access-tokens = github.com=${config.sops.placeholder."github"}
  '';
  system.activationScripts.injectNixConfig.text = ''
    mkdir -p /home/nu/.config/nix
    cat ${config.sops.templates.nix-tokens.path} >> /home/nu/.config/nix/nix.conf
  '';

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
