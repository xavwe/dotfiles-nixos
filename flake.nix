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

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ndg = {
      url = "github:feel-co/ndg";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal.follows = "astal";
    };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    nixos-cli = {
      url = "github:nix-community/nixos-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    # Import local lib functions independently from Git
    localLib = import ./src/lib {inherit (nixpkgs) lib;};

    # The `mkSystem` function is imported from `./src/lib/mkSystem.nix`.
    # It takes `nixpkgs`, `localLib`, and `inputs` as arguments and returns a function
    # that can be used to build NixOS system configurations or generator packages.
    mkSystem = import ./src/lib/mkSystem.nix {inherit nixpkgs inputs localLib;};
  in {
    formatter."x86_64-linux" = nixpkgs.legacyPackages."x86_64-linux".alejandra;

    apps.x86_64-linux = {
      test = let
        script = nixpkgs.legacyPackages."x86_64-linux".writeShellScriptBin "test" ''
          #!/usr/bin/env sh
          echo "Validating Renovate configuration..."
          ${nixpkgs.legacyPackages."x86_64-linux".renovate}/bin/renovate-config-validator .renovate-ci.json
          echo "Running nix flake check..."
          nix flake check .
        '';
      in {
        type = "app";
        program = "${script}/bin/test";
        meta.description = "A test app to run nix flake check and validate Renovate config";
      };

      secret = let
        script = nixpkgs.legacyPackages."x86_64-linux".writeShellScriptBin "secret" ''
          #!/usr/bin/env sh
          sops ./src/secrets.yaml
        '';
      in {
        type = "app";
        program = "${script}/bin/secret";
        meta.description = "A test";
      };

      format = let
        script = nixpkgs.legacyPackages."x86_64-linux".writeShellScriptBin "format" ''
          #!/usr/bin/env sh
          nix fmt -- -q .
        '';
      in {
        type = "app";
        program = "${script}/bin/format";
        meta.description = "A test";
      };

      deploy = let
        script = nixpkgs.legacyPackages."x86_64-linux".writeShellScriptBin "deploy" ''
          #!/usr/bin/env sh
          set -eu
          if [ "$#" -ne 2 ]; then
              echo "Usage: nix run .#deploy -- <switch|boot|test|build> <hostname>"
              exit 1
          fi
          if command -v nom >/dev/null 2>&1; then
            nixos-rebuild "$1" --flake path:.#$2 2>&1 | nom
          else
            nixos-rebuild "$1" --flake path:.#$2
          fi
        '';
      in {
        type = "app";
        program = "${script}/bin/deploy";
        meta.description = "A wrapper around nixos-rebuild to deploy a configuration.";
      };
    };

    devShells."x86_64-linux".default = nixpkgs.legacyPackages."x86_64-linux".mkShell {
      packages = with nixpkgs.legacyPackages."x86_64-linux"; [
        sops
        renovate
        ags

        navi

        # Nix
        nixd
        alejandra
        tree-sitter-grammars.tree-sitter-nix
      ];
      shellHook = ''
        NAVI_PATH_NEW="$NAVI_PATH:$(navi info cheats-path):$(pwd)"
        config_path="''${NAVI_CONFIG:-$HOME/.config/navi/config.yaml}"
        if [ -f "$config_path" ]; then
          cheats_paths=$(nix run nixpkgs#yq -- -r '.cheats.paths | join(":")' "$config_path" 2>/dev/null || true)
          if [ -n "$cheats_paths" ]; then
            NAVI_PATH_NEW="$NAVI_PATH_NEW:$cheats_paths"
          fi
        fi
        export NAVI_PATH=$(echo "$NAVI_PATH_NEW" | tr ':' '\n' | awk '!seen[$0]++' | tr '\n' ':' | sed 's/:$//')
      '';
    };

    nixosConfigurations = {
      newton-desktop = mkSystem {
        profile = "desktop";
        hardware = "newton";
      };
      newton-minimal = mkSystem {
        profile = "minimal";
        hardware = "newton";
      };

      infomaniak-server = mkSystem {
        profile = "server";
        hardware = "infomaniak";
      };
    };

    packages.x86_64-linux = {
      # iso-desktop = mkSystem {
      #   profile = "desktop";
      #   hardware = "iso";
      #   format = "iso";
      # };
      # iso-minimal = mkSystem {
      #   profile = "minimal";
      #   hardware = "iso";
      #   format = "iso";
      # };
      nvim = let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};

        # Create a minimal system with just neovim enabled
        overlays = import ./src/overlays {inherit inputs;};
        neovimSystem = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs overlays;
            lib = nixpkgs.lib // localLib;
          };
          modules = [
            inputs.home-manager.nixosModules.home-manager
            ./src/modules/neovim.nix
            {
              nixpkgs.overlays = [
                overlays.stable-packages
                overlays.packages
                overlays.unfree-packages
              ];
            }
            {
              modules.neovim.enable = true;
              users.users.nu.isNormalUser = true;
              home-manager.users.nu = {
                imports = [
                  inputs.nvf.homeManagerModules.default
                ];
                home = {
                  stateVersion = "23.11";
                  homeDirectory = "/home/nu";
                };
              };
            }
          ];
        };
      in
        neovimSystem.config.home-manager.users.nu.programs.nvf.finalPackage;

      docs = let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in
        inputs.ndg.packages.${system}.ndg-builder.override {
          title = "Newton's NixOS Configuration";
          inputDir = ./docs;

          # Document all custom modules
          rawModules =
            builtins.filter (path: builtins.baseNameOf path != "default.nix")
            (nixpkgs.lib.filesystem.listFilesRecursive ./src/modules);

          optionsDepth = 2;
        };
    };

    lib = localLib;
  };
}
