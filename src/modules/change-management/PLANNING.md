# Planning

How work is organized before it becomes branches, PRs, and commits.

---

## The Hierarchy

Work flows through three levels:

```text
Epic  →  Issue  →  Branch / PR / Commits
plan     ship     integrate
```

**Epics plan. Issues ship.** An epic defines a body of work. Issues are the units that actually move through the development workflow. Each issue maps to one branch, one PR, and one or more commits.

---

## Epics

An epic is a coherent body of work that delivers a recognizable capability or outcome. It is the planning boundary — the level at which you ask "what are we building and why?"

Epics are **not** branches. An epic produces multiple issues, each with its own branch. The epic ties them together logically, not physically.

### Rules

| #   | Rule                                                       | Applies |
| --- | ---------------------------------------------------------- | ------- |
| 1   | An epic decomposes into 3–7 issues                         | All     |
| 2   | Each issue must be independently mergeable to `main`       | All     |
| 3   | An epic with more than 7 issues should be split into epics | All     |
| 4   | An epic with fewer than 3 issues is probably just an issue | All     |

### GitHub Adaptation

GitHub does not have a native epic type. Use:

- A **parent issue** with the `epic` label as the epic
- Child issues that reference the parent (`Part of #42`)
- A task list in the parent issue body that tracks child issue completion

```markdown
## Tasks

- [ ] #43 — Define API schema
- [ ] #44 — Implement endpoints
- [ ] #45 — Add integration tests
- [ ] #46 — Update documentation
```

The parent issue becomes a living progress tracker. Each child issue is checked off as its PR merges.

---

## Decomposition Policy

The decomposition policy governs how an epic becomes issues. Getting this right at planning time is what keeps branch count, PR volume, and review load manageable.

### The Independence Test

For each candidate issue, ask: **"Can this be merged to `main` without its siblings and leave the build green?"**

- **Yes** → it is a valid issue.
- **No** → it is not independent. Merge it with a sibling issue, or restructure the decomposition.

Half-built features behind the merge are acceptable. Broken builds are not.

### The Review Test

For each candidate issue, ask: **"Can a reviewer understand and approve this in one sitting?"**

- **Yes** → it is the right size.
- **No** → it may be an epic pretending to be an issue. Decompose further.

### The Coherence Test

For the epic as a whole, ask: **"Does every issue clearly contribute to the epic's stated goal?"**

- **Yes** → the decomposition is aligned.
- **No** → the stray issues belong to a different epic, or the epic's scope is unclear.

### Common Decomposition Patterns

| Pattern                | Description                                                                                                             |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **Vertical slice**     | Each issue delivers a thin, end-to-end piece of functionality (API + UI + test)                                         |
| **Horizontal layer**   | Each issue addresses one layer (data model, then API, then UI). Riskier — later issues may force rework of earlier ones |
| **Preparatory + core** | One or two issues lay groundwork (schema, interfaces), remaining issues build on top                                    |

Prefer **vertical slices** when possible. They keep each issue independently shippable and reduce the risk of late-stage integration surprises.

---

## Traceability

The full traceability chain:

```text
Epic (parent issue)
 └── Issue (child issue)
      └── Branch (named with issue ID)
           └── PR (links issue, merges to main)
                └── Commits (conventional, reference issue)
```

Every level points to the one above it. You can reconstruct the full history of any epic by following the references:

- **From epic down**: parent issue → task list → child issues → linked PRs → commits
- **From commit up**: commit message → PR → issue → parent epic

---

## Planning and Tiers

| Tier                          | Planning expectation                                                                                                    |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **Tier 1** (Solo/Personal)    | Epics optional. Issues recommended for anything non-trivial. Decomposition is lightweight.                              |
| **Tier 2** (Solo/Consultancy) | Epics recommended for multi-issue work. Decomposition policy applies. Client visibility into progress via parent issue. |
| **Tier 3** (Small Team)       | Epics required for coordinated work. Decomposition reviewed before work begins. Parent issue is the coordination point. |

---

## Anti-patterns

| Anti-pattern                   | Why it fails                                                     | Fix                                   |
| ------------------------------ | ---------------------------------------------------------------- | ------------------------------------- |
| Epic-per-branch                | Long-lived branches, massive PRs, merge conflicts, stale reviews | Issue-per-branch                      |
| 15-issue epic                  | Too much in flight, coordination overhead, loss of focus         | Split into 2–3 epics                  |
| Issues that cannot merge alone | Breaks short-lived branch principle, creates hidden dependencies | Merge dependent issues or restructure |
| No epic, just a pile of issues | No coherent narrative, hard to track progress, unclear "done"    | Group related issues under a parent   |
| Epic with no decomposition     | Single massive issue, no incremental progress, unreviewable PR   | Apply decomposition policy            |
