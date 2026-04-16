# Glossary

Ubiquitous language for the Unified Engineering Method. Define your vocabulary and half the confusion disappears.

This glossary is the shared contract. Every document in this framework uses these terms with these meanings. Agents, automation, and team members should interpret them identically.

---

## Source Control

### Change

A unit of work. Usually tied to an issue. The smallest meaningful delta to the codebase.

### Branch

A temporary integration workspace for a single change or cohesive set of changes. Branches are short-lived by design.

### Merge

The act that integrates approved work into `main`. The point where a change becomes part of the shared truth.

### Hotfix

An urgent production fix. Branched from the production tag or current stable commit, merged back into `main` after release. No divergence allowed to linger.

### Rollback

Returning an environment or channel to a previously known-good artifact. Rollback redeploys an existing artifact; it does not rebuild from old source.

---

## Collaboration

### Epic

A coherent body of work that delivers a recognizable capability or outcome. Decomposes into 3–7 issues. The planning boundary — the level at which you define what is being built and why. Epics organize work logically; they do not map to branches.

### Issue

A tracked piece of work. Types: **Feature**, **Bug**, **Chore**, **Spike**, **Release**, **Incident**. The atomic unit of execution — each issue maps to one branch and one PR.

### Decomposition

The act of breaking an epic into independently mergeable issues. Good decomposition keeps branches short-lived, PRs reviewable, and progress incremental.

### PR (Pull Request)

A proposal to merge a branch into `main`. The review and validation boundary. A PR is for review, not for long-lived parallel worlds.

---

## Build and Delivery

### Build

The CI process that compiles, tests, and packages code from a specific commit. Deterministic and reproducible.

### Artifact

The immutable output of a build: binary, wheel, container image, installer, zip, IPA, APK, etc. Once created, an artifact never changes. An artifact carries **build identity** (commit SHA, build number, timestamp) embedded at build time. It does not carry release identity — that is provided externally by the deployment context at promotion time.

### Build Identity

The provenance data embedded in an artifact at build time: commit SHA, build number, build timestamp, pipeline ID. Permanent and immutable. This is what the artifact knows about itself.

### Release Identity

The version label and channel assignment given to an artifact at promotion time: semantic version, channel label, release notes. Provided by the deployment context, not embedded in the artifact. This is what the user sees.

### Deployment Context

The external source that provides release identity to a running artifact: environment variable, sidecar metadata file, container label, package manifest, installer metadata, or config endpoint. The mechanism varies by product type; the principle is constant.

### Promotion

Moving the same artifact to the next environment or channel. The artifact does not change; only where it runs and its release identity change. Promotion adds aliases and deployment context — it never triggers a rebuild.

---

## Versioning and Release

### Version

A product identifier. Typically SemVer-shaped: `MAJOR.MINOR.PATCH`.

- **MAJOR** = breaking change
- **MINOR** = backward-compatible feature
- **PATCH** = backward-compatible fix

### Tag

A git reference that marks a meaningful version or release point. Format: `v1.4.0`, `v2.0.0-beta.2`, `v2.0.0-rc.1`. Tags represent release points, not random milestones.

### Release

A versioned, tagged, published product state with notes and artifacts. A release is a named, auditable moment in the product's history.

### Changelog

A structured record of changes between releases, derived from conventional commit messages at tag time. Changelog entries correspond to tags, not to individual merges. Dev channel builds do not produce changelog entries.

### Alias

A secondary pointer to an existing artifact. Promotion adds aliases (version tags, channel labels) to an immutable artifact without rebuilding it. The artifact bytes and checksum remain identical.

---

## Infrastructure

### Environment

A runtime target. Where something runs.

| Environment    | Purpose                                 |
| -------------- | --------------------------------------- |
| **Dev**        | Automatic from `main`. Fast iteration.  |
| **Staging**    | Candidate validation before production. |
| **Production** | Live traffic.                           |

### Channel

A release audience and risk lane. Who gets something and how risky it is.

Channels are **quality-gated**: a build gets promoted when it passes checks, not on a schedule.

| Channel    | Purpose                                                              | Tier    |
| ---------- | -------------------------------------------------------------------- | ------- |
| **Dev**    | Fast, frequent, low ceremony. May track every merge to `main`.       | All     |
| **Canary** | Limited real-world exposure. Low blast radius production validation. | Tier 3  |
| **Beta**   | Broader but opt-in or limited audience. Pre-release testing.         | Tier 2+ |
| **Stable** | General availability. Default channel for most users.                | All     |

