# Adapting

How the framework scales by team shape, user exposure, product type, and project class.

The principles are universal. The tactics flex.

---

## By Team and Audience

The framework defines three operational tiers. Every project falls into one.

### Tier 1: Solo / Personal

Projects with no external users (yet). You are the only developer and the only audience.

| Concern           | Adaptation                                                                                               |
| ----------------- | -------------------------------------------------------------------------------------------------------- |
| **Branches**      | Short-lived branches recommended, but direct commits to `main` are acceptable for small changes          |
| **PRs**           | Optional. Useful for self-review on larger changes, but not required for every commit                    |
| **Issues**        | Lightweight. TODOs, a simple list, or GitHub issues — whatever keeps you honest without slowing you down |
| **Commits**       | Conventional commits still recommended — they cost nothing and pay off if the project grows              |
| **CI**            | Lint + test minimum. A passing `main` is still the goal                                                  |
| **Channels**      | `dev` + `stable` only                                                                                    |
| **Environments**  | Local + production (or none)                                                                             |
| **Release notes** | Tag message is enough                                                                                    |
| **Hotfixes**      | Fix on `main`, tag a new patch version                                                                   |
| **Artifacts**     | May be informal (local builds), but still tag what you ship                                              |

**The principle that still holds:** `main` is the source of truth, artifacts are immutable once shipped, tags mark releases.

**What relaxes:** ceremony around PRs, issues, and multi-stage promotion.

---

### Tier 2: Solo / Consultancy

You are the only developer, but the project has real users or a client. Accountability and traceability matter.

| Concern           | Adaptation                                                                                   |
| ----------------- | -------------------------------------------------------------------------------------------- |
| **Branches**      | Required. Every change gets a branch                                                         |
| **PRs**           | Required. The audit trail matters — clients, compliance, and your future self will thank you |
| **Issues**        | Required. Tracked work gives the client visibility and gives you a paper trail               |
| **Commits**       | Conventional commits required. Changelog generation becomes valuable                         |
| **CI**            | Full pipeline — lint, test, build, static analysis                                           |
| **Channels**      | `dev` + `beta` + `stable`                                                                    |
| **Environments**  | Dev + staging + production                                                                   |
| **Release notes** | Required. Client communication, not just internal record                                     |
| **Hotfixes**      | Branch from tag, full validation, patch release, merge back to `main`                        |
| **Artifacts**     | Formal. Traceable to commit, tag, and pipeline                                               |

**The principle that still holds:** everything from Tier 1, plus full traceability and auditability.

**What relaxes:** you skip canary (no traffic to split), and review is self-review (but still happens via PR).

---

### Tier 3: Small Team

Multiple developers, real users. Coordination, review, and controlled rollout all matter.

| Concern           | Adaptation                                                            |
| ----------------- | --------------------------------------------------------------------- |
| **Branches**      | Required. Strictly short-lived                                        |
| **PRs**           | Required. Review by another human is the point                        |
| **Issues**        | Required. Team coordination demands tracked work with clear ownership |
| **Commits**       | Conventional commits required                                         |
| **CI**            | Full pipeline                                                         |
| **Channels**      | `dev` + `canary` + `beta` + `stable`                                  |
| **Environments**  | Dev + staging + production                                            |
| **Release notes** | Required. Team + user communication                                   |
| **Hotfixes**      | Branch from tag, full flow, peer review even under pressure           |
| **Artifacts**     | Formal with full provenance                                           |

**The principle that still holds:** everything from Tier 2, plus peer review and channel-based rollout.

**What adds:** canary deployments, multi-reviewer PRs, team-visible issue boards.

---

### Tier Summary

