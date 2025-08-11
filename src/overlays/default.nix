{inputs, ...}: {
  stable-packages = import ./stable-packages.nix {inherit inputs;};
  packages = import ./packages.nix {inherit inputs;};
  unfree-packages = import ./unfree-packages.nix {inherit inputs;};
  fix-packages = import ./fix-packages.nix {inherit inputs;};
  firefox-addons = import ./firefox-addons.nix {inherit inputs;};
}
