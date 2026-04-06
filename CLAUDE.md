# CLAUDE.md

A Deterministic Engineering Framework — an opinionated framework for how software is conceived, constructed, validated, integrated, released, and evolved. Designed for consumption by humans and AI agents.

## Project Structure

Content lives in `src/`. The root contains configuration and build tooling. The site is built with mdBook.

## Reading Order

1. **[src/PRINCIPLES.md](src/PRINCIPLES.md)** — First principles. The seven non-negotiable principles and project classification.
2. **[src/GLOSSARY.md](src/GLOSSARY.md)** — Ubiquitous language. Adopt this vocabulary exactly.
3. **[src/modules/construction/](src/modules/construction/)** — How to approach building: toolchain selection, validation surface, agent execution loop.
4. **[src/modules/change-management/](src/modules/change-management/)** — Day-to-day development: branches, PRs, commits, issues, releases.
5. **[src/modules/delivery/](src/modules/delivery/)** — Delivery operations: artifacts, promotion, environments, channels, CI/CD.
6. **[src/modules/knowledge/](src/modules/knowledge/)** — Knowledge persistence: ADRs, plans, documentation, context management.
7. **[src/ADAPTING.md](src/ADAPTING.md)** — Operational tiers (solo/personal, solo/consultancy, small team), project classes, and product type variations.

## When Referencing This Framework

- Determine which tier and project class apply to the target project (see src/ADAPTING.md and src/PRINCIPLES.md)
- Set up the toolchain before generating code (see src/modules/construction/)
- Follow the tier-appropriate level of ceremony
- Use the glossary terms consistently
- Validate with golden commands before declaring work complete

## Golden Commands

- `just fmt` — Format all markdown
- `just lint` — Lint all markdown
- `just build` — Build the static site
- `just serve` — Build and serve locally with live reload
- `just ci` — Run fmt + lint + build (full validation surface)
