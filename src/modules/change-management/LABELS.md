# Labels

A small, reusable label taxonomy for issues and PRs. The method prescribes the **vocabulary**. Each platform (GitHub, Jira, Linear, others) implements it with whatever native mechanism fits best.

---

## Write-Time vs Read-Time Signals

Three mechanisms describe the nature of work: **branch prefixes**, **commit prefixes**, and **labels**. They are not redundant — they operate at different points in the lifecycle.

| Mechanism     | Scope                 | Answers                                                     |
| ------------- | --------------------- | ----------------------------------------------------------- |
| Branch prefix | One branch, lifetime  | What kind of work is happening here right now?              |
| Commit prefix | One commit            | What kind of change is this line of history?                |
| Label         | One issue, indefinite | How do I find, filter, or prioritize this across a backlog? |

**Branch and commit prefixes are write-time signals.** They describe work as it is being done, then become history.

**Labels are read-time signals.** They exist to answer questions across the backlog — open bugs, queued features, blocked work, p0 incidents. Before any branch exists, labels are the only signal available.

The rule that keeps all three coherent: **the vocabulary matches across every surface.** A `feat/` branch produces `feat:` commits and corresponds to a `type/feat` label. No translation, no synonyms.

---

## The Standard Set

Three orthogonal namespaces. Small enough to memorize, large enough to be useful.

### `type/*` — Nature of Work

| Label           | Meaning                                                 |
| --------------- | ------------------------------------------------------- |
| `type/feat`     | New feature or capability                               |
| `type/fix`      | Bug fix                                                 |
| `type/chore`    | Maintenance, tooling, dependency upgrades               |
| `type/docs`     | Documentation only                                      |
| `type/refactor` | Code change that neither fixes a bug nor adds a feature |
| `type/test`     | Adding or updating tests                                |
| `type/ci`       | CI/CD configuration                                     |
| `type/spike`    | Research or investigation                               |
| `type/epic`     | Parent issue decomposing into child issues              |
| `type/adr`      | Architectural decision record                           |
| `type/incident` | Production issue or postmortem                          |

The first seven mirror the commit prefixes exactly. The last four have no write-time analog — they are issue-only concepts.

### `priority/*` — Severity

| Label         | Meaning                                       |
| ------------- | --------------------------------------------- |
| `priority/p0` | Urgent. Drop other work. Usually an incident. |
| `priority/p1` | Important. Next up.                           |
| `priority/p2` | Normal. Default for most work.                |
| `priority/p3` | Low. Nice to have.                            |

Priority is mutable and has no branch or commit analog. Labels are the only place it lives.

### `status/*` — Lifecycle

Only states the workflow position itself cannot reveal.

| Label                 | Meaning                                          |
| --------------------- | ------------------------------------------------ |
| `status/blocked`      | Cannot progress; waiting on external dependency. |
| `status/needs-triage` | Filed but not yet categorized or prioritized.    |

Do not add labels for states GitHub/Jira/Linear already track (open, closed, in-review, merged). That is noise.

### `area/*` — Project-Specific

Not part of the reusable set. Each project defines its own — `area/auth`, `area/ingest`, `area/frontend`. Keep them few and stable.

---

## Platform Adaptation

The vocabulary is universal. The implementation is platform-specific. For each concept, you may use the label, the platform's native construct, or both — whichever serves the project.

### GitHub

- **Type** — use labels. No native issue type for most categories.
- **Epic** — GitHub has native sub-issues (parent ↔ child). You can filter with `has:sub-issues-progress -has:parent-issue` to list epics, or `has:parent-issue` to list sub-issues. Prefer native sub-issues over the `type/epic` label when it is sufficient. Apply the label too if you want the filter to match your team's vocabulary.
- **Priority** — no native field. Use labels.
- **Status** — GitHub tracks open/closed/draft/merged natively. Only use `status/blocked` and `status/needs-triage` labels.

### Jira

- **Type** — Jira has native issue types (Story, Bug, Task, Epic). Prefer native types over `type/*` labels for the concepts Jira supports directly.
- **Epic** — use the native Epic type.
- **Priority** — use the native Priority field. Skip `priority/*` labels.
- **Status** — Jira's workflow states cover most lifecycle. `status/blocked` may still be useful if your workflow does not model it.

### Linear

- **Type** — Linear has native labels and issue types. Either works.
- **Epic** — use Projects or parent-child issue relationships.
- **Priority** — use the native Priority field. Skip `priority/*` labels.
- **Status** — Linear's workflow states cover this.

**Rule of thumb:** if the platform has a first-class field, use it. Fall back to labels only when the platform cannot express the concept natively.

---

## Creating the Label Set

For GitHub, the following script creates the full reusable set in a repository:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Type
gh label create "type/feat"     --color "0e8a16" --description "New feature or capability"
gh label create "type/fix"      --color "d73a4a" --description "Bug fix"
gh label create "type/chore"    --color "cfd3d7" --description "Maintenance, tooling, dependencies"
gh label create "type/docs"     --color "0075ca" --description "Documentation only"
gh label create "type/refactor" --color "a2eeef" --description "Refactor without behavior change"
gh label create "type/test"     --color "bfd4f2" --description "Adding or updating tests"
gh label create "type/ci"       --color "ededed" --description "CI/CD configuration"
gh label create "type/spike"    --color "fbca04" --description "Research or investigation"
gh label create "type/epic"     --color "5319e7" --description "Parent issue with child issues"
gh label create "type/adr"      --color "1d76db" --description "Architectural decision record"
gh label create "type/incident" --color "b60205" --description "Production issue or postmortem"

# Priority
gh label create "priority/p0"   --color "b60205" --description "Urgent — drop other work"
gh label create "priority/p1"   --color "d93f0b" --description "Important — next up"
gh label create "priority/p2"   --color "fbca04" --description "Normal — default"
gh label create "priority/p3"   --color "c2e0c6" --description "Low — nice to have"

# Status
gh label create "status/blocked"      --color "e99695" --description "Blocked on external dependency"
gh label create "status/needs-triage" --color "ededed" --description "Filed but not yet categorized"
```

Run it once per repository. For many repos, wrap it in a loop over `gh repo list`.

---

## Rules

| #   | Rule                                                                            | Tier |
| --- | ------------------------------------------------------------------------------- | ---- |
| 1   | Vocabulary matches across branch prefixes, commit prefixes, and labels          | All  |
| 2   | Every issue has at least one `type/*` label (or native equivalent)              | All  |
| 3   | Every issue has exactly one `priority/*` label (or native equivalent)           | All  |
| 4   | Do not add labels for states the platform tracks natively (open, merged, draft) | All  |
| 5   | Prefer native platform constructs (Jira priority, Linear projects) over labels  | All  |
| 6   | `area/*` labels are project-specific; keep them few and stable                  | All  |

---

## Why This Taxonomy

**Orthogonal namespaces** (`type/`, `priority/`, `status/`, `area/`) compose cleanly. Filtering by one dimension does not interfere with another.

**Small set** (~17 reusable labels). Small enough to memorize, large enough to describe any issue.

**Platform-agnostic.** The vocabulary survives a move from GitHub to Jira to Linear. Only the implementation changes.

**Aligned with conventional commits.** `type/*` labels mirror commit prefixes, so a reader never has to translate between mechanisms.
