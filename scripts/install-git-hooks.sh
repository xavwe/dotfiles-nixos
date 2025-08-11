#!/usr/bin/env bash

# Script to install git hooks

set -e

echo "🔧 Installing git hooks..."

# Get the git directory (works with worktrees)
GIT_DIR=$(git rev-parse --git-dir)

# Create hooks directory if it doesn't exist
mkdir -p "$GIT_DIR/hooks"

# Install pre-push hook
cp scripts/git-hooks/pre-push "$GIT_DIR/hooks/pre-push"
chmod +x "$GIT_DIR/hooks/pre-push"

echo "✅ Git hooks installed successfully!"
echo "   Pre-push hook will now run secretlint before each push."