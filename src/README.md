# The Unified Engineering Method

> _Never trust memory when you can use mechanism._

An opinionated method for how software is conceived, constructed, validated, integrated, released, and evolved — by humans and AI agents alike.

This is not a universal template. It is a coherent operating model built on a pattern that keeps reappearing in healthy engineering: **enforce standards through tooling, track work through issues, validate changes deterministically, promote immutable artifacts, and persist intent beyond any single session.**

The bad code can come from an agent or from a human. The framework does not care. It constrains both.

---

## The Problem

Agentic coding has a honeymoon phase. The first few days are magic — ideas materialize in hours instead of months. Then the project grows, and the magic fades.

The agent starts ignoring the architecture you discussed three sessions ago. Code quality degrades because the standards you wrote down are buried in context the model no longer sees. Documents drift from the implementation. Each project ends up with its own ad-hoc structure — plans in one place, docs in another, conventions in neither. You ship an MVP and then discover it is architecturally disposable: working software that cannot be extended without starting over.

This is not an agent problem. It is an environment problem.

When a non-technical co-founder jumps into a codebase and starts vibe coding without constraints, features fly — but cutting a stable release takes three times as long because nothing enforces consistency. When an experienced engineer trusts the agent to make the right architectural choices unprompted, the result is whatever pattern the model defaults to, not whatever pattern the project needs.

The instinct is to fix this with more prompting — stricter instructions, longer system prompts, more documentation. It does not hold. Prompts get buried. Documents go stale. Rules that live only in text are rules that drift.

Rust developers already know the answer. Cargo, Clippy, and the compiler enforce opinionation so effectively that it is hard to produce bad code by accident. The environment does the constraining — not the developer's memory, and not a prompt.

The question is: **why not generalize that pattern across the entire engineering lifecycle?**

Not just formatting and linting — but branching, commits, validation, releases, deployment, and knowledge persistence. One coherent loop from issue to release, enforced by tooling, repeated every time.

That is what this framework does.

---

## The Core Insight

There is no single universally proven master pattern that cleanly solves how to build software — from the first line of code through release and maintenance — for every team and product.

But there is a strong shape that keeps reappearing:

> Design the environment so that low-quality work cannot easily pass unnoticed. Use tooling for rules, issues for tracking, automation for validation, and immutable artifacts for delivery.

What changes from team to team is mostly the **tactics**, not the underlying **principles**. This framework uses GitHub as its reference implementation — issues, pull requests, labels — but the principles apply to any platform that supports issue tracking, branch-based development, and CI. The method is the discipline; the tools are interchangeable.

Where teams go wrong is usually when they rely on memory — human or machine — for things that tooling can enforce. Formatting, linting, type-checking, testing, commit conventions, issue linkage, release tagging: these are not things to remember. They are things to automate.

**The real win is not "the one true industry pattern." It is choosing one coherent operating model and using it consistently.**

This framework is that operating model, with first-class support for agentic coding.

---

## What This Is (and Isn't)

Nothing in this framework is novel in isolation. Trunk-based development, conventional commits, semantic versioning, architecture decision records, CI/CD pipelines, immutable artifacts — these are established practices with years of proven use.

What is usually missing is the **unification**. Teams adopt some of these practices but not others. They have good CI but no issue discipline. They have conventional commits but no release automation. They have ADRs but no validation surface. Each practice works in isolation; together they form a coherent system — but only if someone connects them deliberately.

UEM is that connective layer. It composes known practices into a single operating model that covers the full lifecycle: from issue to release, repeated every time.

### What UEM draws from

- **Trunk-based development** — short-lived branches, frequent integration to mainline
- **Conventional commits** — structured commit messages that enable automation
- **Semantic versioning** — predictable version contracts
- **Architecture decision records** — persisted design intent
- **CI/CD best practices** — deterministic validation, immutable artifacts, promotion over rebuilding
- **Environment-as-constraint** — the Rust/Cargo insight generalized beyond a single language

### What UEM adds

- **The unification itself** — one coherent model instead of fragmented practices adopted piecemeal
- **Agent-first design** — the same interface for humans and machines, with constraints enforced by tooling rather than prompts
- **Tier and class scaling** — explicit guidance for how ceremony and coordination change as projects and teams grow
- **The core loop** — a repeatable cycle from issue through validation to release that is the same every time, regardless of what you are building

### What UEM is not

