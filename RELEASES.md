# Releases

Tags, versions, artifacts, channels, environments, promotion, hotfixes, and rollback.

---

## Versioning

Use SemVer or something close. You do not have to worship it, but it is useful as a shared language.

```
MAJOR.MINOR.PATCH
```

- **MAJOR** = breaking change
- **MINOR** = backward-compatible feature
- **PATCH** = backward-compatible fix

For internal tools, you can be more pragmatic, but still keep the shape.

### Prerelease Suffixes

Use when needed. They map naturally to channels.

```
v1.8.0-alpha.1
v1.8.0-beta.3
v1.8.0-rc.1
```

---

## Tags

Use annotated tags for releases.

```
v1.4.0
v1.4.1
v2.0.0-beta.2
v2.0.0-rc.1
```

Tags represent release points, not random milestones.

---

## Artifacts

Treat artifacts as first-class citizens.

### Build Identity vs. Release Identity

An artifact carries two layers of identity:

**Build identity** is baked in at build time. It never changes.

- Commit SHA
- Build timestamp
- Build number / pipeline ID
- Provenance if possible

**Release identity** is assigned later, at promotion time. It lives outside the artifact.

- Semantic version (`1.6.0`)
- Channel label (`stable`, `beta`)
- Release notes, changelog entry

At build time, the artifact does not know whether it will become `v1.6.0` or get abandoned. The build identity is all it can embed. The release identity is layered on at promotion time.

### What the User Sees

The version displayed to the user depends on the deployment context, not just what is baked into the artifact.

**The pattern:** embed build identity in the artifact, resolve release identity from the deployment context at runtime.

| Source | What it provides | When it is known |
|---|---|---|
| Embedded in artifact | Commit SHA, build number, build timestamp | Build time |
| Deployment context | Release version, channel label | Promotion / deploy time |
| Display to user | Composed from both | Runtime |

**Deployment context** means: environment variable, sidecar metadata file, container label, package manifest, installer metadata, config endpoint, or similar. The mechanism varies by product type, but the principle is constant — the artifact reads its release identity from the context it is deployed into, not from its own binary.

### What the user sees by channel

| Channel | Version display | Example |
|---|---|---|
| **Dev** | Build identity only | `build 847 (abc1234)` or `0.0.0-dev+abc1234` |
| **Beta** | Prerelease version | `1.6.0-beta.2` |
| **Stable** | Release version | `1.6.0` |

Dev users see build coordinates. That is normal and expected — they are on the bleeding edge and the build has no release identity yet. Stable users see a clean semantic version because the deployment context provides it.

### How to Provide Deployment Context

The exact mechanism depends on product type:

| Product type | Mechanism |
|---|---|
| Server / container | Environment variable or sidecar file injected at deploy time |
| CLI tool | Version file or metadata baked into the distribution package (not the binary) |
| Desktop app | Installer or update manifest carries the version |
| Mobile app | App store metadata + build number |
| Library / package | Package manifest (`package.json`, `pyproject.toml`, etc.) |

For libraries and packages, the package manifest **is** the deployment context — it is updated at promotion time before publishing, and the code reads the version from it at runtime.

### Composing the Display Version

At runtime, the application composes what it shows the user:

```
if deployment_context has release_version:
    display = release_version           # "1.6.0"
else:
    display = build_identity            # "build 847 (abc1234)"
```

Optionally, always include build identity in detailed views (e.g., "About" dialogs):

```
Version:  1.6.0
Build:    847
Commit:   abc1234
Built:    2026-03-28T14:22:00Z
```

This gives users and support teams full traceability without breaking artifact immutability.

### Traceability Without Release Notes

Stable releases have changelogs and release notes. Dev channel builds do not — but they are still fully traceable.

Given a build identity, anyone can reconstruct what changed:

```
git log <previous-sha>..abc1234 --oneline
```

Conventional commit messages serve as the summary: `feat: add export command`, `fix: prevent null crash in importer`. The git history **is** the feature list for dev builds.

