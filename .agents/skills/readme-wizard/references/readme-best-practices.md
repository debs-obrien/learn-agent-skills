# README Best Practices

## Table of Contents

- [Structure and Order](#structure-and-order)
- [Writing Tone](#writing-tone)
- [Adapting to Project Type](#adapting-to-project-type)
- [Badge Best Practices](#badge-best-practices)
- [Common Pitfalls](#common-pitfalls)

---

## Structure and Order

1. **Hero section** (name + tagline + badges) — the first thing people see
2. **"What is this?"** — answer in 2-3 sentences
3. **Quick Start** — get people running in under 60 seconds
4. **Project structure** — orient the reader
5. **Documentation table** — link to deeper resources
6. **Contributing** — lower the barrier to contribute
7. **Social links** — connect with the community (only if links exist)
8. **Footer** — star history and license

Not every project needs every section. A 50-line CLI tool doesn't need a documentation table with 8 rows. A personal learning repo probably doesn't need a Contributing section. Use judgment — the structure serves the reader, not a checklist.

When you include a project structure, make it feel like a real repo browser view: directories first, then files, each group alphabetized. Add trailing `/` markers to directories so the hierarchy scans quickly.

## Writing Tone

- **Be concise.** Every sentence should earn its place.
- **Be direct.** Use "Run this command" not "You might want to consider running."
- **Be helpful.** Assume the reader is a developer seeing the project for the first time.
- **Use active voice.** "Install dependencies" not "Dependencies should be installed."
- **No marketing fluff.** Describe what it does, not how amazing it is.
- **Match the project's voice.** A playful side project can be lighthearted; an enterprise SDK should be precise and professional.

**Example — good vs. bad "What is this?" section:**

Bad: "This is an amazing, revolutionary, state-of-the-art tool that will transform your workflow forever."

Good: "A CLI that converts Markdown files to PDF with syntax highlighting. Supports custom themes and batch processing."

## Adapting to Project Type

Different projects need different emphasis. The template is a starting point — adapt it.

**Libraries/Frameworks:**
- Lead with installation and a minimal code example
- The Quick Start should show import → use → result in 3-5 lines
- Include API reference or link to generated docs
- A documentation table is essential here

**Web Applications:**
- Lead with a screenshot or demo GIF if available
- Quick Start should cover: clone → install → configure → run
- Include environment setup and configuration details
- Mention deployment if relevant

**Documentation/Learning Repos:**
- Lead with what the reader will learn
- The project structure IS the documentation — make it clear and navigable
- Link individual docs in the documentation table
- Contributing section should explain how to add content

**Small Utilities/Scripts:**
- Keep it short — hero + description + usage examples is enough
- Show concrete input → output examples
- Skip the project structure if it's just a few files
- Skip Contributing unless you actually want contributions

**Monorepos:**
- A Mermaid diagram showing package relationships is valuable here
- The documentation table should link to each package's own README
- Quick Start should explain which package to start with

## Badge Best Practices

- Use `style=for-the-badge` consistently on all badges
- Group status badges (license, version, CI, stars) together at the top
- Group social badges together in a separate section
- Only include badges for things that actually exist — never guess or fabricate
- Use live count badges for YouTube subscribers and Discord members when possible
- Don't overload the hero section — 3-5 status badges is the sweet spot

## Common Pitfalls

- **Placeholder text left in.** Things like `{{PROJECT_NAME}}`, `TODO`, `Lorem ipsum`. The check script catches these but it's worth a manual skim too.
- **Fabricated badges.** If the project has no CI, don't add a build badge. If there's no npm package, don't add a downloads badge. It looks sloppy.
- **Outdated install commands.** If the scan detects pnpm, use `pnpm install`, not `npm install`. Match the project's actual package manager.
- **Generic descriptions.** "A project built with React" tells the reader nothing. What does it DO?
- **Overly long READMEs for simple projects.** A 200-line README for a 50-line script signals poor judgment. Scale the README to the project.
- **Missing Quick Start.** The #1 thing people want is "how do I run this?" — never skip it.