|                           | Solo / Personal            | Solo / Consultancy                                  | Small Team                                    |
| ------------------------- | -------------------------- | --------------------------------------------------- | --------------------------------------------- |
| PRs                       | Optional                   | Required (self-review)                              | Required (peer review)                        |
| Issues                    | Lightweight                | Required                                            | Required                                      |
| Channels                  | `dev` + `stable`           | `dev` + `beta` + `stable`                           | `dev` + `canary` + `beta` + `stable`          |
| Environments              | Local + prod               | Dev + staging + prod                                | Dev + staging + prod                          |
| CI                        | Lint + test                | Full pipeline                                       | Full pipeline                                 |
| Release notes             | Tag message                | Required                                            | Required                                      |
| Hotfixes                  | Fix on `main`              | Branch from tag                                     | Branch from tag + review                      |
| **Toolchain**             | Formatter + linter minimum | Full (formatter, linter, type checker, test runner) | Full, CI-enforced                             |
| **Structured logging**    | Not required               | Required for Class 2+                               | Required, CI-enforced                         |
| **Golden commands**       | `fmt` + `test` minimum     | All four (`fmt`, `lint`, `typecheck`, `test`, `ci`) | All, CI-enforced                              |
| **Agent constraints**     | CLAUDE.md with basic rules | CLAUDE.md + toolchain config                        | CLAUDE.md + toolchain config + review gates   |
| **Knowledge persistence** | README, inline comments    | README + ADRs for significant decisions             | README + ADRs + persistent plans + milestones |
| **Session boundaries**    | Flexible                   | Defined per issue                                   | Strictly bounded per issue                    |

### Growing Between Tiers

Projects move up tiers. They rarely move down. When your personal project gets its first user, you are in Tier 2. When you add a second developer, you are in Tier 3.

The framework is designed so that moving up means **adding ceremony**, not restructuring. If you followed conventional commits in Tier 1, your changelog is ready for Tier 2. If you tagged releases in Tier 2, your promotion model is ready for Tier 3.

### Mixed-Skill Teams

A common real-world pattern: a team where some members are experienced engineers and others are newer developers or vibe coders using AI to produce code.

**What goes wrong without the framework:** Experienced engineers work from internalized standards — years of pattern recognition that they apply unconsciously. They might manage their own agent rules, their own linter configs, their own workflows. None of that transfers to vibe coders. You cannot compress 15 years of engineering judgment into a workshop. Without shared, enforced constraints, the vibe-coded contributions degrade the codebase while passing a code review that checks for style but not substance.

**The constraint corridor as equalizer:** The toolchain does not care who wrote the code. When the constraint corridor is enforced — formatter, linter, type checker, tests, golden commands — every contribution passes the same bar. The vibe coder says _what_ they want. The agent reads the project protocol, scans the constraints, and produces compliant code. The vibe coder may not even realize the guardrails are there. Training wheels they never have to think about.

**Agent instructions do not vary by user.** The `CLAUDE.md`, the toolchain config, the golden commands — these are project-level, not person-level. If the agent needs different instructions depending on who invoked it, the instructions are too weak. Strengthen the constraints; do not fork them.

**Onboarding differs, toolchain does not.** The framework itself may benefit from different entry points for different experience levels — a senior engineer reads the principles and skips to construction; a vibe coder needs the "why" before the "how." But the actual toolchain setup, the golden commands, the constraint corridor — identical for everyone.

**The skill floor is really an intent floor.** Below a certain threshold, the framework actively hurts — but the threshold is not about skill. It is about intent. Someone vibe coding for fun, with no users, no collaborators, no durability concerns, gains nothing from enforcing UEM. That is a Class 0 / Tier 1 project by definition. The framework does not apply because the project does not need it. The decision is about classification and tier, not about gatekeeping by experience level.

---

## By Project Class

Orthogonal to both tier and product type. Project class describes durability and quality requirements. See [Principles](PRINCIPLES.md) for the full classification model.

| Class                      | Name                             | Toolchain                                     | Issues   | CI       | Knowledge                        |
| -------------------------- | -------------------------------- | --------------------------------------------- | -------- | -------- | -------------------------------- |
| **0 — Scratchpad**         | Throwaway experiments            | Formatter only                                | No       | No       | None required                    |
| **1 — Prototype**          | Real structure, limited lifespan | Formatter + linter + tests                    | Optional | Optional | README                           |
| **2 — Product Seed**       | Intended to ship                 | Full toolchain + structured logging           | Required | Required | README + ADRs                    |
| **3 — Long-Lived Product** | Durability matters               | Full toolchain + structured logging, enforced | Required | Required | README + ADRs + persistent plans |

### Class and Tier Together

|             | Solo / Personal | Solo / Consultancy | Small Team         |
| ----------- | --------------- | ------------------ | ------------------ |
| **Class 0** | Common          | Rare               | Rare (spikes only) |
| **Class 1** | Common          | Common             | Uncommon           |
| **Class 2** | Possible        | Common             | Common             |
| **Class 3** | Possible        | Possible           | Common             |

A solo developer building a long-lived CLI tool is Tier 1, Class 3. A small team spiking a prototype is Tier 3, Class 0. The tier adds coordination ceremony; the class adds toolchain and knowledge ceremony.

