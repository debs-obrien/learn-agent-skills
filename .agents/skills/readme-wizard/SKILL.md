---
name: readme-wizard
description: >-
  Generate a polished, professional README.md for any project — from scratch or by improving an existing one. Use this skill whenever the user mentions README, wants to improve their repo's first impression, asks about shields.io badges, wants a star history chart, contributor avatars, documentation tables, project structure trees, or mermaid architecture diagrams in their README. Also use it when someone wants their GitHub repo to "look more professional", "look legit", or make a better first impression — even if they never say the word "README". Covers badge generation, README rewrites for new versions, fork customization, and adapting README structure to different project types (libraries, apps, docs repos, monorepos). Does NOT cover: CONTRIBUTING.md, CHANGELOG, API documentation, CI/CD setup, GitHub profile READMEs, or generating docs for individual components.
---

# README Wizard

Generate or improve a project's README by scanning the repo and producing a polished, professional result based on real project data.

## Workflow

### 1. Scan the project

Run `scripts/scan_project.sh <project-directory>` to collect structured JSON metadata:
- **Project name** and description
- **License** type
- **Git remote** (owner and repo name)
- **Package manager** (npm, yarn, pnpm, pip, cargo, go, etc.)
- **CI setup** (provider and workflow files)
- **Social links** (YouTube, Discord, Twitter, LinkedIn, Bluesky, Twitch)
- **Directory structure** (top 2 levels)

The script checks local files first, then the GitHub API for the homepage URL, then crawls the homepage for social links. It resolves YouTube channel IDs and Discord server IDs for live count badges.

**Handling missing data:** The scan will return empty strings for anything it can't find. Never fabricate metadata — if a field is empty, skip the related section or badge entirely. For example: no CI workflows means no build badge; no social links means no social section.

### 2. Read the best practices guide

Read `references/readme-best-practices.md` before writing. It covers structure, tone, project-type adaptation, and common pitfalls. This context makes a real difference in output quality — the guide explains the reasoning behind each section so you produce READMEs that feel intentional rather than formulaic.

### 3. Build the README

Use `assets/readme-template.md` as the base structure. Replace `{{PLACEHOLDER}}` markers with actual project data from the scan.

**Adapt — don't copy blindly.** The template is a starting point. Drop sections that don't apply (e.g., no Contributing section for a personal notes repo) and adjust the tone to match the project:
- **Libraries/frameworks**: Focus on installation, API, and examples
- **Applications**: Focus on setup, configuration, and screenshots
- **Docs/learning repos**: Focus on structure and navigation
- **Small utilities/scripts**: Keep it short — hero + what it does + usage is enough

### 4. Add badges

Read `assets/badges.json` for the full badge catalog organized by category (status, social, extras) with `{{PLACEHOLDER}}` markers for dynamic values. Use `style=for-the-badge` for all badges.

**Golden rule:** Only include badges for things that actually exist. A badge for a nonexistent CI workflow or a guessed npm package is worse than no badge at all.

### 5. Validate the output

Run `scripts/check_readme.sh <path-to-readme>` to verify the generated README has all expected sections and formatting. Review any failures and fix them. Note: the social links check will skip if the project has no social links — that's expected.

### 6. Optionally add a diagram

Only read `assets/diagrams.md` if the project has multiple components or a clear data flow (APIs, monorepos, content pipelines). Skip entirely for simple projects. Generate the diagram from the project's actual structure — the templates in the file are starting points to adapt, not copy.
