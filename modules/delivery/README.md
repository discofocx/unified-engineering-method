# Delivery

How built software moves from source to users.

This module governs artifacts, promotion, environments, channels, CI/CD, and rollback. It answers the question: once code is merged, how does it become something a user can run?

---

## What This Module Covers

- **Artifacts** — immutable build outputs, build identity vs release identity, the aliasing model
- **Promotion** — build once, promote many; aliasing, not rebuilding
- **Environments** — dev, staging, production as deployment targets
- **Channels** — dev, canary, beta, stable as audience and risk lanes
- **CI/CD** — continuous integration for trust, continuous delivery for movement
- **Rollback** — redeploying known-good artifacts, never rebuilding from old source

---

## Documents

| Document | What it covers |
|---|---|
| [Artifacts](ARTIFACTS.md) | Build/release identity, deployment context, promotion model |
| [Environments](ENVIRONMENTS.md) | Runtime targets, channels, risk lanes |
| [CI-CD](CI-CD.md) | Integration validation, delivery movement, rollback |

---

## Relationship to Other Modules

**Change Management** feeds this module. Tags and releases in change management trigger the delivery pipeline.

**Construction** shapes what this module receives. A well-validated change produces a trustworthy artifact. A poorly validated one produces risk.

**Knowledge** informs this module. Release notes, changelogs, and deployment decisions are all forms of persistent knowledge.

---

## Key Principle

From the [Doctrine](../../DOCTRINE.md):

> **Validation is mandatory, not optional.** The toolchain declares success, not the agent.

An artifact is the output of a deterministic build. Promotion is aliasing, not rebuilding. Rollback is redeployment, not reconstruction. Every step is reproducible and traceable.
