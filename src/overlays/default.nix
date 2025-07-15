{inputs, ...}: {
  stable-packages = import ./stable-packages.nix {inherit inputs;};
  packages = import ./packages.nix {inherit inputs;};
  unfree-packages = import ./unfree-packages.nix {inherit inputs;};
}
