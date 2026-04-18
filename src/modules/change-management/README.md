# Change Management

How changes move from a developer's branch into `main` and from `main` into a tagged release.

This is the workflow most teams think of when they think of "git workflow" — but it is one part of a larger system.

---

## What This Module Covers

- **Planning** — epics, decomposition policy, work hierarchy
- **Branching** — short-lived branches, naming conventions, one branch per concern
- **Pull requests** — review, CI validation, merge policy
- **Commits** — conventional commit messages, prefix taxonomy
- **Issues** — work tracking, types, lifecycle, traceability
- **Releases** — versioning, tags, release flow, hotfixes, changelog, long-term support

---

## Documents

| Document                | What it covers                                                       |
| ----------------------- | -------------------------------------------------------------------- |
| [Planning](PLANNING.md) | Epics, decomposition policy, work hierarchy, traceability            |
| [Workflow](WORKFLOW.md) | Branching, PRs, commits, issues, merges — the daily loop             |
| [Labels](LABELS.md)     | Label taxonomy, write-time vs read-time signals, platform adaptation |
| [Releases](RELEASES.md) | Tags, versions, release flow, hotfixes, changelog, LTS               |

---

## Relationship to Other Modules

**Construction** feeds this module. The construction workflow produces validated, issue-linked changes. This module governs how those changes are integrated.

**Delivery** follows this module. Once a change is merged and tagged, the delivery module moves the resulting artifact through environments and channels.

**Knowledge** runs alongside this module. Issue descriptions, PR explanations, and commit messages are all forms of knowledge persistence.

---

## Key Principle

From the [Principles](../../PRINCIPLES.md):

> **Every meaningful change maps to an issue.** Work should be traceable and resumable.

A PR without an issue is untracked work. A merge without CI is unvalidated integration. A release without a tag is an unnamed state. An epic without decomposition is a plan without execution. This module exists to prevent all four.
