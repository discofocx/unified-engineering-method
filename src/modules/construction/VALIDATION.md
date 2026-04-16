# Validation

Golden commands, the canonical validation surface, and local/CI parity.

---

## Golden Commands

A **golden command** is a canonical entry point into the project's validation surface. Instead of the developer or agent guessing whether to run `ruff check`, `python -m pytest`, `mypy src`, or `uv run ...`, the project exposes a small, stable set of commands that do the right thing.

### The Standard Set

Every project should expose these commands:

| Command          | Purpose                          |
| ---------------- | -------------------------------- |
| `just fmt`       | Run the formatter (fix mode)     |
| `just lint`      | Run the linter                   |
| `just typecheck` | Run the type checker             |
| `just test`      | Run the test suite               |
| `just ci`        | Run all of the above in sequence |

The recommended runner is [`just`](https://github.com/casey/just) — a modern command runner designed for project tasks, not build systems. It requires no `.PHONY` boilerplate, has clear error messages, works cross-platform, and supports `just --list` for discoverability.

Alternatives that also work:

- `Makefile` targets
- `package.json` scripts (`npm run fmt`, `npm run lint`, etc.)
- `task` targets (Taskfile)
- Shell scripts in a `scripts/` directory

What matters is:

1. **Stable names.** The commands do not change when the underlying tool changes.
2. **One command, one concern.** Each golden command maps to one validation category.
3. **Composable.** `just ci` runs all of them. Individual commands can be run alone.
4. **Discoverable.** A new developer or agent can find them without reading implementation details.

### Why This Matters

Golden commands reduce cognitive branching. Instead of:

> "Is it `ruff check .` or `ruff check src`? Do I need `--fix`? Is it `pytest` or `python -m pytest`? Does the type checker need special flags?"

The answer is always:

> `just lint`, `just test`, `just typecheck`.

This is powerful for both humans and agents. Agents, in particular, benefit from stable entry points because they eliminate a class of guessing errors.

---

## The Validation Surface

The **validation surface** is the complete set of golden commands that prove a change is integration-ready.

Running `just ci` — or its equivalent — is the gate before any PR or commit to `main`.

### What the Validation Surface Proves

| Check                 | What it proves                                                                  |
| --------------------- | ------------------------------------------------------------------------------- |
| Formatter passes      | Code style is consistent                                                        |
| Linter passes         | No known bad patterns, no obvious mistakes, logging conventions enforced        |
| Type checker passes   | Interfaces are honored, types are sound                                         |
| Tests pass            | Behavior is correct, regressions are caught                                     |
| Build succeeds        | The project compiles / packages correctly                                       |
| Config linting passes | CI workflows and infrastructure config are syntactically and semantically valid |

The validation surface includes configuration files, not just source code. CI workflows, Docker configs, and infrastructure-as-code should be linted with the same rigor as application code. See [Toolchain — Conditional Categories](TOOLCHAIN.md#conditional-categories) and [Infrastructure as Code](../delivery/CI-CD.md#infrastructure-as-code).

If all golden commands pass, the change is **mechanically valid**. It may still have design problems or incorrect logic that tests do not cover — but it has passed every automated check the project offers.

### Constraint Hierarchy

Not all validation failures are equally severe. The validation surface has a natural priority order — fix failures from the top down:

| Level          | What it checks                 | Severity | Example                                  |
| -------------- | ------------------------------ | -------- | ---------------------------------------- |
| **Linguistic** | Types, compiler errors         | Highest  | Code cannot run. Nothing else matters.   |
| **Stylistic**  | Formatting, lint rules         | High     | Code is inconsistent or has bad patterns |
| **Functional** | Tests                          | High     | Code behaves incorrectly                 |
| **Structural** | Architecture lints, modularity | Medium   | Code is organized poorly                 |

The golden command execution order reflects this hierarchy: `fmt` → `lint` → `typecheck` → `test`. A type error is more fundamental than a style violation. A compiler failure makes test results meaningless.

When triaging failures, work top-down. Fix linguistic errors first — they often cascade and resolve lower-level failures automatically.

### What the Validation Surface Does Not Prove

- Correct architectural decisions
- Good naming
- Appropriate scope
- Business logic correctness beyond test coverage
- Performance adequacy

These require human or agent judgment. The validation surface handles everything that can be checked mechanically.

### Flaky Checks

A flaky check — one that sometimes passes and sometimes fails on the same code — is worse than no check at all.

The entire validation model depends on determinism: if golden commands pass, the change is mechanically valid. A flaky check breaks that contract. It erodes trust in the validation surface and trains developers and agents to ignore failures, retry until green, or dismiss red as noise.

The rule:

> **Fix, quarantine, or remove. Never ignore.**

- **Fix** — find the root cause (timing, state leakage, external dependency) and make the check deterministic
- **Quarantine** — move the flaky check out of the golden command path into a separate suite that runs but does not gate merges. Track it as a bug.
- **Remove** — if the check cannot be made reliable and the coverage is not critical, delete it. A check that lies is worse than a gap you know about.

Never retry-until-green. If the team or agent starts re-running `just ci` hoping for a different result, the validation surface has already failed.

---

## Local/CI Parity

> **The commands the developer runs locally must be the same commands CI runs.**

This is a hard rule, not a guideline.

### Why

If local validation and CI validation diverge:

- The developer passes locally, CI fails → wasted time, broken flow
- CI passes, but local would have caught it → the developer skipped validation
- Different tool versions → phantom failures, inconsistent behavior
- Different configs → rules enforced in one place but not the other

### How to Achieve Parity

1. **Same commands.** CI runs `just ci`. The developer runs `just ci`. No special CI-only flags.
2. **Same tool versions.** Pin tool versions in the project config (lock files, version constraints).
3. **Same config files.** One `ruff.toml`, one `tsconfig.json`, one `.eslint.config.js`. No CI-specific overrides.
4. **Same execution environment.** Use the project's dependency manager to run tools (`uv run`, `npx`, `cargo`), not globally installed versions.

### The Test

If a developer can run `just ci` locally and get the same pass/fail result as the CI server, parity is achieved. If not, something is misconfigured.

---

## Validation in the Agent Execution Loop

In the [agent execution loop](README.md), validation is step 5:

```text
1. Select issue
2. Inspect codebase
3. State plan
4. Make focused changes
5. Run validation          ← golden commands here
6. Fix until clean         ← iterate until green
7. Summarize deltas
8. Prepare for integration
```

The agent must run the validation surface before declaring work complete. If golden commands fail, the agent fixes the issues and re-runs. This loop continues until the toolchain is satisfied.

The agent does not declare success. The toolchain does.

---

## Setting Up the Validation Surface

When scaffolding a new project:

1. Choose tools for each category (see [Toolchain](TOOLCHAIN.md))
2. Install and configure each tool
3. Create the golden command entry points (`justfile`, `Makefile`, `package.json` scripts, etc.)
4. Verify `just ci` passes on a clean project
5. Wire CI to run `just ci` (or equivalent)
6. Verify local and CI produce the same result

The validation surface should be functional before the first line of application logic. This is the "constrain first, generate second" principle in practice.
