# Toolchain

Selecting and configuring the enforcement layer for a project.

---

## The Principle

> **Use tools for rules.** Anything enforceable by tooling should not rely on prompts, memory, or convention alone.

The toolchain is the mechanism that turns principles into enforcement. Without it, standards exist as suggestions. With it, they exist as gates.

---

## The Four Categories

Every project that ships code needs tools in these four categories:

| Category         | What it enforces                              | Examples                                             |
| ---------------- | --------------------------------------------- | ---------------------------------------------------- |
| **Formatter**    | Consistent code style, layout, whitespace     | `ruff format`, `rustfmt`, `prettier`, `swift-format` |
| **Linter**       | Correctness, best practices, common mistakes  | `ruff check`, `clippy`, `eslint`, `swiftlint`        |
| **Type checker** | Type discipline, interface contracts          | `mypy`, `pyright`, `tsc`, `the Rust compiler`        |
| **Test runner**  | Behavioral correctness, regression prevention | `pytest`, `cargo test`, `vitest`, `jest`, `XCTest`   |

These are **categories, not brands**. The framework prescribes that you must have one in each category. It does not prescribe which one.

## Conditional Categories

Some categories are not universal — they apply based on project class.

| Category               | What it enforces                         | When required | Examples                                            |
| ---------------------- | ---------------------------------------- | ------------- | --------------------------------------------------- |
| **Structured logging** | Consistent, parseable telemetry output   | Class 2+      | `structlog`, `tracing`, `pino`, `slog`, `swift-log` |
| **Config linting**     | CI and infrastructure config correctness | Class 2+      | `yamllint`, `actionlint`, `gitlab-ci-lint`          |

### Structured Logging

Structured logging is not a validation gate — there is no `just log` command. It is enforced through **linter rules** that ban raw output (`print()`, `console.log()` in production code) and require use of the project's configured logger.

The distinction: the four core categories produce pass/fail validation results. Structured logging shapes what code is permitted. Its enforcement is mediated through the linter — it widens the linter's mandate, not the golden command set.

