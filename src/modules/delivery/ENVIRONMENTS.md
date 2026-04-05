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