---

## By Product Type

Orthogonal to team tier. A solo developer can ship a SaaS; a small team can ship a CLI tool. The tier governs ceremony and coordination. The product type governs distribution mechanics.

### Libraries

- Artifact = published package (npm, PyPI, crates.io, etc.)
- Channel mapping may use package tags (`latest`, `next`, `beta`)
- "Deployment" means publishing to a registry
- Rollback means publishing a new patch or yanking a version

### SaaS / Backend Services

- Artifact = container image or deployment bundle
- Environments are literal infrastructure (dev cluster, staging cluster, production)
- Canary is a traffic-split deployment
- Rollback is redeploying the previous image

### Desktop Applications

- Artifact = installer, DMG, MSI, zip
- Channels may map to update tracks (stable, beta)
- Distribution may involve signing, notarization, update servers
- Rollback is publishing a new version pointing users to update

### Mobile Applications

- Artifact = IPA, APK, AAB
- Distribution goes through App Store / Play Store review
- Channels map to TestFlight, internal tracks, phased rollout percentages
- Rollback is often a new release (stores rarely allow true rollback)
- Build numbers add an extra layer of versioning

### CLI Tools

- Artifact = platform-specific binaries, Homebrew formula, package
- Channels may map to Homebrew taps, GitHub release tags, or install scripts
- Distribution may involve multiple package managers simultaneously

---

## When Adoption Is Hard

The framework describes the system as if everyone follows it, context is clean, and teams are aligned. Reality is messier.

### What Kills Adoption

Before AI, ceremony fell on humans. Writing issues, maintaining boards, running retrospectives — all of it consumed developer time that felt better spent shipping features. Producers became ceremony cops. Teams complied unevenly. The result was always the same: ceremony decayed into theater, then collapsed.

The paradigm shift: AI handles ceremony. An agent writes the issue description, keeps the project map current, drafts the ADR. The human provides direction; the agent maintains the paper trail. When ceremony costs near-zero, the calculus changes — you can afford discipline because you are not paying for it with engineering hours.

If your team cannot use AI for ceremony (policy restrictions, tooling gaps), expect adoption to require a dedicated human owner — a producer, tech lead, or rotating role — who treats process maintenance as real work, not overhead.

### The Irreducible Core

Under deadline pressure, what survives?

**The construction loop.** Golden commands, the constraint corridor, the validate-before-commit cycle. Even a hotfix follows the loop. You do not need an epic to ship an emergency fix, but you do need the formatter, linter, and tests to pass before it merges.

If you adopt exactly three things:

1. **Agent protocol** — `CLAUDE.md` (or equivalent) that tells agents how to work in this codebase. This is level-zero setup.
2. **Constraint corridor** — formatter, linter, type checker, tests, wired into golden commands and enforced by pre-commit hooks or CI.
3. **Planning discipline** — work decomposed into epics and issues, vertical slices, every PR maps to an issue.

Everything else is valuable but droppable in a crisis. These three are not.

### Partial Adoption

Teams often adopt some modules and skip others. This is fine — the framework is designed for it. The modules are loosely coupled:

- **Construction alone** still improves code quality. Golden commands work without issues, ADRs, or delivery pipelines.
- **Construction + Change Management** adds traceability. You know what changed, why, and who asked for it.
- **Construction + Change Management + Delivery** adds predictable releases. Each layer compounds.
- **Knowledge** operates above the other three — it feeds planning and captures decisions at any stage.

What does not work: adopting Change Management or Delivery without Construction. If the constraint corridor is not enforced, traceability and release discipline are built on sand.

### Ceremony Theater

The failure mode where the form is followed but the substance is absent. Issues opened with empty descriptions. ADRs written after the decision is irreversible. Sprint retrospectives where nothing changes.

The signal: if removing the ceremony would change nothing about how the team works, it is theater.

The fix is not more ceremony — it is fewer, sharper constraints. A pre-commit hook that fails is worth more than a review checklist that gets rubber-stamped. Automate what you can enforce; drop what you cannot.

---

## From Chaos to Constraint

Most teams are not starting fresh. They have existing codebases with zero ADRs, flaky tests, and no golden commands. This section is for them.

### The Ratchet Principle

You do not need 100% compliance on day one. You need a constraint that prevents regression:

- "Test coverage cannot decrease from its current level."
- "No new files without formatting."
- "All new code must pass the linter, even if legacy code does not."