- **Not an architecture pattern.** It does not compete with DDD, hexagonal, clean architecture, or any structural design approach. Bring your own architecture.
- **Not a project management methodology.** It does not replace Agile, Scrum, Kanban, or Shape Up. It operates underneath — the engineering reinforcement loop that those methodologies sit on top of.
- **Not a universal template.** It is opinionated by design. It may not fit every team or every product. It solves a specific set of problems — and it is honest about where it stops.

---

## What Changes

| Concern                    | Without                                                                          | With UEM                                                                          |
| -------------------------- | -------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| **Standards**              | Live in docs the agent stops reading after the context window fills up           | Enforced by the toolchain — the agent cannot produce code that violates them      |
| **Work tracking**          | Ad-hoc: some things in issues, some in chat, some in someone's head              | Every meaningful change maps to an issue; work is traceable and resumable         |
| **Validation**             | Manual, inconsistent, or skipped under pressure                                  | One command (`just ci`) runs the full validation surface, locally and in CI       |
| **Code quality over time** | Degrades as the project grows — the first month is magic, the third is a rewrite | Stays predictable because the corridor is enforced, not remembered                |
| **Releases**               | "It works on my machine" or a manual checklist                                   | Tagged, versioned, built once, promoted through channels as immutable artifacts   |
| **Knowledge**              | Lives in chat history that no future session can see                             | Persisted in the project system — ADRs, issues, commit messages, docs in the repo |
| **New contributors**       | Onboarding is tribal knowledge and a long Slack thread                           | The toolchain, conventions files, and issue backlog are the onboarding            |

The difference is not heroic discipline. It is environment design. The method makes the default path the correct path — for humans and agents alike.

---

## Why Agentic Coding Changes the Game

Agents amplify both good and bad patterns at speed. A well-constrained environment makes agents remarkably productive. A poorly constrained one produces volume without quality.

The key insight:

> **The agent should not be trusted to remember standards that the toolchain can enforce.**

This is equally true for humans — but agents make the problem more visible. The solution is not more prompting. It is more environment design.

Good agentic coding is not "prompt better." It is "design the environment so the agent cannot easily produce low-quality work unnoticed."

### How Agents Consume the Method

There is no special integration. The agent interacts with UEM through three layers — the same ones a human uses:

- **Constraint layer** — toolchain configs (formatter, linter, type checker, test runner) enforce standards mechanically. The agent cannot produce code that violates them.
- **Direction layer** — issues scope work into bounded tasks. Conventions files (`CLAUDE.md`, `.cursorrules`, or equivalent) communicate project-specific expectations that the toolchain cannot enforce.
- **Validation layer** — golden commands (`just ci`) provide a single entry point for pass/fail verification. The agent runs them; the toolchain declares success.

The method does not require a particular agent, IDE, or integration. Any agent that can read files, write code, and run shell commands can operate inside a UEM-shaped project. The environment does the constraining — the agent just needs to be pointed at it.

---

## The Meta-Pattern

A healthy engineering system separates four concerns:

| Concern               | Responsibility                                                 | Module                                          |
| --------------------- | -------------------------------------------------------------- | ----------------------------------------------- |
| **Construction**      | How work is framed, constrained, and validated during building | [Construction](modules/construction/)           |
| **Change Management** | How changes are tracked, reviewed, and integrated              | [Change Management](modules/change-management/) |
| **Delivery**          | How artifacts move through environments and channels           | [Delivery](modules/delivery/)                   |
| **Knowledge**         | How intent, decisions, and context persist                     | [Knowledge](modules/knowledge/)                 |

Once those are clearly separated, everything becomes coherent.

In one sentence:

> A healthy engineering system separates construction, change management, delivery, and knowledge persistence.

---

## The Core Loop

The smallest unit of work in UEM is the **bounded task** — a single, scoped change tied to an issue, executed through a repeatable loop, and validated before integration. This loop is the operational spine of the method. It is the same every time, regardless of what you are building or who is building it.

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

This is the cycle that produces predictable results. A human follows it. An agent follows it. The toolchain enforces the quality gates within it. See [Construction](modules/construction/) for the full treatment — bounded task rationale, session boundaries, and project scaffolding.

---

## Principles

These are non-negotiable. They apply across all modules. See [Principles](PRINCIPLES.md) for the full treatment.