**Related but distinct concepts:**

- **Nightly** is a time-gated build schedule, not a channel. Nightly builds may feed into `dev` or `canary`.
- **RC** (release candidate) is a version suffix (`v1.4.0-rc.1`), not a channel. RCs live on the `beta` to `stable` promotion path.
- **Edge** and **next** are ecosystem-specific aliases for `dev` or `canary`.
- **LTS** (long-term support) is a support policy, not a channel.

### The Distinction

Environments answer: **where is this running?**
Channels answer: **who gets this and how risky is it?**

A staging environment might host a release candidate. Production might host both canary and stable deployments. Internal builds may go to a dev environment but not be formal releases. Keep them separate.

### Smoke Test

A rapid validation of a deployed artifact. Smoke tests confirm that the artifact can start, respond, and perform critical functions in the target environment. They are not exhaustive — they verify that the deployment is fundamentally working.

---

## Identity Rules

These three identifiers are related but not identical:

| Identifier     | What it tracks |
| -------------- | -------------- |
| **Git commit** | Source         |
| **Artifact**   | Build output   |
| **Tag**        | Release intent |

---

## Construction

### Toolchain

The configured set of formatter, linter, type checker, and test runner for a project, plus conditional categories (such as structured logging) based on project class. The enforcement layer that turns principles into automated checks.

### Structured Logging

A logging convention where output is machine-parseable (typically JSON), leveled (debug, info, warn, error), and produced through a configured logger rather than raw print statements. In UEM, structured logging is a conditional toolchain category — mandatory for Class 2+ projects. Enforcement is mediated through linter rules, not a separate golden command.

### Golden Command

A canonical command in the project's validation surface. Standard set: `just fmt`, `just lint`, `just typecheck`, `just test`, `just ci`. The recommended runner is [`just`](https://github.com/casey/just); alternatives include `make`, `package.json` scripts, or `task`. The mechanism varies; the stable names do not.

### Validation Surface

The complete set of golden commands that prove a change is integration-ready. Running the full validation surface is the gate before any PR or commit to `main`.

### Local/CI Parity

The property that local validation and CI validation run identical commands, identical tool versions, and identical configurations. If a developer runs `just ci` locally and gets the same result as the CI server, parity is achieved.

### Scaffold

The initial project structure, configuration, and toolchain setup that constrains subsequent work. A well-scaffolded project makes the default path the correct path. Scaffolding happens before the first line of application logic.

### Bounded Task

A unit of work scoped to be completable and validatable in a single focused session. Bounded tasks have clear entry criteria (the issue) and clear exit criteria (validation passes, PR ready).

### Project Class

A classification of project durability and quality requirements. Classes range from 0 (scratchpad) through 3 (long-lived product). Class determines how much toolchain and ceremony apply. Orthogonal to operational tier.

---

## Agent Operations

### Agent Execution Loop

The standard construction cycle: select issue → inspect codebase → state plan → make focused changes → run validation → fix until clean → summarize deltas → prepare for integration. This loop applies whether the builder is a human or an agent.

### Session

A bounded interaction between an agent (or human) and a project. Context that does not persist beyond the session is ephemeral. Plans that matter beyond the session must enter the project system.

### Constraint

A toolchain-enforced rule that cannot be violated by accident. Constraints are the opposite of conventions: a convention depends on memory; a constraint depends on mechanism.

### Shaped Corridor

The operating environment created by toolchain configuration, project structure, and validation gates. An agent working inside a shaped corridor produces correct-by-default output because the incorrect paths are blocked.

---

## Knowledge

### ADR (Architecture Decision Record)

A document recording a significant technical decision, its context, and its consequences. ADRs are immutable records of a point-in-time decision. If the decision changes, a new ADR supersedes the old one.

### Persistent Plan

A plan that has been committed to the project system — GitHub issue, milestone, ADR, or repo document — rather than existing only in chat history or model context.

### Context Debt

Knowledge that exists in someone's head (or a chat log) but not in the project system. Context debt compounds silently: the original author knows why the code is structured a certain way; the next contributor does not.

### Documentation

Written artifacts in the repository that answer questions someone will actually have: setup instructions, architecture overview, ADRs, contribution conventions. Documentation should be useful, findable, current, and minimal.