The ratchet only turns one way. Each commit leaves the project slightly more constrained than before.

If constraints feel wrong — too tight for what you are building, or too loose for what you need — the problem is usually classification, not the ratchet. A prototype classified as a long-lived product will feel over-constrained. A product classified as a prototype will feel reckless. Fix the classification; the constraints follow.

### Accept the Baseline

The biggest trap in brownfield migration: running the formatter and linter on a legacy codebase, seeing hundreds of violations, and spending days making old code compliant. It feels productive. It is a trap.

Instead, accept the current state as baseline:

- **Linter baselines** — most linters support baseline files (SwiftLint, ESLint `--no-error-on-unmatched-pattern`, Clippy `allow` attributes). Record current violations; enforce rules only on new code.
- **Selective rule adoption** — start with rules that can auto-fix (formatting, import order). Add rules that require manual intervention only when you have capacity.
- **Forward-only enforcement** — the pre-commit hook checks changed files, not the entire codebase.

The goal: start enforcing UEM without rewriting the codebase. You will clean up legacy code over time, as you touch it. Not in a dedicated sprint that delays real work.

### Module Adoption Order

The order matters. For brownfield projects:

1. **Knowledge** — understand what you are working with before you constrain it. Write a project map. Capture the current architecture, even if it is ugly. This gives agents (and new humans) the context they need.
2. **Construction** — get the formatter and linter running with baselines. Wire golden commands. Immediate, visible, low-risk wins.
3. **Change Management** — start tracking work in issues. Adopt conventional commits. Link PRs to issues.
4. **Delivery** — automate what you are currently doing manually. This comes last because it builds on everything above.

For greenfield projects, Construction comes first because there is no existing state to understand. For brownfield, Knowledge leads because you cannot constrain what you do not understand.

### Class Transition

Incrementally move a brownfield project up the class ladder:

| Step | What you add                          | Class transition                  |
| ---- | ------------------------------------- | --------------------------------- |
| 1    | Formatter + baselines                 | Unconstrained → Class 0 compliant |
| 2    | Linter + tests on new code            | → Class 1                         |
| 3    | Full toolchain + issues + CI          | → Class 2                         |
| 4    | ADRs + persistent plans + enforced CI | → Class 3                         |

Each step is a PR, not a rewrite. Each step is reversible if it does not fit.

### When the Ratchet Pays Off

Benefits start within days — the first time an agent produces code that passes the constraint corridor, you see the difference in quality. But the compound payoff takes longer: fewer regressions, faster onboarding, predictable releases. These are measured in weeks and months, not days. The early cost (slower shipping while the corridor takes hold) is real. Frame it honestly with stakeholders — this is an investment, not a quick win.

For a hands-on starting point, see the [Brownfield Audit quickstart](QUICKSTART-AUDIT.md).

---

## Anti-Patterns

The framework defines what to do. This section defines what hollows it out — failure modes where the method is technically followed but produces none of its intended benefits. Each module has its own local anti-patterns (see [Planning](modules/change-management/PLANNING.md) and [Knowledge](modules/knowledge/README.md)). The patterns below are systemic — they cut across modules and erode the method as a whole.

### Ceremony Theater

**The failure:** Issues opened with empty descriptions. ADRs written after the decision is shipped. Sprint retrospectives where nothing changes. The form is followed; the substance is absent.

**The signal:** If you removed the ceremony, nothing about how the team works would change. The issue board is a scoreboard, not a planning tool. The ADR folder is an archive, not a decision record.

**The fix:** Fewer, sharper constraints. Replace review checklists with automated checks. If an issue description is empty, the issue is noise — close it or fill it. If an ADR is written post-hoc, call it a postmortem, not a decision record.

### The Golden Lie

**The failure:** A validation surface that passes when the code is broken. Skipped tests, disabled linter rules, `# type: ignore` on every line, `@pytest.mark.skip` on flaky tests. The golden commands run green. The product ships broken.

**The signal:** `just ci` passes but bugs reach production. Test coverage is high but regressions are frequent. The validation surface has not failed in weeks — which means it has stopped detecting anything.

**The fix:** The validation surface must be able to fail. If it cannot, it is not a constraint — it is decoration. Audit skipped tests quarterly. Treat broad linter suppressions (`noqa`, `eslint-disable-next-line` applied wholesale) as tech debt. A green CI that cannot catch a real bug is worse than no CI — it provides false confidence.

