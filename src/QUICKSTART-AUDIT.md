# Quickstart: Audit Your Project

You have an existing codebase. You have read (or skimmed) the Unified Engineering Method. You want to know where you stand and what to do first.

This page contains a prompt template. Copy it, paste it into an agent session (Claude Code, Cursor, or any AI coding assistant) running in your project, and let the agent do the assessment. The output is a `UEM-AUDIT.md` file in your project root — a structured baseline with a practical adoption plan.

## How to Use

1. Clone or download this repository to a known location, or note the GitHub URL.
2. Open an agent session in **your project's** directory — not in the UEM repo.
3. Copy the prompt below. Replace `{{UEM_PATH}}` with either:
   - A local path: `~/.uem/unified-engineering-method/src`
   - The GitHub URL: `https://github.com/discofocx/unified-engineering-method/tree/main/src`
4. Paste the prompt. Let the agent work.

## What This Is Not

This is not a compliance audit. There is no score, no grade, no pass/fail. The output is a map — it shows you the full landscape of where your project stands relative to UEM at your level, and then gives you a practical starting point. The goal is to make your development experience better today, not to judge the work you have already done.

---

## The Prompt

```text
You are assessing an existing codebase against the Unified Engineering Method (UEM).

UEM is an opinionated engineering method that unifies four concerns — construction,
change management, delivery, and knowledge — into one operating model. It defines
operational tiers (Solo/Personal, Solo/Consultancy, Small Team), project classes
(Class 0 scratchpad through Class 3 long-lived product), and a constraint-first
philosophy: quality is enforced by tooling, not by memory or prompting.

This is NOT a compliance audit. There is no score. The goal is to show the developer
the full picture of where they stand, and then give them a practical starting point
for adoption. Do not propose rewriting or reformatting the entire codebase.

## Step 1: Read the Method

Read the following files from the UEM repository at {{UEM_PATH}}, in this order:

1. PRINCIPLES.md — the seven principles and the project classification model
2. GLOSSARY.md — shared vocabulary (use these terms in your output)
3. ADAPTING.md — operational tiers, project classes, brownfield migration guidance
4. modules/construction/README.md — toolchain, golden commands, validation surface
5. modules/construction/TOOLCHAIN.md — toolchain categories and selection
6. modules/knowledge/README.md — knowledge persistence, ADRs, context debt

Do not read the Change Management or Delivery modules yet. Those come later in
the brownfield adoption order.

## Step 2: Scan the Codebase

Examine this project's structure, configuration, and conventions. Do NOT read all
source code — scan structure and config only.

Check for:
- Project structure (top-level directories, key files)
- Language, framework, ecosystem
- Formatter configuration (prettier, black, rustfmt, swiftformat, etc.)
- Linter configuration (eslint, ruff, clippy, swiftlint, etc.)
- Type checker configuration (typescript, mypy, etc.)
- Test runner and test files
- CI/CD configuration (.github/workflows, .gitlab-ci.yml, Jenkinsfile, etc.)
- Task runner (justfile, Makefile, package.json scripts)
- Pre-commit hooks (.husky, .pre-commit-config.yaml, lefthook, etc.)
- README, ARCHITECTURE.md, or equivalent documentation
- ADRs (architecture decision records)
- Agent instructions (CLAUDE.md, .cursorrules, .github/copilot-instructions.md, etc.)
- CONTRIBUTING.md or equivalent
- Issue tracker configuration (.github/ISSUE_TEMPLATE, linear config, etc.)
- Git tags and release history
- Recent commit messages (sample the last 10-20 for convention patterns)

## Step 3: Classify

Using the definitions from PRINCIPLES.md and ADAPTING.md, determine:

- **Operational tier**: Solo/Personal, Solo/Consultancy, or Small Team
- **Project class**: 0 (Scratchpad), 1 (Prototype), 2 (Product Seed), or 3 (Long-Lived Product)

Classify based on realistic intent, not aspirational intent. A weekend project
with no users is not Class 3 just because the developer wishes it were.

Provide a one-line justification for each.

## Step 4: Establish Baseline

Document what exists today. Frame it neutrally — this is a map of the current
state, not a list of failures. Include what the project already does well.

## Step 5: Full Gap Analysis

Compare the current state against what the identified tier and class combination
requires, according to UEM. Organize by module in the brownfield adoption order:

1. **Knowledge** — project map, agent instructions, ADRs, documentation
2. **Construction** — formatter, linter, type checker, test runner, structured logging (Class 2+), golden commands, validation surface
3. **Change Management** — issue tracking, commit conventions, branch strategy, PR workflow
4. **Delivery** — CI pipeline, tagged releases, artifact management, environments

Report ALL gaps relevant to this tier and class. Do not hide gaps — the developer
needs the full picture. But do not flag gaps that are irrelevant to the identified
level. A Tier 1 / Class 1 project does not need ADRs or multi-stage promotion.
Do not flag their absence.

Frame this section as: "Here is how far you are from full UEM compliance at your
level." This is the ground truth.

## Step 6: Act Today

From the full gap analysis, extract a pragmatic adoption plan in two categories:

### Quick Wins
Up to 5 items that can be done today or this week. Each should be:
- Low risk, immediate value
- Achievable in a single PR or commit
- Concrete and specific to this codebase (not generic advice)

Examples: add a formatter config, create a CLAUDE.md, wire a `just fmt` command,
add a pre-commit hook for the existing linter.

### Structural Improvements
Up to 5 items that require more planning. Each should:
- Reference which class transition step it enables (from the Class Transition
  table in ADAPTING.md)
- Note dependencies on other improvements
- Be ordered by the brownfield module adoption sequence

Do not propose reformatting or linting the entire existing codebase. For legacy
code with many violations, recommend linter baselines and forward-only enforcement.

End this section with: "Do not attempt all of these at once. Pick one quick win
and one structural improvement. Ship them. Then revisit this audit."

## Step 7: Write the Output

Write the complete assessment to a file called UEM-AUDIT.md in this project's root
directory. Use this structure:

---

# UEM Audit

> Assessed against the Unified Engineering Method on [today's date].
> This is a baseline, not a report card.

## Classification

- **Operational Tier:** [tier] — [one-line justification]
- **Project Class:** [class] — [one-line justification]

## Current State

### What Exists Today

[Bulleted list of what the project already has in place]

### Codebase Overview

[2-3 sentences: language, framework, scale, structure]

## Full Gap Analysis

### Knowledge

[All gaps relevant to this tier/class, or "No gaps identified for this tier/class."]

### Construction

[All gaps relevant to this tier/class, or "No gaps identified for this tier/class."]

### Change Management

[All gaps relevant to this tier/class, or "No gaps identified for this tier/class."]

### Delivery

[All gaps relevant to this tier/class, or "No gaps identified for this tier/class."]

## Act Today

### Quick Wins

[Numbered list. Each item: what to do, why it helps, estimated effort.]

### Structural Improvements

[Numbered list. Each item: what to do, which class transition it enables, dependencies.]

### What Not to Do

Do not attempt all of these at once. Pick one quick win and one structural
improvement. Ship them. Then revisit this audit.

## Next Step

[Single concrete action. One sentence. "Start here."]
```

---

## After the Audit

The audit gives you a map and a starting point. From here:

- Read the [brownfield migration path](ADAPTING.md#from-chaos-to-constraint) for the full adoption strategy.
- Read the [Construction module](modules/construction/) when you are ready to wire your toolchain.
- Read [AGENT.md](AGENT.md) when your project is ready for agent-driven development under UEM.
