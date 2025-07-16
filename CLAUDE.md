# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a modular NixOS configuration repository built with Nix flakes. The architecture follows a layered approach:

- **`flake.nix`**: Main entry point defining inputs, outputs, and system configurations
- **`src/lib/mkSystem.nix`**: Core system builder function that parameterizes configurations by profile and hardware
- **`src/profiles/`**: System profiles (desktop, minimal) that define which modules are enabled
- **`src/modules/`**: Individual feature modules (Firefox, Neovim, Hyprland, etc.) with enable flags
- **`src/hardware/`**: Hardware-specific configurations (newton.nix, iso.nix)
- **`src/colorschemes/`**: Theme definitions (darknight, tokyonight)
- **`src/overlays/`**: Package overlays including unfree packages and stable packages

The configuration uses Home Manager for user-level configuration and SOPS for secrets management.

## Common Commands

Use the `just` task runner for all operations:

```bash
# List available commands
just

# Update flake inputs
just update

# Check flake validity
just check

# Show flake outputs
just list

# Build and switch system configuration
just upgrade switch newton-desktop    # For desktop profile
just upgrade switch newton-minimal    # For minimal profile

# Test configuration without switching
just upgrade test newton-desktop

# Format code
just format

# Garbage collection
just gc

# Edit secrets
just secret
```

## Development Workflow

1. **Module Development**: Create new modules in `src/modules/` following the existing pattern with enable flags
2. **Profile Modification**: Edit profiles in `src/profiles/` to enable/disable modules
3. **Hardware Configuration**: Hardware-specific settings go in `src/hardware/`
4. **Testing**: Always use `just check` before applying changes
5. **Formatting**: Run `just format` to format Nix files with alejandra and Lua files with stylua

## Key Files

- `src/lib/mkSystem.nix`: System builder function - central to understanding how configurations are composed
- `src/modules/default.nix`: Module imports and default configurations
- `src/profiles/desktop.nix` vs `src/profiles/minimal.nix`: Compare to understand module organization
- `flake.nix`: Input sources and system definitions

## Module System

Modules follow a consistent pattern:
- Each module has an `enable` flag
- Some modules have additional options like `default` (to set as system default)
- Modules are imported via `src/modules/default.nix`
- Configuration happens in profiles by setting `modules.<name>.enable = true`

## Build Outputs

- `nixosConfigurations.newton-desktop`: Full desktop system
- `nixosConfigurations.newton-minimal`: Minimal CLI-only system  
- `packages.x86_64-linux.iso-desktop`: Desktop ISO image
- `packages.x86_64-linux.iso-minimal`: Minimal ISO image