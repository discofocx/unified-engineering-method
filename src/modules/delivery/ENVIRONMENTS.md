# Environments and Channels

Runtime targets, release audiences, and risk lanes.

---

## Environments

Runtime targets. Where something runs.

| Environment    | Purpose              | Deployment                   |
| -------------- | -------------------- | ---------------------------- |
| **Dev**        | Fast iteration       | Automatic from `main`        |
| **Staging**    | Candidate validation | Manual or gated promotion    |
| **Production** | Live traffic         | Gated promotion from staging |

### Rules

- Environments are deployment targets, not git branches
- Same artifact moves across environments
- Config differs by environment; code does not

### Environment Parity

The [Validation](../construction/VALIDATION.md) module mandates local/CI parity — the same golden commands run locally and in CI. But there is a second parity gap: the distance between CI and the delivery environment.

The golden command passes locally and in CI. The artifact gets promoted. Then it hits a production environment with a different runtime version, a missing system dependency, or a configuration that does not exist in CI. This is environment drift — and it is where "it works on my machine" becomes "it worked in the pipeline."

The principle:

> **The environment used for validation should be as close as possible to the delivery environment.**

Local/CI parity is the first layer. Delivery parity is the second.

The mechanism varies by product type — the framework prescribes the principle, not the implementation:

| Product type       | Parity mechanism                                                                    |
| ------------------ | ----------------------------------------------------------------------------------- |
| Server / container | Container images for build and delivery; same base image across environments        |
| CLI tool           | Reproducible builds; pinned toolchains; CI builds on the same OS targets as release |
| Desktop app        | SDK version pinning; consistent signing and packaging across environments           |
| Mobile app         | Xcode / Android SDK version pinning; consistent build configurations                |
| Library / package  | Lock files; pinned dependency versions; CI tests against supported runtimes         |

Tools like Docker, Nix, reproducible build systems, and pinned SDK versions are all valid approaches. What matters is that the gap between "CI said yes" and "production works" is as small as you can make it.

For projects with external runtime dependencies — drivers, third-party libraries, system packages — the parity challenge extends beyond the application. These dependencies should be documented, version-pinned where possible, and ideally verified as part of the deployment process. When they cannot be bundled, they become part of the deployment contract: the environment must provide them.

---

## Channels

Release audience and risk lanes. Who gets something and how risky it is.

Channels are **quality-gated** — a build gets promoted when it passes checks, not on a schedule.

| Channel    | Exposure                   | Ceremony                           | Tier    |
| ---------- | -------------------------- | ---------------------------------- | ------- |
| **Dev**    | Team only                  | Low — may track every merge        | All     |
| **Canary** | Limited production users   | Medium — requires objective checks | Tier 3  |
| **Beta**   | Opt-in or limited audience | Medium — versioned prereleases     | Tier 2+ |
| **Stable** | General availability       | High — tagged, noted, published    | All     |

### Channel Sets by Tier

| Tier                   | Channels                             | Rationale                                                          |
| ---------------------- | ------------------------------------ | ------------------------------------------------------------------ |
| **Solo / Personal**    | `dev` + `stable`                     | No users to protect with intermediate gates                        |
| **Solo / Consultancy** | `dev` + `beta` + `stable`            | Beta gives clients a preview; no traffic to split for canary       |
| **Small Team**         | `dev` + `canary` + `beta` + `stable` | Full model — canary enables low-blast-radius production validation |

### Mapping Versions to Channels

- Every merge to `main` → dev build
- Selected builds → canary (Tier 3)
- Versioned prereleases (`-beta.N`, `-rc.N`) → beta
- Approved tags → stable

### What About Nightly?

Nightly is a **time-gated build schedule**, not a quality-gated channel. If you produce nightly builds, they feed into `dev` or `canary`. The build cadence is a CI concern; the channel model is a delivery concern.

### Rules

- Canary is limited exposure
- Stable is default public release
- Dev is not guaranteed stable
- Promotion requires objective checks

---

## The Distinction

Environments answer: **where is this running?**
Channels answer: **who gets this and how risky is it?**

A staging environment might host a release candidate. Production might host both canary and stable deployments. Internal builds may go to a dev environment but not be formal releases. Keep them separate.
