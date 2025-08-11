# Architecture

## Core Structure
- `flake.nix` - Main flake definition with inputs, outputs, and system configurations
- `src/lib/mkSystem.nix` - System builder function that creates NixOS configurations
- `src/modules/` - Individual feature modules (can be enabled/disabled per profile)
- `src/profiles/` - System profiles (desktop.nix, minimal.nix) that enable module combinations
- `src/hardware/` - Hardware-specific configurations
- `src/overlays/` - Package overlays for stable, packages, and unfree packages
- `src/colorschemes/` - Color scheme definitions

## Module System
Each module in `src/modules/` follows the pattern:
- Declares options under `modules.<name>`
- Can be enabled with `modules.<name>.enable = true`
- Modules are imported via `src/modules/default.nix`
- Profiles enable specific module combinations

## Key Inputs
- `nixpkgs` - Main package repository (unstable)
- `nixpkgs-stable` - Stable package repository (24.05)
- `home-manager` - User environment management
- `sops-nix` - Secret management
- `disko` - Disk partitioning
- `nvf` - Neovim configuration framework

## System Building
The `mkSystem` function:
- Takes `profile`, `hardware`, and optionally `system`/`format` parameters
- Combines modules, profiles, hardware configs, and colorschemes
- Can generate either NixOS systems or installer ISOs

## Secrets Management
- Secrets stored in `src/secrets.yaml`
- Managed with sops-nix
- Edit with `nix run .#secret`