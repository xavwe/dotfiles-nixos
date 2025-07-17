# Newton's NixOS Configuration

A modular NixOS configuration built with Nix flakes, featuring a clean architecture and comprehensive module system.

## Architecture

This configuration follows a layered approach:

- **Flake Entry Point**: `flake.nix` defines inputs, outputs, and system configurations
- **System Builder**: `src/lib/mkSystem.nix` parameterizes configurations by profile and hardware
- **Profiles**: `src/profiles/` define which modules are enabled (desktop vs minimal)
- **Modules**: `src/modules/` contain individual feature configurations with enable flags
- **Hardware**: `src/hardware/` contains hardware-specific configurations
- **Themes**: `src/colorschemes/` define visual themes

## Quick Start

```bash
# List available commands
just

# Build and switch system configuration
just upgrade switch newton-desktop    # For desktop profile
just upgrade switch newton-minimal    # For minimal profile

# Test configuration without switching
just upgrade test newton-desktop

# Update flake inputs
just update

# Format code
just format
```

## Module System

All modules follow a consistent pattern with enable flags. Configuration happens in profiles by setting `modules.<name>.enable = true`.

### Available Modules

See the [Module Reference](modules.md) for detailed information about each module's options and configuration.

## Development

1. **Module Development**: Create new modules in `src/modules/` following existing patterns
2. **Profile Modification**: Edit profiles in `src/profiles/` to enable/disable modules  
3. **Hardware Configuration**: Hardware-specific settings go in `src/hardware/`
4. **Testing**: Always use `just check` before applying changes
5. **Formatting**: Run `just format` to format Nix and Lua files

## Build Outputs

- `nixosConfigurations.newton-desktop`: Full desktop system
- `nixosConfigurations.newton-minimal`: Minimal CLI-only system
- `packages.x86_64-linux.iso-desktop`: Desktop ISO image
- `packages.x86_64-linux.iso-minimal`: Minimal ISO image
- `packages.x86_64-linux.docs`: This documentation