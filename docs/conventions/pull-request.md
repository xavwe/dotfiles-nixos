# Conventional Pull Requests

## PR Title Types:
- feat: New features or feature development
- fix: Bug fixes and hotfixes
- docs: Documentation changes
- refactor: Code restructuring without changing functionality
- style: Code formatting, styling changes
- perf: Performance improvements
- test: Adding or correcting tests
- ci: CI/CD pipeline changes
- chore: Tooling, configuration, maintenance
- release: Release preparation
- hotfix: Critical fixes for production issues

## PR Title Format:
`<type>(<scope>): <description>`

Examples:
- `feat(auth): add OAuth2 authentication system`
- `fix(api): resolve null pointer exception in user service`
- `docs(readme): update installation instructions`
- `refactor(db): simplify database connection logic`
- `chore(deps): update npm dependencies`

## PR Description Template:
```markdown
## Summary
Brief description of what this PR accomplishes.

## Changes
- List of specific changes made
- Another change
- And another

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests pass
- [ ] Manual testing completed
- [ ] Edge cases considered

## Breaking Changes
(If applicable) Describe any breaking changes and migration steps.

## Related Issues
Fixes #123
Closes #456
```

## Best Practices:
- Write clear, descriptive titles that explain the change
- Use present tense ("Add feature" not "Added feature")
- Keep titles under 72 characters
- Include scope when it adds clarity
- Reference related issues and tickets
- Fill out the description template completely
- Request appropriate reviewers
- Ensure CI checks pass before requesting review

## PR Workflow:
1. Create feature branch following conventional branch naming
2. Make commits following conventional commit format
3. Open PR with conventional title and complete description
4. Request review from appropriate team members
5. Address feedback and update as needed
6. Merge when approved and CI passes
7. Delete feature branch after merge

## Specification
1. PR titles MUST be prefixed with a type, which consists of a noun (feat, fix, etc.), followed by an OPTIONAL scope in parentheses, a REQUIRED colon, space, and description.
2. The type feat MUST be used when a PR adds new features to the application.
3. The type fix MUST be used when a PR represents bug fixes.
4. A scope MAY be provided after a type. A scope MUST consist of a noun describing a section of the codebase surrounded by parentheses, e.g., feat(parser): add new parsing logic.
5. A description MUST immediately follow the colon and space after the type/scope prefix. The description is a short summary of the changes.
6. PR descriptions SHOULD follow the provided template structure with Summary, Changes, Testing, and Related Issues sections.
7. Breaking changes MUST be clearly indicated in the PR description under a "Breaking Changes" section.
8. Related issues MUST be referenced using GitHub keywords (Fixes, Closes, Resolves) followed by the issue number.
9. PR titles SHOULD be written in imperative mood and present tense.
10. PR titles MUST NOT exceed 72 characters to ensure readability in various interfaces.
11. PRs SHOULD include appropriate labels for type, priority, and affected components.
12. Draft PRs MAY be used for work-in-progress and MUST be clearly marked as such.

*Inspired by conventional commits specification*