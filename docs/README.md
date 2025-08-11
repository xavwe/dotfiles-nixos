# NixOS Configuration

[![License](https://img.shields.io/github/license/xavwe/dotfiles-nixos?style=for-the-badge)](https://github.com/xavwe/dotfiles-nixos/blob/main/LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/xavwe/dotfiles-nixos?style=for-the-badge)](https://github.com/xavwe/dotfiles-nixos/commits/main)
[![Test](https://img.shields.io/github/actions/workflow/status/xavwe/dotfiles-nixos/test.yml?branch=main&label=Test&style=for-the-badge)](https://github.com/xavwe/dotfiles-nixos/actions/workflows/test.yml)
[![NixOS](https://img.shields.io/badge/Built%20For-NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=white)](https://nixos.org)
[![flake](https://img.shields.io/badge/flake-enabled-blue?style=for-the-badge&logo=nixos)](https://nixos.wiki/wiki/Flakes)


> Personal, modular, and reproducible NixOS configuration, built using Nix flakes.

## Tech Stack

### Core Technologies
- [Nix](https://nix.dev/) - Declarative package management and system configuration
- [NixOS](https://nixos.org/) - Linux distribution built on Nix
- [Nix Flakes](https://nixos.wiki/wiki/Flakes) - Reproducible, composable Nix configurations

### Key Dependencies
- [Home Manager](https://github.com/nix-community/home-manager) - User environment management
- [sops-nix](https://github.com/Mic92/sops-nix) - Secret management with SOPS
- [disko](https://github.com/nix-community/disko) - Declarative disk partitioning
- [NixOS Hardware](https://github.com/NixOS/nixos-hardware) - Hardware-specific configurations
- [nixos-generators](https://github.com/nix-community/nixos-generators) - ISO and image generation

### Applications & Tools
- [nvf](https://github.com/notashelf/nvf) - Neovim configuration framework
- [ndg](https://github.com/feel-co/ndg) - Documentation generator

### Development & CI/CD
- [GitHub Actions](https://github.com/features/actions) - CI/CD
- [Cachix](https://cachix.org/) - Nix binary cache
- [alejandra](https://github.com/kamadorueda/alejandra) - Nix code formatter
- [nixd](https://github.com/nix-community/nixd) - Nix language server
- [direnv](https://direnv.net/) - Environment variable management
- [Claude Code](https://www.anthropic.com/claude-code) - AI-assisted development

### Miscellaneous
- [GitHub Repository Settings](https://github.com/repository-settings/app) - Repository settings in a file

## License

This repository is licensed under the [MIT License](../LICENSE). Feel free to fork and adapt, but attribution is appreciated.

## References

- nix flakes
  - [ryan4yin/nix-config](https://github.com/ryan4yin/nix-config)
- github issue templates
    - [Devam Chaudhari - Streamline Your GitHub Issues](https://dev.to/chaudharidevam/streamline-your-github-issues-custom-issue-templates-made-easy-4mge)
