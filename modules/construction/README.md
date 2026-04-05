# Construction

How software gets built — framing, scaffolding, toolchain, validation, and the agent execution loop.

This is the module that governs what happens before code reaches a pull request. It answers: how do we set up a project so that both humans and agents produce high-quality, validated work by default?

---

## What This Module Covers

- **Project scaffolding** — setting up structure, config, and toolchain before generation begins
- **Toolchain selection** — choosing the right formatter, linter, type checker, and test runner per ecosystem
- **Validation surface** — golden commands, local/CI parity, deterministic enforcement
- **Agent execution loop** — the bounded task cycle from issue to integration-ready change
- **Session boundaries** — when plans must leave the chat and enter the project system

---

## Documents

| Document | What it covers |
|---|---|
| [Toolchain](TOOLCHAIN.md) | Toolchain selection doctrine — categories, not brands |
| [Validation](VALIDATION.md) | Golden commands, canonical validation surface, local/CI parity |

The agent execution loop and bounded task doctrine are covered in this README below.

---

## The Central Idea

From the [Doctrine](../../DOCTRINE.md):

> **The agent should not be trusted to remember standards that the toolchain can enforce.**

This module operationalizes that principle. Instead of telling agents (or humans) to "remember formatting" or "remember type hints," the construction workflow installs a toolchain that enforces them. The agent then operates inside a shaped corridor where the default path is the correct path.

---

## The Agent Execution Loop

Whether a human or an agent is doing the work, the healthiest construction pattern is the same bounded loop:

```
1. Select issue          — pick a specific, scoped unit of work
2. Inspect codebase      — understand current state, patterns, relevant files
3. State plan            — articulate what will change and why
4. Make focused changes  — implement within the bounded scope
5. Run validation        — execute golden commands (fmt, lint, typecheck, test)
6. Fix until clean       — iterate until the toolchain is satisfied
7. Summarize deltas      — describe what changed for the reviewer
8. Prepare for integration — open PR, link issue, confirm CI
```

This loop is not a suggestion. It is the pattern that produces reliable results at scale.

### Why Bounded Tasks

A task that can be completed, validated, and reviewed in one focused session is more reliable than a sprawling generation that touches everything.

Bounded tasks:

- Have clear entry criteria (the issue)
- Have clear exit criteria (validation passes, PR ready)
- Are resumable (if interrupted, the issue and branch capture state)
- Are reviewable (small enough for a human to audit)
- Compose well (many bounded tasks build a feature)

### Session Boundaries

A critical rule:

> **If a plan matters after this session, it must leave the chat and enter the project system.**

The project system might be GitHub issues, ADRs, milestone documents, or docs in the repository. The form varies. But plans that live only in model context or chat history are ephemeral — they vanish when the session ends.

---

## Project Scaffolding

Before any agent or human starts free-form coding, the repository should already have:

- Project structure (directories, entry points)
- Configuration files (language, framework)
- Formatting rules
- Linting rules
- Type-checking configuration
- Test harness
- CI baseline
- Git ignore
- Basic documentation
- Issue/task conventions

This is where ambiguity gets removed. A well-scaffolded project constrains the solution space before generation begins. That is the point.

### The Scaffold Principle

> **Constrain first, generate second.**

The scaffold is not boilerplate. It is the enforcement layer that makes every subsequent change automatically subject to the project's quality standards.

---

## Relationship to Other Modules

**Change Management** receives the output of this module. A well-constructed change — validated, issue-linked, properly scoped — flows cleanly into the branching and PR workflow.

**Delivery** depends on this module indirectly. The CI pipeline defined here produces the artifacts that the delivery module promotes.

**Knowledge** overlaps with this module. Plans persisted during construction become part of the project's knowledge base.

---

## Key Principles

From the [Doctrine](../../DOCTRINE.md):

1. **Constrain first, generate second.** Scaffold and toolchain before application logic.
2. **Use tools for rules.** Formatters, linters, type checkers, test runners — not prompts.
3. **Small bounded tasks beat giant one-shot generations.** The execution loop enforces this.
4. **Validation is mandatory, not optional.** Golden commands are the gate.