1. **Constrain first, generate second.** The scaffold and toolchain come before the first line of application logic.
2. **Use tools for rules.** Anything enforceable by tooling should not rely on prompts or memory.
3. **Persist all meaningful plans.** Intent that exists only in chat history is lost intent.
4. **Every meaningful change maps to an issue.** Work should be traceable and resumable.
5. **Small bounded tasks beat giant one-shot generations.** Scope control improves quality.
6. **Validation is mandatory, not optional.** The toolchain declares success, not the agent.
7. **Future agents are also maintainers.** Write for the maintainer who arrives with no prior conversation history.

---

## Operational Tiers

The framework scales across three operational tiers. Every project falls into one:

| Tier                   | Description                                                | Coordination                 |
| ---------------------- | ---------------------------------------------------------- | ---------------------------- |
| **Solo / Personal**    | No external users. Low ceremony.                           | Self-directed                |
| **Solo / Consultancy** | Real users or client. Traceability matters.                | Self-review with audit trail |
| **Small Team**         | Multiple developers, real users. Coordination and rollout. | Peer review, channels        |

Projects move up tiers as they grow. The framework adds ceremony without restructuring. See [Adapting](ADAPTING.md) for full details.

---

## Project Classification

Not all projects deserve the same strictness on day one:

| Class | Name               | Ceremony                                    |
| ----- | ------------------ | ------------------------------------------- |
| **0** | Scratchpad         | Minimal. Formatter + basic structure.       |
| **1** | Prototype          | Linter + tests. Issues optional.            |
| **2** | Product Seed       | Full toolchain. Issues required. CI wired.  |
| **3** | Long-Lived Product | Everything. ADRs. Release channels. Review. |

Class governs toolchain and ceremony. Tier governs coordination and review. They are orthogonal. See [Principles](PRINCIPLES.md) for the full classification model.

---

## Modules

| Module                                          | What it covers                                                               |
| ----------------------------------------------- | ---------------------------------------------------------------------------- |
| [Principles](PRINCIPLES.md)                     | First principles, project classification, the constraint-first philosophy    |
| [Construction](modules/construction/)           | Toolchain selection, validation surface, agent execution loop, bounded tasks |
| [Change Management](modules/change-management/) | Branching, PRs, commits, issues, merges, releases, tags, hotfixes, changelog |
| [Delivery](modules/delivery/)                   | Artifacts, promotion, environments, channels, CI/CD, rollback                |
| [Knowledge](modules/knowledge/)                 | ADRs, persistent planning, documentation, context management                 |
| [Glossary](GLOSSARY.md)                         | Ubiquitous language — shared vocabulary for the entire framework             |
| [Adapting](ADAPTING.md)                         | Operational tiers, project classes, product type variations                  |

---

## Getting Started

Whether you are a human adopting this framework or an AI agent consuming it, the reading order is the same:

1. **[Principles](PRINCIPLES.md)** — Understand the principles. Everything else follows from these.
2. **[Glossary](GLOSSARY.md)** — Learn the vocabulary. Use it consistently.
3. **[Construction](modules/construction/)** — How to set up projects and build correctly.
4. **[Change Management](modules/change-management/)** — Day-to-day development: branches, PRs, commits, issues.
5. **[Delivery](modules/delivery/)** — Release and deployment: artifacts, promotion, channels.
6. **[Knowledge](modules/knowledge/)** — How to persist intent, decisions, and context.
7. **[Adapting](ADAPTING.md)** — Determine which tier and class apply to your project.

Then: set up the toolchain before generating code, create branches with the correct naming convention, write conventional commits, validate with golden commands, open PRs with issue links, and follow the tier-appropriate level of ceremony.

---

## The Direct Answer

Is there a single unified proven pattern for engineering software? Not really as a universal template.

But there is a highly repeatable proven architecture:

> Constrain the environment with tooling → track work with issues → build in bounded tasks → validate deterministically → integrate through trunk-based mainline → promote immutable artifacts through channels → persist intent beyond any single session.

That is the best foundation. This framework is that foundation.

---

## Origin

This framework is the synthesis of 15 years building software and 3 years coding with AI agents. It is opinionated by design. It does not claim to solve every problem or fit every team. It solves the problems I have encountered repeatedly — and it encodes the patterns that have consistently produced good outcomes.

It is also a living document. The principles are stable. The tactics will evolve as tools, ecosystems, and agents improve. What will not change: the conviction that discipline belongs in tooling, not in memory.

— Gerardo Sorchini
