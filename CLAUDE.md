# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

A hands-on tutorial series for building **agent skills** — reusable instruction sets that teach AI coding agents (GitHub Copilot, Claude Code, Cursor, etc.) how to perform specific tasks. Learners follow 7 sequential tutorials to build a "README Wizard" skill that generates polished README files for any project.

This is a **documentation-only repository** — no application code, no build system, no test framework. Content is Markdown tutorials and Bash scripts.

## Repository Structure

- **Tutorials (`01_*.md` through `07_*.md`)**: Sequential lessons meant to be followed in order. Each contains prompts for learners to paste into their AI agent.
- **`.agents/skills/`**: Contains finished reference implementations of skills built in the tutorials (Copilot/cross-agent path).
- **`.agents/skills/readme-wizard/`**: The main skill built across Tutorials 3-6, with sub-folders for `scripts/`, `references/`, `assets/`, and `evals/`.
- **`assets/`**: Images used within the tutorial Markdown files.
- **`readme-wizard-workspace/`**: Gitignored directory for skill optimization/eval artifacts.

## Key Conventions

- **Skill folder structure** follows the [Agent Skills open standard](https://agentskills.io): `SKILL.md` (instructions + YAML frontmatter), `scripts/` (deterministic shell work), `references/` (domain knowledge), `assets/` (data/templates), `evals/` (test cases).
- **SKILL.md frontmatter**: YAML between `---` markers with `name` and `description` fields. The folder name must match the `name:` field exactly.
- **Claude Code users** use `.claude/skills/` instead of `.agents/skills/` — this distinction is noted throughout the tutorials.
- **Shell scripts** (`scan_project.sh`) must be executable (`chmod +x`).
- **Commit messages** use conventional-style prefixes (e.g., `refactor:`, `fix:`).

## Running the Scripts

Scan a project for metadata (outputs JSON):
```bash
bash .agents/skills/readme-wizard/scripts/scan_project.sh <project-directory>
```

## Evals

Test cases live in `.agents/skills/readme-wizard/evals/evals.json` — 4 scenarios with human-readable assertions. There is no automated test runner; evals are validated manually or by an AI agent checking assertions against generated output.

## Tutorial Format

Each tutorial follows a consistent structure: success check at top, prerequisites checklist, step-by-step instructions with "Copy this prompt" code blocks, troubleshooting section, and "Next Steps" link to the next tutorial.

## Skills CLI

Skills can be installed with `npx skills add <owner>/<skill-name>` and discovered at [skills.sh](https://skills.sh).