The framework guarantees that every build is traceable to its source via the embedded commit SHA. How teams surface that information to testers — Slack bots, CI dashboards, deployment notifications, or just asking in standup — is a team communication concern, not a workflow concern. The framework provides the traceability; the team chooses the mechanism.

### Examples

| Type | Format |
|---|---|
| Docker image | `sha-abc1234`, aliased to `1.6.0` and `stable` at promotion |
| CLI binary | `tool-sha-abc1234-linux-amd64.zip`, aliased to `tool-v1.6.0-linux-amd64.zip` |
| Python wheel | Built with version `0.0.0-dev`, published with version `1.6.0` in package index |
| Installer | Wraps the same binary; installer metadata carries the release version |
| Mobile build | Build number is permanent; version string updated in store metadata |

### Rules

- Artifacts are immutable
- Build identity is embedded at build time and never changes
- Release identity is provided by the deployment context, not embedded in the artifact
- Artifacts are traceable to commit, tag, and pipeline
- Artifacts are retained long enough for rollback and audit

### Identity

| Identifier | What it tracks | When assigned |
|---|---|---|
| Git commit | Source | Commit time |
| Build identity | Artifact provenance | Build time |
| Tag | Release intent | Promotion time |
| Alias | Release identity on the artifact | Promotion time |

These are related but not identical. The gap between build time and promotion time is where the aliasing model lives.

---

## The Promotion Model

**Build once, promote many.** This is one of the strongest patterns you can adopt.

Do not rebuild separately for staging and production if you can avoid it.

```
1. Commit merges to main
2. CI builds artifact once
3. Artifact gets a unique build ID / commit SHA
4. Deploy artifact to dev
5. Promote same artifact to staging
6. Promote same artifact to canary
7. Promote same artifact to stable
```

You are testing and promoting **the same thing**, not similar things.

### Promotion Is Aliasing, Not Rebuilding

The artifact produced at build time is the **only** artifact. Promotion adds new pointers to it — it never triggers a new build.

When a dev build gets promoted to stable:

```
1. Commit abc1234 merges to main
2. CI builds artifact: myapp:sha-abc1234
3. Artifact deploys to dev channel
4. Team validates the build
5. Tag the commit: v1.6.0
6. Alias the existing artifact under the release version:
   - Docker:  docker tag myapp:sha-abc1234 myapp:1.6.0
   - Binary:  copy or link tool-sha-abc1234.zip → tool-v1.6.0.zip
   - Package: publish same bits under version 1.6.0
7. Update channel pointer (e.g., myapp:stable → myapp:1.6.0)
8. Generate changelog and release notes from the tag
```

The bytes are identical. The checksum matches. The version tag, channel label, and release notes are **metadata layered on top** of an immutable artifact — not a reason to rebuild it.

### What the Promotion Pipeline Does

A promotion pipeline is lightweight. It does not compile, test, or package source code. It:

- Tags the git commit with the release version
- Aliases the artifact in the registry / storage under the version name
- Updates the channel pointer (stable, beta, etc.)
- Generates changelog and release notes
- Publishes release metadata (GitHub Release, package index, etc.)

### What the Promotion Pipeline Does Not Do

- Rebuild from source
- Rerun tests against source (smoke tests against the deployed artifact are fine)
- Produce a new artifact with different bytes
- Change the artifact's embedded commit SHA or build timestamp

If promotion requires a rebuild, something is wrong with the build process. Fix the build, do not work around it by rebuilding at promotion time.

---

## Environments

Runtime targets. Where something runs.

| Environment | Purpose | Deployment |
|---|---|---|
| **Dev** | Fast iteration | Automatic from `main` |
| **Staging** | Candidate validation | Manual or gated promotion |
| **Production** | Live traffic | Gated promotion from staging |

### Rules

- Environments are deployment targets, not git branches
- Same artifact moves across environments
- Config differs by environment; code does not

---

## Channels

Release audience and risk lanes. Who gets something and how risky it is.

Channels are **quality-gated** — a build gets promoted when it passes checks, not on a schedule.