### The Prompt Trap

**The failure:** Fixing a recurring bug by prompting the agent more carefully instead of adding a constraint that catches the error mechanically. The same class of mistake appears, gets fixed manually, appears again. The human compensates with increasingly detailed prompts. The agent still forgets.

**The signal:** You are writing the same feedback in code review more than twice. You are adding increasingly specific instructions to `CLAUDE.md` for issues that a linter rule, type annotation, or test would catch.

**The fix:** If you are fixing the same class of bug twice, the problem is a missing constraint, not a prompting problem. Add the test. Add the type. Add the linter rule. Move enforcement from memory to tooling — that is the core doctrine.

### Constraint Erosion

**The failure:** Gradually weakening the toolchain to unblock work. Disabling strict mode to ship faster. Adding broad lint exceptions because the legacy code cannot comply. Loosening type checking because a dependency has bad types. Each change is small and justified. The cumulative effect is an unconstrained environment.

**The signal:** The number of lint suppressions, type-ignore comments, or skipped tests trends upward over time. The constraint corridor that was set up in week one is unrecognizable by month three.

**The fix:** Treat constraint removal like a ratchet release — it requires explicit justification. Log suppressions. Review them periodically. If a rule is suppressed more often than enforced, either fix the code or remove the rule honestly — do not leave a rule that is 80% disabled.

### Knowledge Theater

**The failure:** Documentation that exists but is never read. A project map from six months ago that describes a different architecture. A `CONTRIBUTING.md` that references a defunct workflow. ADRs that contradict the current implementation. The knowledge layer looks complete. It is actually misleading.

**The signal:** New contributors (human or agent) read the docs and produce code that does not fit the current architecture. The project map sends agents to files that no longer exist. Someone says "just ignore that document, it is outdated."

**The fix:** Wrong documentation is worse than no documentation. If a document is not maintained, delete it or mark it as archived. Apply the context-free contributor test: can someone with no prior context read your documentation and produce a correct first contribution? If not, the knowledge layer is failing.

### The Ratchet Stall

**The failure:** Adopting the ratchet principle in theory but never tightening it in practice. The baseline is set on day one. No new constraints are added. The codebase improves only in the areas that were already constrained. Everything else stays frozen.

**The signal:** The same lint rules have been active for months with no additions. Test coverage has not moved. The `justfile` has not changed since setup. The team says "we are doing UEM" but the constraint corridor is the same width it was at adoption.

**The fix:** Schedule periodic ratchet reviews. Every few weeks, ask: can we enable one more lint rule? Can we add tests to one more untested module? Can we remove one baseline suppression? The ratchet does not turn itself.

---

## Governance and Exceptions

Every framework needs an escape hatch.

### When to Bend the Rules

- Emergency production fixes may skip full review ceremony (but still get reviewed after)
- Spike branches may not map to formal issues
- Prototype work may skip CI enforcement temporarily
- Some changes (config, docs) may not need full PR ceremony
- Tier 1 projects can skip most ceremony by design

### When NOT to Bend the Rules

- Artifacts are always immutable — no exceptions
- Production always receives tagged releases — no exceptions (once you have users)
- Hotfixes always merge back to `main` — no exceptions
- Rollback never means rebuilding from old source — no exceptions

### The Test

If you are about to make an exception, ask:

> "Am I bending a tactic or breaking a principle?"

Bending tactics is fine. Breaking principles means the framework is failing and needs to be revisited, not worked around.

---

## Building Your Own Instance

To adopt this framework for a specific project:

1. **Pick your tier.** Solo/personal, solo/consultancy, or small team.
2. **Pick your class.** Scratchpad, prototype, product seed, or long-lived product.
3. **Start with the glossary.** Make sure everyone (including agents) agrees on the vocabulary.
4. **Set up the toolchain.** Formatter, linter, type checker, test runner. See [Construction](modules/construction/).
5. **Wire the golden commands.** `just fmt`, `just lint`, `just typecheck`, `just test`, `just ci`.
6. **Pick your merge policy.** Squash merge is the default recommendation.
7. **Define your artifact type.** What does CI produce?
8. **Map your environments.** What infrastructure do you deploy to?
9. **Map your channels.** What audiences do you serve?
10. **Define your promotion gates.** What checks must pass before promotion?
11. **Document your exceptions.** What rules can bend and which cannot?

The framework is the skeleton. The tier and class set the weight. Each project fills in the muscle.
