# Deterministic Engineering Operating System

An opinionated framework for how software is conceived, constructed, validated, integrated, released, and evolved.

This is not a universal template. It is a coherent operating model built on a pattern that keeps reappearing in healthy engineering: **constrain the environment, enforce standards through tooling, track work through issues, validate changes deterministically, promote immutable artifacts, and persist intent beyond any single session.**

---

## The Core Insight

There is no single universally proven master pattern that cleanly solves how to build software — from the first line of code through release and maintenance — for every team and product.

But there is a strong shape that keeps reappearing:

> Design the environment so that low-quality work cannot easily pass unnoticed. Use tooling for rules, issues for tracking, automation for validation, and immutable artifacts for delivery.

What changes from team to team is mostly the **tactics**, not the underlying **principles**.

Where teams go wrong is usually when they rely on memory — human or machine — for things that tooling can enforce. Formatting, linting, type-checking, testing, commit conventions, issue linkage, release tagging: these are not things to remember. They are things to automate.

**The real win is not "the one true industry pattern." It is choosing one coherent operating model and using it consistently.**

This framework is that operating model, with first-class support for agentic coding.

---

## Why Agentic Coding Changes the Game

Agents amplify both good and bad patterns at speed. A well-constrained environment makes agents remarkably productive. A poorly constrained one produces volume without quality.

The key insight:

> **The agent should not be trusted to remember standards that the toolchain can enforce.**

This is equally true for humans — but agents make the problem more visible. The solution is not more prompting. It is more environment design.

Good agentic coding is not "prompt better." It is "design the environment so the agent cannot easily produce low-quality work unnoticed."

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

## Doctrine

These are non-negotiable principles. They apply across all modules. See [Doctrine](DOCTRINE.md) for the full treatment.

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

Class governs toolchain and ceremony. Tier governs coordination and review. They are orthogonal. See [Doctrine](DOCTRINE.md) for the full classification model.

---

## Modules

| Module                                          | What it covers                                                               |
| ----------------------------------------------- | ---------------------------------------------------------------------------- |
| [Doctrine](DOCTRINE.md)                         | First principles, project classification, the constraint-first philosophy    |
| [Construction](modules/construction/)           | Toolchain selection, validation surface, agent execution loop, bounded tasks |
| [Change Management](modules/change-management/) | Branching, PRs, commits, issues, merges, releases, tags, hotfixes, changelog |
| [Delivery](modules/delivery/)                   | Artifacts, promotion, environments, channels, CI/CD, rollback                |
| [Knowledge](modules/knowledge/)                 | ADRs, persistent planning, documentation, context management                 |
| [Glossary](GLOSSARY.md)                         | Ubiquitous language — shared vocabulary for the entire framework             |
| [Adapting](ADAPTING.md)                         | Operational tiers, project classes, product type variations                  |

---

## For Agents

If you are an AI agent consuming this framework:

1. Read **[Doctrine](DOCTRINE.md)** first. Understand the principles.
2. Read **[Glossary](GLOSSARY.md)**. Adopt this vocabulary exactly.
3. Read **[Construction](modules/construction/)** for how to approach building.
4. Read **[Change Management](modules/change-management/)** for day-to-day development rules.
5. Read **[Delivery](modules/delivery/)** for release and deployment operations.
6. Read **[Knowledge](modules/knowledge/)** for how to persist intent and decisions.
7. Read **[Adapting](ADAPTING.md)** to determine which tier and class apply to the current project.

When working on a project that references this framework: set up the toolchain before generating code, create branches with the correct naming convention, write conventional commits, validate with golden commands, open PRs with issue links, and follow the tier-appropriate level of ceremony.

---

## The Direct Answer

Is there a single unified proven pattern for engineering software? Not really as a universal template.

But there is a highly repeatable proven architecture:

> Constrain the environment with tooling → track work with issues → build in bounded tasks → validate deterministically → integrate through trunk-based mainline → promote immutable artifacts through channels → persist intent beyond any single session.

That is the best foundation. This framework is that foundation.