| Channel | Exposure | Ceremony | Tier |
|---|---|---|---|
| **Dev** | Team only | Low — may track every merge | All |
| **Canary** | Limited production users | Medium — requires objective checks | Tier 3 |
| **Beta** | Opt-in or limited audience | Medium — versioned prereleases | Tier 2+ |
| **Stable** | General availability | High — tagged, noted, published | All |

### Channel Sets by Tier

| Tier | Channels | Rationale |
|---|---|---|
| **Solo / Personal** | `dev` + `stable` | No users to protect with intermediate gates |
| **Solo / Consultancy** | `dev` + `beta` + `stable` | Beta gives clients a preview; no traffic to split for canary |
| **Small Team** | `dev` + `canary` + `beta` + `stable` | Full model — canary enables low-blast-radius production validation |

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

## CI and CD

### CI Is About Trust

CI answers: **"Is this change good enough to integrate?"**

| Step | Purpose |
|---|---|
| Format / lint | Code quality |
| Unit tests | Correctness |
| Integration tests | System behavior |
| Static analysis | Safety |
| Build / package | Artifact creation |
| Generate artifacts | Deliverables |
| Preview builds | Early feedback |

### CD Is About Movement

CD answers: **"Can we safely move this artifact through environments and channels?"**

| Step | Purpose |
|---|---|
| Deploy to environment | Runtime placement |
| Smoke tests | Basic validation |
| Gate promotion | Confidence checkpoint |
| Rollback support | Safety net |
| Publish release notes | Communication |
| Publish binaries | Distribution |

### CI on Merge to Main

- Build artifact
- Assign build metadata
- Publish internal artifact
- Deploy automatically to dev
- Run smoke tests

---

## Release Flow

The full sequence from merge to stable:

```
1. Decide release candidate from main
2. Tag prerelease if needed (v1.4.0-rc.1)
3. Deploy same artifact to staging
4. Validate
5. Promote to canary
6. Observe
7. Promote to stable
8. Tag final release (v1.4.0)
9. Publish release notes
10. Attach binaries / packages / images
```

### Release Rules

- Every release has a tag
- Every tag maps to artifacts
- Every stable release has notes
- Production only receives tagged releases
- Hotfixes become patch releases

---

## Hotfixes

This is where a lot of frameworks break down.

### By Tier

**Tier 1 (Solo / Personal):** Fix on `main` directly. Tag a new patch version. Done.

**Tier 2+ (Consultancy, Small Team):** Full hotfix flow:

```
1. Branch from the production tag or current stable commit
2. Make the minimal fix
3. Validate
4. Release a patch version
5. Merge the fix back into main
```

**Tier 3 adds:** peer review even under time pressure.

### Example

- Stable is `v1.4.2`
- Production issue found
- Create `hotfix/412-fix-crash`
- Release `v1.4.3`
- Merge back to `main`

**No divergence allowed to linger.**

---

## Changelog

The changelog is generated **at tag time**, not at merge time. It covers everything between the previous tag and the new one.

### Rules

- Changelog entries correspond to releases (tags), not individual merges
- Content is derived from conventional commit messages between the previous tag and the current one
- Dev channel builds do not get changelog entries — they are identified by commit SHA alone
- Prerelease tags (`-beta.N`, `-rc.N`) may optionally generate changelog entries depending on audience
- Stable tags always generate a changelog entry

### Generation

Changelog generation is part of the promotion pipeline, not the build pipeline. Tooling like `git-cliff`, GitHub's auto-generated release notes, or equivalent derives the changelog from the commit history between tags.

```
git log v1.5.0..v1.6.0 --oneline
```

This is the input. The output is a structured, human-readable summary grouped by commit type (features, fixes, chores, etc.).

---

## Rollback

- Rollback by redeploying the prior artifact or tag
- Never patch production manually
- Never rebuild old source for rollback if the old artifact exists

Rollback is a deployment operation, not a source control operation.

---

## Long-Term Support

You only need release branches if you support multiple versions at the same time.

```
main         → next version
release/1.8  → maintained stable line
release/1.7  → emergency support only
```

If you are solo or a small team, **avoid this unless absolutely necessary.** It adds real operational cost.
