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

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    extract = {
      url = "github:xavwe/extract";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixpkgs-stable,
    sops-nix,
    stylix,
    nixway,
    disko,
    nixos-hardware,
    ...
  } @ inputs: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          overlays = import ./overlays {inherit inputs;};
        };
        modules = [
          ./modules
          ./profiles/desktop.nix
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
        ];
      };
      minimal = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          overlays = import ./overlays {inherit inputs;};
        };
        modules = [
          ./modules
          ./profiles/minimal.nix
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
        ];
      };
    };
  };
}
