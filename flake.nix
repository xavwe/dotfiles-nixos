{
  description = "my nixos config";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-24.05";
    };

    nixway = {
      url = "github:the-nix-way/dev-templates";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dev-templates = {
      url = "github:xavwe/dev-templates";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    extract = {
      url = "github:xavwe/extract";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixpkgs-stable,
    sops-nix,
    nixway,
    disko,
    nixos-hardware,
    nixos-generators,
    ...
  } @ inputs: {
    formatter."x86_64-linux" = nixpkgs.legacyPackages."x86_64-linux".alejandra;
    devShells."x86_64-linux".default = nixpkgs.legacyPackages."x86_64-linux".mkShell {
      packages = with nixpkgs.legacyPackages."x86_64-linux"; [
        just
        sops
        stylua
      ];
    };

    nixosConfigurations = {
      newton-desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          lib = nixpkgs.lib // self.lib; # Merge nixpkgs.lib with custom lib
          overlays = import ./src/overlays {inherit inputs;};
        };
        modules = [
          ./src/modules
          ./src/profiles/desktop.nix
          ./src/hardware/newton.nix
          ./src/colorschemes
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
        ];
      };
      newton-minimal = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          lib = nixpkgs.lib // self.lib; # Merge nixpkgs.lib with custom lib
          overlays = import ./src/overlays {inherit inputs;};
        };
        modules = [
          ./src/modules
          ./src/profiles/minimal.nix
          ./src/hardware/newton.nix
          ./src/colorschemes
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
        ];
      };
    };
    packages.x86_64-linux = {
      iso-desktop = nixos-generators.nixosGenerate {
        specialArgs = {
          inherit inputs;
          lib = nixpkgs.lib // self.lib; # Merge nixpkgs.lib with custom lib
          overlays = import ./src/overlays {inherit inputs;};
        };
        system = "x86_64-linux";
        modules = [
          ./src/modules
          ./src/profiles/desktop.nix
          ./src/hardware/iso.nix
          ./src/colorschemes
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
        ];
        format = "iso";
      };
      iso-minimal = nixos-generators.nixosGenerate {
        specialArgs = {
          inherit inputs;
          lib = nixpkgs.lib // self.lib; # Merge nixpkgs.lib with custom lib
          overlays = import ./src/overlays {inherit inputs;};
        };
        system = "x86_64-linux";
        modules = [
          ./src/modules
          ./src/profiles/minimal.nix
          ./src/hardware/iso.nix
          ./src/colorschemes
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
        ];
        format = "iso";
      };
    };

    lib = import ./src/lib {inherit (nixpkgs) lib;};
  };
}
