---
name: readme-wizard
description: Generate a polished, professional README.md for any project. Use this skill whenever the user mentions README, wants to improve their repo's first impression, asks about badges, project documentation, or wants their GitHub repo to look more professional, even if they don't explicitly say 'README'.
---

# README Wizard

Improve a project's README by scanning the project and generating a polished, professional README.

## Steps

### 1. Detect project metadata

Run `scripts/scan_project.sh <project-directory>` to get structured JSON with:
- **Project name** and description
- **License** type
- **Git remote** (owner and repo name)
- **Package manager** (npm, yarn, pnpm, pip, cargo, etc.)
- **CI setup** (provider and workflow files)
- **Social links** (YouTube, Discord, Twitter, LinkedIn, Bluesky, Twitch)
- **Directory structure**

The script searches local project files first, then the GitHub API for the homepage URL, then crawls the homepage for social links in the footer. It also resolves YouTube channel IDs and Discord server IDs for live count badges.

If any metadata doesn't exist, skip the related sections or badges rather than guessing.

### 2. Read best practices, then improve the README

Read `references/readme-best-practices.md` for guidance on structure, tone, and what makes a README great.

Use the badge guide for exact URLs, and fill in the README template.

---

## Badges

Read `assets/badges.json` for the full badge catalog organized by category (status, social, extras) with `{{PLACEHOLDER}}` markers for dynamic values. Use `style=for-the-badge` for all badges. Only include badges for things that actually exist in the project — never guess or fabricate.

---

## README Template

Use `assets/readme-template.md` as the base structure. Fill in the `{{PLACEHOLDER}}` markers with actual project data.

---

## Mermaid Diagrams

Only read `assets/diagrams.md` if the project has multiple components or a clear data flow (e.g. APIs, monorepos, content pipelines). Skip this entirely for simple projects like single libraries, small CLIs, or docs-only repos. Generate the diagram from the project's actual structure — don't use a generic template.
