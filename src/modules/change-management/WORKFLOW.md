# Workflow

Day-to-day development: branching, PRs, commits, issues, and merges.

---

## Development Model

**Trunk-based development with short-lived branches.**

- `main` is the integration branch and the source of truth
- Feature branches are short-lived
- Merge often
- Avoid long-running release branches unless you truly need parallel supported versions

This ages much better than classic GitFlow for modern CI/CD-heavy work.

---

## Branching

### Rules

- No long-lived feature branches
- One branch, one concern
- Branch names must map to issues
- Delete the branch immediately after merge

### Naming

Keep it boring and systematic. Include the issue ID when possible.

```text
feature/123-add-user-search
fix/287-null-check-on-login
chore/315-upgrade-openapi-generator
spike/333-evaluate-rust-parser
hotfix/401-fix-prod-timeout
```

Prefixes: `feature/`, `fix/`, `chore/`, `spike/`, `hotfix/`

---

## Pull Requests

### Rules

When PRs are used (Tier 2 — Solo / Consultancy, and Tier 3 — Small Team; see [Adapting](../../ADAPTING.md)):

- PR must explain **why**, not just what
- PR must link an issue
- PR must pass CI
- PR must be reviewable in one sitting
- PRs older than a few days should be reconsidered or split

**Tier 1 (Solo / Personal):** PRs are optional. Useful for self-review on larger changes, but direct commits to `main` are acceptable for small, well-understood changes.

**Tier 2 (Solo / Consultancy):** PRs required. Self-review is the norm, but the audit trail matters for client accountability.

**Tier 3 (Small Team):** PRs required. Peer review by another human is the point.

### A PR Should Be

- Small enough to review
- Tied to an issue
- Passing CI
- Mergeable without ambiguity
- Squashed or rebased cleanly

### Merge Policy

**Squash merge by default** for feature and fix branches. It keeps `main` readable.

Branch is deleted immediately after merge.

---

## Commits

### Convention

Use conventional commits or something close:

```text
feat: add export command
fix: prevent null crash in importer
chore: upgrade ruff config
docs: clarify release process
```

Conventional commits enable automated changelogs and release notes. Versioning and release notes should be **derived from changes**, not invented at the end.

### Prefixes

| Prefix     | Meaning                                                 |
| ---------- | ------------------------------------------------------- |
| `feat`     | New feature                                             |
| `fix`      | Bug fix                                                 |
| `chore`    | Maintenance, tooling, dependencies                      |
| `docs`     | Documentation only                                      |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `test`     | Adding or updating tests                                |
| `ci`       | CI/CD configuration                                     |

---

## Issues

### Types

Use a small taxonomy:

| Type         | Purpose                             |
| ------------ | ----------------------------------- |
| **Feature**  | New capability                      |
| **Bug**      | Something broken                    |
| **Chore**    | Maintenance, upgrades, housekeeping |
| **Spike**    | Research or investigation           |
| **Release**  | Release coordination                |
| **Incident** | Production issue                    |

### Lifecycle

```text
Backlog → Ready → In Progress → In Review → Verified → Done
```

### Traceability

- Every PR points to an issue
- Every release summarizes included issues
- Every hotfix links back to the incident

That gives you traceability without enterprise theater.

---

## CI on PR

CI validates every change before it reaches `main`.

- Format / lint
- Unit tests
- Integration tests where feasible
- Build validation
- Static analysis
- Preview artifact if relevant

CI should answer: **"Is this change good enough to integrate?"**

---

## Rules

The rules, collected. Rules marked with a tier apply from that tier upward.

| #   | Rule                                                         | Tier    |
| --- | ------------------------------------------------------------ | ------- |
| 1   | No long-lived feature branches                               | All     |
| 2   | One branch, one concern                                      | All     |
| 3   | Use conventional commits                                     | All     |
| 4   | Rebase or squash before merge                                | All     |
| 5   | `main` is always the source of truth                         | All     |
| 6   | No direct commits to `main` (except small changes in Tier 1) | Tier 2+ |
| 7   | Branch names must map to issues                              | Tier 2+ |
| 8   | PR required for every change                                 | Tier 2+ |
| 9   | PR must explain why, not just what                           | Tier 2+ |
| 10  | PR must link an issue                                        | Tier 2+ |
| 11  | PR must pass CI                                              | Tier 2+ |
| 12  | PR must be reviewable in one sitting                         | Tier 2+ |
| 13  | PRs older than a few days should be reconsidered or split    | Tier 2+ |
| 14  | Peer review required (not just self-review)                  | Tier 3  |
