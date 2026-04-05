# Validation

Golden commands, the canonical validation surface, and local/CI parity.

---

## Golden Commands

A **golden command** is a canonical entry point into the project's validation surface. Instead of the developer or agent guessing whether to run `ruff check`, `python -m pytest`, `mypy src`, or `uv run ...`, the project exposes a small, stable set of commands that do the right thing.

### The Standard Set

Every project should expose these commands:

| Command | Purpose |
|---|---|
| `make fmt` | Run the formatter (fix mode) |
| `make lint` | Run the linter |
| `make typecheck` | Run the type checker |
| `make test` | Run the test suite |
| `make ci` | Run all of the above in sequence |

The exact mechanism does not have to be `make`. It can be:

- `Makefile` targets
- `package.json` scripts (`npm run fmt`, `npm run lint`, etc.)
- `just` recipes
- `task` targets (Taskfile)
- Shell scripts in a `scripts/` directory

What matters is:

1. **Stable names.** The commands do not change when the underlying tool changes.
2. **One command, one concern.** Each golden command maps to one validation category.
3. **Composable.** `make ci` runs all of them. Individual commands can be run alone.
4. **Discoverable.** A new developer or agent can find them without reading implementation details.

### Why This Matters

Golden commands reduce cognitive branching. Instead of:

> "Is it `ruff check .` or `ruff check src`? Do I need `--fix`? Is it `pytest` or `python -m pytest`? Does the type checker need special flags?"

The answer is always:

> `make lint`, `make test`, `make typecheck`.

This is powerful for both humans and agents. Agents, in particular, benefit from stable entry points because they eliminate a class of guessing errors.

---

## The Validation Surface

The **validation surface** is the complete set of golden commands that prove a change is integration-ready.

Running `make ci` — or its equivalent — is the gate before any PR or commit to `main`.

### What the Validation Surface Proves

| Check | What it proves |
|---|---|
| Formatter passes | Code style is consistent |
| Linter passes | No known bad patterns, no obvious mistakes |
| Type checker passes | Interfaces are honored, types are sound |
| Tests pass | Behavior is correct, regressions are caught |
| Build succeeds | The project compiles / packages correctly |

If all golden commands pass, the change is **mechanically valid**. It may still have design problems or incorrect logic that tests do not cover — but it has passed every automated check the project offers.

### What the Validation Surface Does Not Prove

- Correct architectural decisions
- Good naming
- Appropriate scope
- Business logic correctness beyond test coverage
- Performance adequacy

These require human or agent judgment. The validation surface handles everything that can be checked mechanically.

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

1. **Same commands.** CI runs `make ci`. The developer runs `make ci`. No special CI-only flags.
2. **Same tool versions.** Pin tool versions in the project config (lock files, version constraints).
3. **Same config files.** One `ruff.toml`, one `tsconfig.json`, one `.eslint.config.js`. No CI-specific overrides.
4. **Same execution environment.** Use the project's dependency manager to run tools (`uv run`, `npx`, `cargo`), not globally installed versions.

### The Test

If a developer can run `make ci` locally and get the same pass/fail result as the CI server, parity is achieved. If not, something is misconfigured.

---

## Validation in the Agent Execution Loop

In the [agent execution loop](README.md), validation is step 5:

```
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
3. Create the golden command entry points (`Makefile`, `package.json` scripts, etc.)
4. Verify `make ci` passes on a clean project
5. Wire CI to run `make ci` (or equivalent)
6. Verify local and CI produce the same result

The validation surface should be functional before the first line of application logic. This is the "constrain first, generate second" principle in practice.
