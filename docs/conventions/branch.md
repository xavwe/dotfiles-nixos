# Conventional branches

## Branch Types:
- feat: New features or feature development
- fix: Bug fixes and hotfixes
- docs: Documentation changes
- refactor: Code restructuring without changing functionality
- style: Code formatting, styling changes
- perf: Performance improvements
- test: Adding or correcting tests
- ci: CI/CD pipeline changes
- chore: Tooling, configuration, maintenance
- release: Release preparation branches
- hotfix: Critical fixes for production issues

## Branch Naming Format:
`<type>/<short-description>`

Examples:
- `feat/user-authentication`
- `fix/login-validation-bug`
- `docs/update-api-reference`
- `refactor/database-layer`
- `chore/update-dependencies`

## Best Practices:
- Use lowercase and hyphens for branch names
- Keep descriptions short but descriptive
- Use issue numbers when relevant: `feat/123-user-auth`
- Avoid special characters and spaces

## Main branch:
- Production-ready code
- no direct commit, only pr

## Specification
1. Branches MUST be prefixed with a type, which consists of a noun (feat, fix, etc.), followed by a REQUIRED forward slash and a short description.
2. The type feat MUST be used when a branch contains new feature development.
3. The type fix MUST be used when a branch contains bug fixes.
4. The type hotfix MUST be used when a branch contains critical fixes that need immediate deployment.
5. A short description MUST immediately follow the forward slash after the type prefix. The description should be a brief summary of the branch purpose using lowercase letters and hyphens as word separators.
6. Branch names MUST use lowercase letters, numbers, and hyphens only. Spaces and special characters are forbidden.
7. Branch names SHOULD be concise but descriptive enough to understand the purpose without additional context.
8. Issue or ticket numbers MAY be included in the branch name for traceability, e.g., feat/123-user-authentication.
9. Branch names MUST NOT exceed 50 characters to ensure compatibility across different systems.
10. Temporary or experimental branches MAY use additional prefixes like experimental/ or spike/.
11. Branch names SHOULD be unique within the repository to avoid confusion.
12. When multiple developers work on the same feature, sub-branches MAY be created using the format: feat/feature-name/sub-feature.

*Inspired by conventional commits specification*