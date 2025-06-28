[private]
default:
  just --list

update:
  nix flake update --flake ./src

check:
  nix flake check ./src

upgrade TYPE HOST:
  #!/usr/bin/env bash
  if command -v nom >/dev/null 2>&1; then
    nixos-rebuild {{TYPE}} --flake path:./src#{{HOST}} 2>&1 | nom
  else
    nixos-rebuild {{TYPE}} --flake path:./src#{{HOST}}
  fi

secret:
  sops ./src/secrets.yaml

list:
  nix flake show

gc:
  nix-store --gc

format:
  nix fmt -- .