# Workflow

Day-to-day development: branching, PRs, commits, issues, and merges.

---

## Write-Time vs Read-Time Signals

Three mechanisms describe the nature of work: **branch prefixes**, **commit prefixes**, and **labels**. They look redundant at a glance but operate at different points in the lifecycle.

| Mechanism     | Scope                 | Answers                                                     |
| ------------- | --------------------- | ----------------------------------------------------------- |
| Branch prefix | One branch, lifetime  | What kind of work is happening here right now?              |
| Commit prefix | One commit            | What kind of change is this line of history?                |
| Label         | One issue, indefinite | How do I find, filter, or prioritize this across a backlog? |

Branch and commit prefixes are **write-time** signals — they describe work as it is being done, then become history. Labels are **read-time** signals — before a branch exists, the label is the only way to answer "what bugs are open?" or "what is p0 this week?"

The rule that keeps the system coherent: **the vocabulary matches across all three.** A `feat/` branch produces `feat:` commits on an issue tagged `type/feat`. No translation, no synonyms. See [Labels](LABELS.md) for the full label taxonomy.

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
feat/123-add-user-search
fix/287-null-check-on-login
chore/315-upgrade-openapi-generator
spike/333-evaluate-rust-parser
docs/350-clarify-release-flow
hotfix/401-fix-prod-timeout
```

Prefixes: `feat/`, `fix/`, `chore/`, `spike/`, `docs/`, `hotfix/`

`hotfix/` is kept distinct from `fix/` because it carries operational meaning — an urgent patch against a released version, often fast-tracked through a separate merge path. A normal bug fix, even a p0, is still `fix/`.

The branch prefix must match the `type/*` label on the linked issue and the prefix on commits landing to the branch.

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

### Why Both Validation and Review

If the golden command passed, why does a human still need to review?

Because they check different things:

- **Validation checks correctness.** Does the code compile, pass tests, follow style rules? Mechanical. Deterministic. The toolchain answers this.
- **Review checks intent.** Is this the right approach? Is the architecture sound? Does the scope match the issue? Judgment-based. Human.

An agent can write a "correct" function that is architecturally wrong — it compiles, passes tests, and follows the linter, but introduces a dependency that violates the project's design. Validation will not catch that. Review will.

These are complementary, not redundant. Validation is the floor. Review is the ceiling.

### A PR Should Be

- Small enough to review
- Tied to an issue
- Passing CI
- Mergeable without ambiguity
- Squashed or rebased cleanly

### Merge Policy

**Squash merge by default** for feature and fix branches. The goal is **linear history on `main`** — no merge commits from feature branches.

A linear history is easier to read, bisect, and reason about. `git log --oneline` tells a clean narrative instead of a graph puzzle. This matters especially for agents: a linear history is trivially parseable; a tangled merge graph requires reconstruction.

If the branch has diverged from `main`, **rebase before merge**. The developer or agent is responsible for resolving conflicts before the PR is mergeable. Do not create merge commits to integrate feature branches.

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

### Commit Message Quality

The format is necessary but not sufficient. A commit message is a knowledge artifact — it should capture **why**, not just **what**.

| Quality | Example                                                                   |
| ------- | ------------------------------------------------------------------------- |
| Bad     | `feat: add login logic`                                                   |
| Better  | `feat: add session-based login with bcrypt hashing`                       |
| Best    | `feat: add session-based login, chose bcrypt over argon2 for portability` |

The test: **would a future contributor — human or agent — understand the intent from the commit message alone?** If not, the message is too vague. This matters doubly for agents, which are prone to writing generic messages like "feat: implement requested changes" that satisfy the format but carry no context.

When the golden command forced a refactor, say so. When one implementation was chosen over another, say why. The commit message is often the only record of a decision that did not warrant a full ADR.

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

Issues are the atomic unit of execution. Each issue maps to one branch and one PR. For how issues are organized into larger bodies of work, see [Planning](PLANNING.md).

### When Is an Issue Required?

Principle 4 says "every meaningful change maps to an issue" — but what counts as meaningful?

| Project Class | Policy                                                                                    |
| ------------- | ----------------------------------------------------------------------------------------- |
| **Class 2–3** | If it is worth a commit, it is worth an issue. The overhead is minimal with good tooling. |
| **Class 0–1** | Issues recommended for anything non-trivial. Direct commits acceptable for minor fixes.   |

**The test:** "Would a future contributor wonder why this changed?" If yes, it needs an issue. If it is a mechanical fix — a typo, a formatting correction, a dependency bump with no behavior change — a clear commit message is sufficient.

The goal is traceability, not bureaucracy. An issue takes seconds to create and provides a permanent record of intent. A commit message without an issue is fine for trivial changes — but if you find yourself writing a long commit message to explain why, you should have created an issue instead.

### Types

Issue type is expressed via the `type/*` label (or the platform's native issue type where available). The vocabulary matches branch and commit prefixes exactly — a `type/feat` issue has a `feat/` branch and `feat:` commits. See [Labels](LABELS.md) for the full set.

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
| 4   | Squash merge by default; rebase if diverged                  | All     |
| 5   | Linear history on `main` — no merge commits from branches    | All     |
| 6   | `main` is always the source of truth                         | All     |
| 7   | No direct commits to `main` (except small changes in Tier 1) | Tier 2+ |
| 8   | Branch names must map to issues                              | Tier 2+ |
| 9   | PR required for every change                                 | Tier 2+ |
| 10  | PR must explain why, not just what                           | Tier 2+ |
| 11  | PR must link an issue                                        | Tier 2+ |
| 12  | PR must pass CI                                              | Tier 2+ |
| 13  | PR must be reviewable in one sitting                         | Tier 2+ |
| 14  | PRs older than a few days should be reconsidered or split    | Tier 2+ |
| 15  | Peer review required (not just self-review)                  | Tier 3  |
