# Development environment

The dev shell includes:
- `sops` - Secret management
- `nixd` - Nix language server
- `alejandra` - Nix formatter
- `tree-sitter-grammars.tree-sitter-nix` - Nix syntax highlighting

## Secret Scanning

This project uses [secretlint](https://github.com/secretlint/secretlint) to prevent accidental commits of secrets and credentials.

### Setup

1. Install Node.js dependencies:
   ```bash
   npm install
   ```

2. Install git hooks (including pre-push hook):
   ```bash
   ./scripts/install-git-hooks.sh
   ```

### Usage

- Run secretlint manually: `npm run secretlint`
- The pre-push hook will automatically run secretlint before each push
- CI/CD pipeline also runs secretlint on all pull requests and pushes to main