# Construction

How software gets built — from project scaffolding to integration-ready changes.

This module governs everything that happens before code reaches a pull request. The central question: how do we set up a project so that both humans and agents produce high-quality, validated work by default?

---

## What This Module Covers

- **Project scaffolding** — setting up structure, config, and toolchain before generation begins
- **Toolchain selection** — choosing the right formatter, linter, type checker, and test runner per ecosystem
- **Validation surface** — golden commands, local/CI parity, deterministic enforcement
- **Agent execution loop** — the bounded task cycle from issue to integration-ready change
- **Session boundaries** — when plans must leave the chat and enter the project system

---

## Documents

| Document                    | What it covers                                                 |
| --------------------------- | -------------------------------------------------------------- |
| [Toolchain](TOOLCHAIN.md)   | Toolchain selection principles — categories, not brands        |
| [Validation](VALIDATION.md) | Golden commands, canonical validation surface, local/CI parity |

The agent execution loop and bounded task patterns are covered in this README below.

---

## The Central Idea

From the [Principles](../../PRINCIPLES.md):

> **The agent should not be trusted to remember standards that the toolchain can enforce.**

This module operationalizes that principle. Instead of telling agents (or humans) to "remember formatting" or "remember type hints," the construction workflow installs a toolchain that enforces them. The agent then operates inside a shaped corridor where the default path is the correct path.

---

## The Agent Execution Loop

Whether a human or an agent is doing the work, the healthiest construction pattern is the same bounded loop:

```text
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

### Human-Agent Collaboration

Humans and agents have different strengths. Agents generate fast but lack judgment. Humans have judgment but are slower. The method works best when they complement each other.

**Roles — Pilot and Navigator:**

- **Pilot** — actively writing code or making decisions
- **Navigator** — reviewing, guiding, catching what the other misses

The roles swap fluidly. A human may pilot during architecture and navigate during implementation. An agent may pilot during boilerplate generation and navigate during code review. Neither role is permanent — they shift based on what the task requires.

**Reviewing agent-generated work:**

The golden command catches mechanical violations. What it does not catch is what the human reviewer should focus on:

- **Intent alignment** — does the code match what was asked, not just what was described?
- **Maintainability** — could a future contributor understand this without the conversation that produced it?
- **Over-engineering** — did the agent add abstractions, utilities, or configurability nobody asked for?
- **Naming and structure** — the linter catches style; the human catches clarity

**The handoff:**

When work transfers between human and agent — or between sessions — no context should live only in the conversation:

- The **issue** captures scope, intent, and current state
- The **branch** captures current code
- The **commit messages** capture decisions made along the way
- The **PR description** captures the summary for review

If a session ends mid-task, the issue should be updated with where things stand. The [Context-Free Contributor test](../knowledge/) applies: could someone pick this up without reading the chat?

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

### The Bootstrap Sequence

The order matters. Scaffolding is not a checklist — it is a sequence with a gate.

```text
1. Create project structure     — directories, entry points, README
2. Configure toolchain          — formatter, linter, type checker, test runner; for Class 2+, structured logging library and linter rules banning raw output
3. Wire golden commands         — just fmt, just lint, just typecheck, just test, just ci
4. Verify: just ci passes       — on a clean project with no application code
5. Wire CI                      — CI runs the same golden commands
6. Begin application logic      — only after the gate passes
```

**The gate:** `just ci` must pass on a clean, empty project before the first line of application logic is written. This is what "constrain first, generate second" means in practice. If the constraints are not active before generation begins, they are not constraints — they are suggestions.

### Agents and the Bootstrap

Agents may generate the scaffold and toolchain configuration. This is not a violation of the method — the constraint is not "humans must write configs." It is "the golden command must pass on a clean project before the first line of app logic."

An agent that sets up a `justfile`, configures `ruff`, wires `pytest`, and verifies `just ci` passes is doing the bootstrap correctly. An agent that starts writing application code and adds linting later is not.

> **The rule is not who writes the config. The rule is that the config is active before generation begins.**

### Configuration Immutability

Toolchain configuration files — linter rules, type checker settings, formatter config, CI pipelines — define the shaped corridor. If an agent can widen the corridor at will, the constraint is illusory.

The rule:

> **Agents can propose code, but toolchain configuration changes require explicit justification.**

An agent that loosens a lint rule or disables a type check to make its code pass is not fixing a problem — it is escaping the cage. The correct response is to fix the code, not the config.

Tier-appropriate flexibility:

- **Tier 1 (Solo/Personal):** Self-review of config changes is fine. You are the human approver.
- **Tier 2+ (Consultancy/Team):** Configuration changes must be separate commits with explicit justification — not buried in feature work. The reviewer should be able to see exactly what changed in the corridor and why.

---

## Relationship to Other Modules

**Change Management** receives the output of this module. A well-constructed change — validated, issue-linked, properly scoped — flows cleanly into the branching and PR workflow.

**Delivery** depends on this module indirectly. The CI pipeline defined here produces the artifacts that the delivery module promotes.

**Knowledge** overlaps with this module. Plans persisted during construction become part of the project's knowledge base.

---

## What's Next: Adversarial Review

Golden commands catch mechanical violations. But some things — architectural drift, pattern violations, security risks — cannot be enforced by tooling alone.

The framework is exploring an **adversarial review gate**: a separate agent (or model) that reviews changes with a different objective than the builder. The builder optimizes for "does it work?" The reviewer optimizes for "how could this break?" This is the last line of defense before integration.

_This section is under development. See [issue #1](https://github.com/discofocx/unified-engineering-method/issues/1) for the full discussion._

---

## Key Principles

From the [Principles](../../PRINCIPLES.md):

1. **Constrain first, generate second.** Scaffold and toolchain before application logic.
2. **Use tools for rules.** Formatters, linters, type checkers, test runners — not prompts.
3. **Small bounded tasks beat giant one-shot generations.** The execution loop enforces this.
4. **Validation is mandatory, not optional.** Golden commands are the gate.
5. **Observability starts at construction.** Structured logging is enforced during construction through linter rules, not deferred to delivery. See [Toolchain — Conditional Categories](TOOLCHAIN.md#conditional-categories).
