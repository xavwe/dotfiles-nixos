# Module Reference

This page contains automatically generated documentation for all custom modules in this NixOS configuration.

## Module System

Each module follows a consistent pattern:
- **Enable Flag**: All modules have an `enable` option to activate the module
- **Default Flag**: Some modules have a `default` option to set them as the system default
- **Configuration**: Modules may expose additional options for customization

## Core Concepts

### Profiles
- **Desktop Profile**: Enables GUI applications and desktop environment
- **Minimal Profile**: CLI-only system with essential tools

### Module Organization
Modules are imported via `src/modules/default.nix` and configured in profiles by setting `modules.<name>.enable = true`.

---

*Note: Detailed module options are generated automatically from the Nix module definitions and will appear below when the documentation is built.*