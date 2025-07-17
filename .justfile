[private]
default:
  just --list

update:
  nix flake update

check:
  nix flake check .

upgrade TYPE HOST:
  #!/usr/bin/env bash
  if command -v nom >/dev/null 2>&1; then
    nixos-rebuild {{TYPE}} --flake path:.#{{HOST}} 2>&1 | nom
  else
    nixos-rebuild {{TYPE}} --flake path:.#{{HOST}}
  fi

secret:
  sops ./src/secrets.yaml

list:
  nix flake show

gc:
  nix-store --gc

format:
  nix fmt -- -q .
  stylua .

docs:
  nix build .#docs
  @echo "Documentation built in ./result/"

nvim:
  nix run .#nvim