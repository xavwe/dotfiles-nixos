# This function builds a NixOS system configuration or a generator package.
# It is parameterized by profile and hardware, and optionally by system and format.
{
  nixpkgs,
  inputs,
  localLib,
}: ({
  profile,
  hardware,
  system ? "x86_64-linux",
  format ? null,
}: let
  systemConfig = {
    specialArgs = {
      inherit inputs;
      lib = nixpkgs.lib // localLib;
      overlays = import ../overlays {inherit inputs;};
    };
    modules = [
      ../modules
      ../profiles/${profile}.nix
      ../hardware/${hardware}.nix
      ../colorschemes
      inputs.disko.nixosModules.disko
      inputs.sops-nix.nixosModules.sops
      inputs.home-manager.nixosModules.home-manager
      inputs.nixos-cli.nixosModules.nixos-cli
      {
        home-manager.users.nu = {
          imports = [
            inputs.nvf.homeManagerModules.default
            inputs.ags.homeManagerModules.default
          ];
        };
      }
    ];
  };
in
  # If format is null, build a nixosSystem, otherwise a generator package.
  if format == null
  then nixpkgs.lib.nixosSystem systemConfig
  else inputs.nixos-generators.nixosGenerate (systemConfig // {inherit system format;}))
