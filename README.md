# The Unified Engineering Method

> *Never trust memory when you can use mechanism.*

An opinionated method for how software is conceived, constructed, validated, integrated, released, and evolved — by humans and AI agents alike.

> **Status:** Active development. The principles are stable; the modules are still evolving.

## What This Is

A coherent engineering method that unifies four concerns into one operating model:

- **Construction** — how work is framed, constrained, and validated during building
- **Change Management** — how changes are tracked, reviewed, and integrated
- **Delivery** — how artifacts move through environments and channels
- **Knowledge** — how intent, decisions, and context persist

## Read the Full Method

The complete content lives in [`src/`](src/README.md).

**Start here:**

1. [Principles](src/PRINCIPLES.md) — the seven non-negotiable principles
2. [Glossary](src/GLOSSARY.md) — shared vocabulary
3. [Construction](src/modules/construction/) — toolchain, validation, agent execution loop
4. [Change Management](src/modules/change-management/) — branches, PRs, commits, releases
5. [Delivery](src/modules/delivery/) — artifacts, promotion, environments, CI/CD
6. [Knowledge](src/modules/knowledge/) — ADRs, persistent planning, context debt
7. [Adapting](src/ADAPTING.md) — operational tiers, project classes, product types

## Already Have a Project?

Skip the reading order. Use the [Brownfield Audit](src/QUICKSTART-AUDIT.md) — a prompt template that assesses your existing codebase and proposes a forward-only adoption plan.

## Build the Site

```
just serve
```

Requires [mdBook](https://rust-lang.github.io/mdBook/) and [just](https://github.com/casey/just).

## Golden Commands

```
just fmt       # Format markdown
just lint      # Lint markdown
just build     # Build static site
just serve     # Serve locally with live reload
just ci        # Full validation surface
```

## License

[MIT](LICENSE)

---

*By Gerardo Sorchini*
