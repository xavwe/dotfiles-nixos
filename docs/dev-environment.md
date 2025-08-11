# Development environment

The dev shell includes:
- `sops` - Secret management
- `nixd` - Nix language server
- `alejandra` - Nix formatter
- `tree-sitter-grammars.tree-sitter-nix` - Nix syntax highlighting

## Secret Scanning

This project uses [gitleaks](https://github.com/gitleaks/gitleaks) to prevent accidental commits of secrets and credentials.

### Setup

1. Enter the development shell (gitleaks will be available):
   ```bash
   nix develop
   ```

2. Install git hooks (including pre-push hook):
   ```bash
   ./scripts/install-git-hooks.sh
   ```

### Usage

- Run secret scanning manually: `nix run .#secretlint` (uses gitleaks under the hood)
- Available in dev shell: `gitleaks detect --verbose`
- The pre-push hook will automatically run gitleaks before each push
- CI/CD pipeline also runs gitleaks on all pull requests and pushes to main