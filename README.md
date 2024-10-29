# ✍️ GitHub Conventions for 01-Edu

Welcome to the official GitHub conventions guide for the [01-Edu](https://github.com/01-edu) organization. This document outlines our standardized practices for commits, pull requests, and issues to maintain consistency across our repositories.

## 📑 Table of Contents

- [Commit Messages](#-commit-messages)
- [Pull Requests](#-pull-requests)
- [Issues](#-issues)

## 💬 Commit Messages

### Format

All commit messages must follow the conventional [commit message with scope format](https://www.conventionalcommits.org/en/v1.0.0/#commit-message-with-scope):

```
type(scope): description
```

The format consists of:

- `type`: Describes the category of the change
- `scope`: Indicates the section of the codebase affected
- `description`: A clear, concise description of the change

### Types

- `feat`: New features or significant additions
- `fix`: Bug fixes
- `docs`: Documentation changes
- `style`: Code style updates (formatting, missing semi-colons, etc.)
- `refactor`: Code changes that neither fix bugs nor add features
- `test`: Adding or modifying tests
- `chore`: Maintenance tasks, dependency updates, etc.

### Examples

```
chore(docs): fmt with prettier
feat(ci): add biome checks
chore(api-js): rebase and resolve conflicts
refactor(api-js|static): fixes based on refactor
fix(api-js/db): expire audit only if user is anonymised
```

### Breaking Changes

For breaking changes, append `!` after the scope (similar to [conventional-commits](https://www.conventionalcommits.org/en/v1.0.0/#commit-message-with-scope-and--to-draw-attention-to-breaking-change)):

```
fix(package-name)!: update package version from v6 to v8
```

Our conventions closely follow the Conventional Commits [v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) standard.

## 🔄 Pull Requests

### Title Format

All pull requests must include a ticket reference:

```
TAG-#### Pull request title
```

Where:

- `TAG`: Project identifier (e.g., DEV, CON, TNT)
- `####`: Ticket number
- `title`: Descriptive title of the changes

### Examples

```
DEV-1234 Update user data should not expire audits, only in anonymised
CON-1234 Create subject, audit, and refs for matrix-factorization
TNT-1234 Create Database Schema (draft)
DEV-1234 | SUP-1234 Git hard reset feature missing for admin audits model
```

### Requirements

1. **Body Content**

   - Must begin with the TAG-#### reference
   - Should provide a clear description of changes (optional, if present in the ticket)
   - List any breaking changes (optional, if present in the ticket)

2. **Special Tags**

   - External contributions: Prepend with `[EXTERNAL]`
   - Invalid pull requests: Prepend with `[INVALID]`

3. **Required Metadata**

   - Team labels (content, platform, tournament, etc.)
   - Additional context labels (breaking, trivial, etc.)
   - Assigned reviewer(s)
   - Assigned assignee(s)

4. **Code Quality**
   All code must be formatted using the appropriate tools:
   - General: Prettier
   - Shell scripts: ShellCheck
   - JavaScript/TypeScript: Biome
   - Python: Black code formatter

### Handling Spam PRs

For spam or unauthorized pull requests, use this template:

```
> [!WARNING]
>
> ## BLOCKED: @<username>
>
> This user has been blocked:
>
> - Rogue contribution / SPAM
```

The output should be:

> [!WARNING]
>
> ## BLOCKED: @username
>
> This user has been blocked:
>
> - Rogue contribution / SPAM

## ❓ Issues

### External Contributor Guidelines

Issues from external contributors must include a type prefix in the title:

- `[QUESTION]`: For clarifications about implementation or requirements
- `[BUG]`: For reporting bugs or unexpected behavior
- `[FEATURE]`: For suggesting new features or improvements

### Examples

```
[QUESTION] The emotions-detector subject requirements reasonable?
[BUG] Possible issue in NascarOnlineAlpha gaming project
[FEATURE] Add deep-in-system audit details
```

### Issue Requirements

1. **Labels**

   - Bug reports: Bug label (plus severity, if needed)
   - Feature requests: Feature label
   - Questions: Question label

2. **Content**
   - Clear description of the issue
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Supporting screenshots or logs
   - Environment details when relevant

### Closing Invalid Issues

For issues lacking sufficient information or responsiveness, use this template:

```
> [!IMPORTANT]
>
> ## @<username>: This issue has been closed due to lack of context/clarity/substance/responsiveness!
>
> If you find there is something wrong with a subject/exercise/feature, please feel free to open a new issue with an appropriate title, context and further details that would help our team to address the issue effectively.
>
> We require the following information:
>
> - The issue/error you are encountering from the platform
> - The solution you're trying to submit / steps to reproduce the issue/error
> - The screenshot of the issue/error
> - Any additional details
```

The output should be:

> [!IMPORTANT]
>
> ## @username: This issue has been closed due to lack of context/clarity/substance/responsiveness!
>
> If you find there is something wrong with a subject/exercise/feature, please feel free to open a new issue with an appropriate title, context and further details that would help our team to address the issue effectively.
>
> We require the following information:
>
> - The issue/error you are encountering from the platform
> - The solution you're trying to submit / steps to reproduce the issue/error
> - The screenshot of the issue/error
> - Any additional details
