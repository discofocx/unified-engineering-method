# Releases

Tags, versions, hotfixes, changelog, and release flow.

For artifact management, promotion, environments, channels, and CI/CD, see [Delivery](../delivery/).

---

## Versioning

Use SemVer or something close. You do not have to worship it, but it is useful as a shared language.

```text
MAJOR.MINOR.PATCH
```

- **MAJOR** = breaking change
- **MINOR** = backward-compatible feature
- **PATCH** = backward-compatible fix

For internal tools, you can be more pragmatic, but still keep the shape.

### Prerelease Suffixes

Use when needed. They map naturally to channels.

```text
v1.8.0-alpha.1
v1.8.0-beta.3
v1.8.0-rc.1
```

---

## Tags

Use annotated tags for releases.

```text
v1.4.0
v1.4.1
v2.0.0-beta.2
v2.0.0-rc.1
```

Tags represent release points, not random milestones.

---

## Release Flow

The full sequence from merge to stable:

```text
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

```text
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

```bash
git log v1.5.0..v1.6.0 --oneline
```

This is the input. The output is a structured, human-readable summary grouped by commit type (features, fixes, chores, etc.).

---

## Long-Term Support

You only need release branches if you support multiple versions at the same time.

```text
main         → next version
release/1.8  → maintained stable line
release/1.7  → emergency support only
```

If you are solo or a small team, **avoid this unless absolutely necessary.** It adds real operational cost.
