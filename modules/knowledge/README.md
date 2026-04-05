# Knowledge

How intent, decisions, and context persist beyond any single session.

This module governs the practices that keep a project understandable over time — for humans and for future agents who arrive with no prior conversation history.

---

## What This Module Covers

- **Architecture Decision Records (ADRs)** — documenting significant technical choices
- **Persistent planning** — moving plans from ephemeral context into durable project artifacts
- **Documentation as maintenance** — keeping docs useful without making them a burden
- **Context management** — what to persist, where to persist it, and when to let it go

---

## The Central Problem

Software projects accumulate intent over time: why was this built this way? Why not the other approach? What constraints drove this decision? What is the plan for the next milestone?

This knowledge lives somewhere. The question is where:

| Where it lives | Durability | Discoverability | Risk |
|---|---|---|---|
| Someone's memory | Gone when they leave | Zero for others | High |
| Chat history | Gone when session ends | Zero outside session | High |
| Model context | Gone at context boundary | Zero for next agent | High |
| Commit messages | Permanent | Medium (requires search) | Low |
| Issue descriptions | Permanent | High (linked to work) | Low |
| ADRs in repo | Permanent | High (indexed, searchable) | Low |
| Docs in repo | Permanent | High | Low |

The pattern is clear: **persistent, in-repo, linked-to-work artifacts win.**

---

## The Core Rule

> **If it matters after this session, it must leave the chat and enter the project system.**

This is the knowledge workflow in one sentence.

---

## Architecture Decision Records

An ADR documents a significant technical decision — one where the alternatives were real and the choice has lasting consequences.

### When to Write an ADR

- Choosing between meaningfully different approaches (REST vs GraphQL, monorepo vs multi-repo)
- Making a decision that would be expensive to reverse
- Making a decision that future contributors will question without context

### When NOT to Write an ADR

- The decision is obvious from the code itself
- The decision follows directly from the toolchain or framework
- The decision is trivial or easily reversible

### Structure

Keep it simple:

```markdown
# ADR-NNN: Title

## Status
Accepted / Superseded by ADR-NNN / Deprecated

## Context
What is the situation? What forces are at play?

## Decision
What did we choose?

## Consequences
What follows from this choice — both good and limiting?
```

ADRs are **immutable records of a point-in-time decision**. If a decision changes, write a new ADR that references and supersedes the old one. Do not edit old ADRs to reflect new reality.

---

## Persistent Planning

Plans are the bridge between intent and execution. The question is always: where should a plan live?

### The Rule of Thumb

| Plan scope | Where it lives |
|---|---|
| This task, this session | Model context or local notes — ephemeral is fine |
| This feature, multiple sessions | GitHub issue or milestone — must persist |
| This architectural direction | ADR — must be in repo |
| This release | Release issue or milestone — must be tracked |

### Anti-Patterns

- **Planning in chat only.** The plan vanishes when the session ends. The next agent starts from zero.
- **Over-planning in repo.** Not every thought needs a document. Plans that are smaller than a single issue do not need their own file.
- **Plans that never update.** A plan written at the start of a feature and never revised becomes misleading. Update or close.

---

## Documentation Doctrine

Documentation should be:

- **Useful** — it answers questions someone will actually have
- **Findable** — it lives where someone would look for it
- **Current** — it reflects the actual state, not a historical one
- **Minimal** — say what needs saying, then stop

### What Belongs in Repo Docs

- How to set up the project (getting started)
- How to run the validation surface (golden commands)
- Architecture overview (what the major pieces are and how they connect)
- ADRs (why things are the way they are)
- Contribution conventions (if the project has multiple contributors)

### What Does NOT Belong in Repo Docs

- Tutorials for standard tools (link to upstream docs)
- API reference that can be generated from code
- Meeting notes or status updates (those belong in the issue tracker)
- Speculative future plans (those belong in issues or milestones)

---

## Context Debt

**Context debt** is knowledge that exists in someone's head — or in a chat log — but not in the project system.

It compounds silently. The original author knows why the code is structured a certain way. The next contributor — human or agent — does not. They make assumptions. Some assumptions are wrong. Quality drifts.

The cure is not exhaustive documentation. It is:

1. **Conventional commit messages** that explain the why
2. **Issue descriptions** that capture the intent
3. **ADRs** for decisions that have lasting consequences
4. **Code that explains itself** through clear naming and structure

Context debt is not a crisis. It is an erosion. The knowledge workflow prevents it from accumulating silently.

---

## Relationship to Other Modules

**Construction** generates context. Every scaffolding decision, toolchain choice, and plan is knowledge that can persist or be lost.

**Change Management** captures context. Commit messages, PR descriptions, and issue threads are all knowledge artifacts — even when they are not called that.

**Delivery** consumes context. Release notes, changelogs, and deployment decisions are only as good as the knowledge available when they are written.

---

## Key Principle

From the [Doctrine](../../DOCTRINE.md):

> **Future agents are also maintainers.** Write for the maintainer who arrives with no prior conversation history.

That maintainer might be a human six months from now. Or an agent in the next session. Either way, the knowledge must be in the project — not in someone's memory.
