# ✍️ GitHub Conventions

This repository contains the conventions for GitHub commits, pull requests, and issues for 01-Edu organization.

## Table of Contents

- [Commit Messages](#commit-messages)
- [Pull Requests](#pull-requests)
- [Issues](#issues)

## Commit Messages

The commit message format should follow:

```
type(scope): description
```

We only use commit messages with scope. Here are some examples:

- `chore(docs): fmt with prettier`
- `feat(ci): add biome checks`
- `chore(api-js): rebase and resolve conflicts`
- `refactor(api-js|static): fixes based on refactor`
- `fix(api-js/db): expire audit only if user is anonymised`

For breaking changes, use the `!` symbol:

- `fix(package-name)!: update package version from v6 to v8`

## Pull Requests

### Title Format

Pull request titles should include the ticket reference:

```
TAG-#### Pull request title
```

Examples:

- `DEV-1234 Update user data should not expire audits, only in anonymised`
- `CON-1234 Create subject, audit, and refs for matrix-factorization`
- `TNT-1234 Create Database Schema (draft)`
- `DEV-1234 | SUP-1234 Git hard reset feature missing for admin audits model`

### Requirements

1. The pull request body must contain the TAG-#### as the first element
2. External contributions must be prepended with `[EXTERNAL]`
3. Invalid pull requests must be prepended with `[INVALID]`
4. All pull requests must have:
   - Appropriate team labels
   - Additional labels if required
   - Assigned reviewers
   - Assigned assignees
5. Code must be properly formatted using appropriate tools:
   - Prettier
   - ShellCheck
   - Biome
   - Black code formatter
   - etc.

### Handling Spam PRs

For rogue or spam pull requests from external users, close with the following message and block the user:

```
> [!WARNING]
>
> ## 🚫 BLOCKED: @<username>
>
> This user has been blocked:
>
> - Rogue contribution / SPAM
```

This should output:

> [!WARNING]
>
> ## 🚫 BLOCKED: @<username>
>
> This user has been blocked:
>
> - Rogue contribution / SPAM

## Issues

### External Contributor Issues

Issues from external contributors must include an issue type in the title:

Examples:

- `[QUESTION] emotions-detector subject requirements reasonable?`
- `[BUG] Possible issue in NascarOnlineAlpha gaming project`
- `[FEATURE] deep-in-system audit details`

All issues must have appropriate labels.

### Closing Invalid Issues

For issues lacking context/clarity/substance or responsiveness, close with:

```
> [!IMPORTANT]
>
> ## 🚫 @<username>: This issue has been closed due to lack of context/clarity/substance/responsiveness!
>
> If you find there is something wrong with a subject/exercise/feature, please feel free to open a new issue with an appropriate title, context and further details that would help our team to address the issue effectively.
>
> We could use the following information to help us resolve a potential issue:
>
> - The issue/error you are encountering from the platform
> - The solution you're trying to submit / steps to reproduce the issue/error
> - The screenshot of the issue/error
> - Any additional details
```

This should output:

> [!IMPORTANT]
>
> ## 🚫 @<username>: This issue has been closed due to lack of context/clarity/substance/responsiveness!
>
> If you find there is something wrong with a subject/exercise/feature, please feel free to open a new issue with an appropriate title, context and further details that would help our team to address the issue effectively.
>
> We could use the following information to help us resolve a potential issue:
>
> - The issue/error you are encountering from the platform
> - The solution you're trying to submit / steps to reproduce the issue/error
> - The screenshot of the issue/error
> - Any additional details