Construction ensures the code **produces** structured telemetry. [Delivery](../delivery/CI-CD.md#observability) ensures someone **consumes** it.

### Config Linting

CI configuration files are code. The method's constraint-first philosophy applies to them, not just to source code. If an agent modifies a workflow file and the golden command does not catch a broken `uses:` reference, the constraint corridor has a hole.

Two layers of config linting:

| Layer                 | What it catches                                                       | Tool examples                                            |
| --------------------- | --------------------------------------------------------------------- | -------------------------------------------------------- |
| **YAML validation**   | Syntax errors, duplicate keys, indentation issues                     | `yamllint`                                               |
| **Schema validation** | Semantic errors — invalid inputs, missing actions, broken expressions | `actionlint` (GitHub Actions), `gitlab-ci-lint` (GitLab) |

Config linting **is** a validation gate. It should be included in `just lint` or exposed as `just lint-ci` — either way, it must be part of the [validation surface](VALIDATION.md). The validation surface includes configuration files, not just source code.

---

## Ecosystem Reference Stacks

These are examples, not mandates. Choose what fits your ecosystem and team.

### Python

| Category           | Tool                     | Config                                   |
| ------------------ | ------------------------ | ---------------------------------------- |
| Package manager    | `uv`                     | `pyproject.toml`                         |
| Formatter          | `ruff format`            | `ruff.toml` or `pyproject.toml`          |
| Linter             | `ruff check`             | `ruff.toml` or `pyproject.toml`          |
| Type checker       | `mypy` or `pyright`      | `pyproject.toml` or `pyrightconfig.json` |
| Test runner        | `pytest`                 | `pyproject.toml`                         |
| Structured logging | `structlog` or `logging` | logging config in app                    |
| Pre-commit         | `pre-commit`             | `.pre-commit-config.yaml`                |

### Rust

| Category           | Tool          | Config                        |
| ------------------ | ------------- | ----------------------------- |
| Package manager    | `cargo`       | `Cargo.toml`                  |
| Formatter          | `rustfmt`     | `rustfmt.toml`                |
| Linter             | `clippy`      | `clippy.toml` or `Cargo.toml` |
| Type checker       | Rust compiler | Built-in                      |
| Test runner        | `cargo test`  | Built-in                      |
| Structured logging | `tracing`     | `Cargo.toml`                  |

### TypeScript

| Category           | Tool                | Config                                 |
| ------------------ | ------------------- | -------------------------------------- |
| Package manager    | `pnpm` or `npm`     | `package.json`                         |
| Formatter          | `prettier`          | `.prettierrc`                          |
| Linter             | `eslint`            | `eslint.config.js`                     |
| Type checker       | `tsc`               | `tsconfig.json`                        |
| Test runner        | `vitest` or `jest`  | `vitest.config.ts` or `jest.config.ts` |
| Structured logging | `pino` or `winston` | logger config module                   |

### Swift

| Category           | Tool                      | Config           |
| ------------------ | ------------------------- | ---------------- |
| Package manager    | Swift Package Manager     | `Package.swift`  |
| Formatter          | `swift-format`            | `.swift-format`  |
| Linter             | `swiftlint`               | `.swiftlint.yml` |
| Type checker       | Swift compiler            | Built-in         |
| Test runner        | `XCTest` or Swift Testing | Built-in         |
| Structured logging | `swift-log` (`Logging`)   | `Package.swift`  |

### Go

| Category           | Tool                     | Config          |
| ------------------ | ------------------------ | --------------- |
| Package manager    | `go mod`                 | `go.mod`        |
| Formatter          | `gofmt` / `goimports`    | Built-in        |
| Linter             | `golangci-lint`          | `.golangci.yml` |
| Type checker       | Go compiler              | Built-in        |
| Test runner        | `go test`                | Built-in        |
| Structured logging | `slog` (stdlib) or `zap` | logger init     |

---

## Selection Principles

### Choose boring tools

Prefer well-established, actively maintained tools with broad community adoption. Exotic or bleeding-edge tools add risk without proportional benefit for enforcement.

### Configure before generating

The toolchain configuration must exist before the first line of application code is written. This means:

1. Initialize the project (package manager, project structure)
2. Install and configure the formatter
3. Install and configure the linter
4. Install and configure the type checker
5. Set up the test harness
6. Wire the golden commands (see [Validation](VALIDATION.md))
7. **Then** start writing application logic

This order is deliberate. Once the toolchain is configured, every subsequent change is automatically subject to the project's quality standards.

### One config, one truth

Each tool should have exactly one configuration file. Do not scatter overrides across multiple locations. If a rule needs an exception, document it in the config with a comment explaining why.

### Pre-commit hooks

Use pre-commit hooks to catch violations before they reach CI. This shortens the feedback loop from minutes (CI) to seconds (local).

Pre-commit hooks are a convenience, not a security boundary. CI remains the authoritative gate. But catching a formatting error in 2 seconds locally is much better than waiting 5 minutes for CI to tell you.

---

## When to Add vs. When to Skip

| Project Class              | Formatter | Linter   | Type Checker | Test Runner | Structured Logging | Config Linting |
| -------------------------- | --------- | -------- | ------------ | ----------- | ------------------ | -------------- |
| **0 — Scratchpad**         | Yes       | Optional | Optional     | Optional    | No                 | No             |
| **1 — Prototype**          | Yes       | Yes      | Optional     | Yes         | Optional           | Optional       |
| **2 — Product Seed**       | Yes       | Yes      | Yes          | Yes         | Yes                | Yes            |
| **3 — Long-Lived Product** | Yes       | Yes      | Yes          | Yes         | Yes                | Yes            |

The formatter is never optional. Consistent formatting costs nothing and prevents the most common category of noise in diffs and reviews.

Structured logging becomes mandatory when the project has users (Class 2+). At that point, `print()` debugging is insufficient — you need parseable, leveled output that downstream systems can consume. For the delivery-side concern — consuming telemetry after deployment — see [Observability in CI/CD](../delivery/CI-CD.md#observability).

---

## The Goal

The toolchain exists so that neither the human nor the agent has to remember:

- "Use single quotes"
- "Add type annotations"
- "Run the tests"
- "Follow the import order"
- "Use the logger, not print()"
- "Validate the CI config before pushing"

These become impossible to forget — because the toolchain catches them automatically. That is the point.
