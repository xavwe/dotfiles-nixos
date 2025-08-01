# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a modular NixOS configuration built with Nix flakes. It uses a custom system builder function and modular architecture to create reproducible, declarative system configurations.

## Commands

- `nix run path:.#test` - Run flake check to validate configuration
- `nix run path:.#format` - Format Nix code using alejandra formatter
- `nix run path:.#secret` - Edit secrets using sops
- `nix run path:.#deploy -- <switch|boot|test|build> <newton-desktop|newton-minimal>` - Deploy configuration to system

### Available Configurations
- `newton-desktop` - Full desktop environment with GUI applications
- `newton-minimal` - Minimal server configuration without GUI

### Package Building
- `nix build path:.#nvim` - Build standalone neovim package
- `nix build path:.#docs` - Build documentation using ndg

## Architecture

### Core Structure
- `flake.nix` - Main flake definition with inputs, outputs, and system configurations
- `src/lib/mkSystem.nix` - System builder function that creates NixOS configurations
- `src/modules/` - Individual feature modules (can be enabled/disabled per profile)
- `src/profiles/` - System profiles (desktop.nix, minimal.nix) that enable module combinations
- `src/hardware/` - Hardware-specific configurations
- `src/overlays/` - Package overlays for stable, packages, and unfree packages
- `src/colorschemes/` - Color scheme definitions

### Module System
Each module in `src/modules/` follows the pattern:
- Declares options under `modules.<name>`
- Can be enabled with `modules.<name>.enable = true`
- Modules are imported via `src/modules/default.nix`
- Profiles enable specific module combinations

### Key Inputs
- `nixpkgs` - Main package repository (unstable)
- `nixpkgs-stable` - Stable package repository (24.05)
- `home-manager` - User environment management
- `sops-nix` - Secret management
- `disko` - Disk partitioning
- `nvf` - Neovim configuration framework

### System Building
The `mkSystem` function:
- Takes `profile`, `hardware`, and optionally `system`/`format` parameters
- Combines modules, profiles, hardware configs, and colorschemes
- Can generate either NixOS systems or installer ISOs

### Secrets Management
- Secrets stored in `src/secrets.yaml`
- Managed with sops-nix
- Edit with `nix run .#secret`

## Development Environment

The dev shell includes:
- `sops` - Secret management
- `nixd` - Nix language server
- `alejandra` - Nix formatter
- `tree-sitter-grammars.tree-sitter-nix` - Nix syntax highlighting