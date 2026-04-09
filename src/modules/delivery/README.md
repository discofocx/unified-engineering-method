# Delivery

How built software reaches users.

Once code is merged, how does it become something a user can run? This module governs artifacts, promotion, environments, channels, CI/CD, and rollback.

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

| Document                        | What it covers                                              |
| ------------------------------- | ----------------------------------------------------------- |
| [Artifacts](ARTIFACTS.md)       | Build/release identity, deployment context, promotion model |
| [Environments](ENVIRONMENTS.md) | Runtime targets, channels, risk lanes                       |
| [CI-CD](CI-CD.md)               | Integration validation, delivery movement, rollback         |

---

## Delivery by Project Class

Not every project needs a full promotion pipeline on day one. But if you wait too long to wire delivery, you will be behind when it matters.

| Class                      | Delivery expectation                                                          |
| -------------------------- | ----------------------------------------------------------------------------- |
| **0 — Scratchpad**         | Manual delivery acceptable. No pipeline required.                             |
| **1 — Prototype**          | One-command deploy. If you cannot deploy with a single script, friction wins. |
| **2 — Product Seed**       | Full CI/CD pipeline. Automated builds. At least a dev channel.                |
| **3 — Long-Lived Product** | Full promotion pipeline. Multiple channels. Rollback tested and exercised.    |

The trap is waiting until Class 2 to wire CI/CD when the codebase has been growing since Class 0. If the golden commands are already running locally (they should be — see [Construction](../construction/)), wiring CI is a small step: the pipeline just calls the same commands. If nothing is automated, retrofitting delivery onto a mature codebase means fighting every inconsistency at once.

The honest advice: wire basic CI at Class 1. Even if it only runs `just ci` on push. The delivery pipeline can grow from there — but the foundation should exist before the first time someone other than you needs to use your software.

---

## Relationship to Other Modules

**Change Management** feeds this module. Tags and releases in change management trigger the delivery pipeline.

**Construction** shapes what this module receives. A well-validated change produces a trustworthy artifact. A poorly validated one produces risk.

**Knowledge** informs this module. Release notes, changelogs, and deployment decisions are all forms of persistent knowledge.

---

## Key Principle

From the [Principles](../../PRINCIPLES.md):

> **Validation is mandatory, not optional.** The toolchain declares success, not the agent.

An artifact is the output of a deterministic build. Promotion is aliasing, not rebuilding. Rollback is redeployment, not reconstruction. Every step is reproducible and traceable.
