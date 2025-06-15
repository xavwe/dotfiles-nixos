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
  # remove unecessary preinstalled packages
  environment.defaultPackages = [];
  programs.nano.enable = false;

  # misc
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs;};
    users.nu.home.stateVersion = "25.05";
    backupFileExtension = "backup";
  };
  system.stateVersion = "25.05";
}
