# Commit

Create well-formatted commits with conventional commit messages.

## Features:
- Automatically stages files if none are staged
- Uses conventional commit format with descriptive emojis
- Suggests splitting commits for different concerns

## Usage:
- `/commit` - Standard commit

## Commit Types:
- feat: New features
- fix: Bug fixes
- docs: Documentation changes
- refactor: Code restructuring without changing functionality
- style: Code formatting, missing semicolons, etc.
- perf: Performance improvements
- test: Adding or correcting tests
- chore: Tooling, configuration, maintenance
- wip: Work in progress
- remove: Removing code or files
- hotfix: Critical fixes
- security: Security improvements

## Process:
1. Check for staged changes (`git status`)
2. If no staged changes, review and stage appropriate files; If staged changes unstage if they should not be part of the commit.
3. Analyze changes to determine commit type
4. Generate descriptive commit message
5. Include scope if applicable: `type(scope): description`
6. Add body for complex changes explaining why
7. Execute commit

## Best Practices:
- Keep commits atomic and focused
- Write in imperative mood ("Add feature" not "Added feature")
- Explain why, not just what
- Reference issues/PRs when relevant
- Split unrelated changes into separate commits. This is very important!