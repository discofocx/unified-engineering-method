# Principles

First principles. Non-negotiable across all modules.

Tactics flex; principles do not. If you find yourself working around a principle instead of applying it, the framework needs revision — not a workaround.

---

## The Core Insight

Good engineering — especially with agents — is not about remembering every standard every time. It is about designing the environment so that low-quality work cannot easily pass unnoticed.

> **The agent should not be trusted to remember standards that the toolchain can enforce.**

This applies equally to humans. The difference is that agents make the problem more visible: they amplify both good and bad patterns at speed. The solution is not more reminders. It is more environment design.

---

## The Seven Principles

### 1. Constrain First, Generate Second

Do not start producing code before the environment and standards exist. The scaffold, the toolchain, the linting rules, the test harness — these come before the first line of application logic.

A well-constrained environment makes the default path the correct path.

### 2. Use Tools for Rules

Anything enforceable by tooling should not rely on prompts, memory, or convention alone.

- Formatting → formatter
- Style and correctness → linter
- Type discipline → type checker
- Behavior → test runner
- Structure → project templates
- Work decomposition → issue tracker
- Change lifecycle → git workflow
- Integration quality → CI

If a rule exists only in documentation, it will drift. If it exists in tooling, it holds.

### 3. Persist All Meaningful Plans

If a plan matters beyond the current session, it must leave the ephemeral context and enter the project system.

The project system might be: GitHub issues, ADRs, milestone documents, PR descriptions, or docs in the repository. The form varies. The principle is constant: **intent that exists only in chat history is lost intent.**

### 4. Every Meaningful Change Maps to an Issue

Work should be traceable and resumable. An issue provides:

- A reason (why are we doing this?)
- A scope (what does "done" look like?)
- A record (what happened?)

Agents and humans both benefit from this structure. An agent resuming work from an issue has context. An agent resuming work from a vague memory does not.

### 5. Small Bounded Tasks Beat Giant One-Shot Generations

Scope control improves quality. A task that can be completed, validated, and reviewed in one focused session is more reliable than a sprawling generation that touches everything.

The pattern: select issue → understand scope → state plan → make focused change → run validation → fix until clean → summarize → prepare for integration.

### 6. Validation Is Mandatory, Not Optional

The agent — or the human — does not declare success. The toolchain does.

Success means:

- Formatter clean
- Lint clean
- Type check clean
- Tests green
- Build passes
- CI passes
- PR reviewable
- Linked to issue

Skipping validation is not a shortcut. It is deferred cost with interest.

### 7. Future Agents Are Also Maintainers

Code and project state must be understandable by a later model — or a later human — with partial context. This means:

- Clear commit messages
- Linked issues
- Documented decisions
- Conventional structure
- No tribal knowledge that lives only in someone's head

Write for the maintainer who arrives with no prior conversation history.

---

## Project Classification

Not all projects deserve the same level of ceremony on day one. The framework scales by **project class**.

| Class | Name               | Description                                                     | Typical Ceremony                                    |
| ----- | ------------------ | --------------------------------------------------------------- | --------------------------------------------------- |
| **0** | Scratchpad         | Throwaway experiments, spikes, learning exercises               | Minimal. Formatter + basic structure.               |
| **1** | Prototype          | Real structure, basic toolchain, limited expected lifespan      | Linter + tests. Issues optional.                    |
| **2** | Product Seed       | Intended to ship or serve users. Full toolchain from the start. | Full validation surface. Issues required. CI wired. |
| **3** | Long-Lived Product | Multiple contributors, real users, durability matters           | Everything. ADRs. Release channels. Review.         |

### Rules

- Start at the class that matches your realistic intent, not your aspirational one.
- Moving up classes means **adding ceremony**, not restructuring. If you followed the principles at Class 1, the upgrade to Class 2 is smooth.
- Moving down is rare and usually means you misjudged the project's purpose.
- The class determines which parts of the framework apply and how strictly. See [Adapting](ADAPTING.md).

### The Relationship Between Class and Tier

**Project class** describes the project's durability and quality requirements. **Operational tier** (see [Adapting](ADAPTING.md)) describes the team shape and audience. They are orthogonal:

- A solo developer can build a Class 3 long-lived product (Tier 1, Class 3)
- A small team can spike a throwaway prototype (Tier 3, Class 0)

Class governs how much toolchain and ceremony. Tier governs how much coordination and review.

---

## The Meta-Pattern

A healthy engineering system separates these concerns:

| Concern               | Responsibility                                                 | Module                                          |
| --------------------- | -------------------------------------------------------------- | ----------------------------------------------- |
| **Construction**      | How work is framed, constrained, and validated during building | [Construction](modules/construction/)           |
| **Change management** | How changes are tracked, reviewed, and integrated              | [Change Management](modules/change-management/) |
| **Delivery**          | How artifacts move through environments and channels           | [Delivery](modules/delivery/)                   |
| **Knowledge**         | How intent, decisions, and context persist                     | [Knowledge](modules/knowledge/)                 |

The unifying principles across all four:

- **Explicitness** over implicit assumptions
- **Determinism** over best-effort
- **Traceability** over trust
- **Immutability** over mutation
- **Repeatability** over one-off heroics

---

## Applying the Principles

When evaluating any process decision, ask:

> "Am I relying on memory, or on mechanism?"

If the answer is memory — for a human or an agent — find the mechanism. That is the framework in one sentence.
