# Commands

- `nix run path:.#test` - Run flake check to validate configuration
- `nix run path:.#format` - Format Nix code using alejandra formatter
- `nix run path:.#secret` - Edit secrets using sops
- `nix run path:.#secretlint` - Check for accidential commits of secrets and credentials
- `nix run path:.#deploy -- <switch|boot|test|build> <newton-desktop|newton-minimal>` - Deploy configuration to system

## Available Configurations
- `newton-desktop` - Full desktop environment with GUI applications
- `newton-minimal` - Minimal server configuration without GUI

## Building
- `nix build path:.#nvim` - Build standalone neovim package
- `nix build path:.#docs` - Build documentation using ndg