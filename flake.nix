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
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    # The `mkSystem` function is imported from `./src/lib/mkSystem.nix`.
    # It takes `nixpkgs`, `self`, and `inputs` as arguments and returns a function
    # that can be used to build NixOS system configurations or generator packages.
    mkSystem = import ./src/lib/mkSystem.nix {inherit nixpkgs self inputs;};
  in {
    formatter."x86_64-linux" = nixpkgs.legacyPackages."x86_64-linux".alejandra;

    devShells."x86_64-linux".default = nixpkgs.legacyPackages."x86_64-linux".mkShell {
      packages = with nixpkgs.legacyPackages."x86_64-linux"; [
        just
        sops

        # Lua
        lua-language-server
        stylua
        tree-sitter-grammars.tree-sitter-lua

        # Nix
        nixd
        alejandra
        tree-sitter-grammars.tree-sitter-nix
      ];
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
    };

    packages.x86_64-linux = {
      iso-desktop = mkSystem {
        profile = "desktop";
        hardware = "iso";
        format = "iso";
      };
      iso-minimal = mkSystem {
        profile = "minimal";
        hardware = "iso";
        format = "iso";
      };
      nvim = let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};

        # Create a minimal system with just neovim enabled
        overlays = import ./src/overlays {inherit inputs;};
        neovimSystem = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs overlays;
            lib = nixpkgs.lib // self.lib;
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
                imports = [inputs.nvf.homeManagerModules.default];
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
          rawModules = [
            ./src/modules/bash.nix
            ./src/modules/btop.nix
            ./src/modules/chafa.nix
            ./src/modules/claude-code.nix
            ./src/modules/colors.nix
            ./src/modules/dark-mode.nix
            ./src/modules/direnv.nix
            ./src/modules/distrobox.nix
            ./src/modules/doas.nix
            ./src/modules/extract.nix
            ./src/modules/fastfetch.nix
            ./src/modules/firefox.nix
            ./src/modules/foot.nix
            ./src/modules/fzf.nix
            ./src/modules/gh.nix
            ./src/modules/git.nix
            ./src/modules/gpg.nix
            ./src/modules/hyprland.nix
            ./src/modules/jujutsu.nix
            ./src/modules/just.nix
            ./src/modules/kanata.nix
            ./src/modules/libreoffice.nix
            ./src/modules/links-browser.nix
            ./src/modules/mpv.nix
            ./src/modules/neovim.nix
            ./src/modules/newsboat.nix
            ./src/modules/nginx.nix
            ./src/modules/nix-output-monitor.nix
            ./src/modules/nvd.nix
            ./src/modules/pass.nix
            ./src/modules/podman.nix
            ./src/modules/scrcpy.nix
            ./src/modules/ssh.nix
            ./src/modules/starship.nix
            ./src/modules/sudo.nix
            ./src/modules/tldr.nix
            ./src/modules/traefik.nix
            ./src/modules/virt-manager.nix
            ./src/modules/wakatime.nix
            ./src/modules/wl-clipboard.nix
            ./src/modules/yazi.nix
            ./src/modules/zathura.nix
            ./src/modules/zoxide.nix
            ./src/modules/zsh.nix
          ];

          optionsDepth = 2;
        };
    };

    lib = import ./src/lib {inherit (nixpkgs) lib;};
  };
}