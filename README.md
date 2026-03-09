<div align="center">

# Learn Agent Skills

A hands-on tutorial series for building agent skills — reusable instructions that teach AI coding agents how to do specific tasks well.

[![License](https://img.shields.io/github/license/debs-obrien/learn-agent-skills?style=for-the-badge)](LICENSE)
[![Stars](https://img.shields.io/github/stars/debs-obrien/learn-agent-skills?style=for-the-badge)](https://github.com/debs-obrien/learn-agent-skills/stargazers)

[![What Are Agent Skills?](https://img.youtube.com/vi/2REiUlciObk/maxresdefault.jpg)](https://youtu.be/2REiUlciObk?si=im87wwgj8vcN91br)

</div>

Learn Agent Skills teaches you how to build agent skills from scratch. Skills are reusable instructions that teach AI coding agents (GitHub Copilot, Claude Code, Cursor, and others) how to perform specific tasks well. Follow the tutorials in order and build a fully working README Wizard skill by the end.

![Before vs After](assets/before-vs-after.png)

## Quick Start

Clone the repo and start with Tutorial 1:

```bash
git clone https://github.com/debs-obrien/learn-agent-skills.git
cd learn-agent-skills
```

Open it in VS Code (or your preferred editor with an AI agent) and follow the tutorials in order.

## Tutorials

| # | Tutorial | What you'll learn |
|---|----------|-------------------|
| 1 | [Build Your First Skill](01_build-first-agent-skill.md) | What skills are, how they work, and build a simple one |
| 2 | [Anatomy of a Skill](02_skill-deep-dive.md) | The folder structure, how skills get loaded, and progressive disclosure |
| 3 | [Build the README Wizard — Phase 1](03_build-readme-wizard-skill-part_1.md) | Create the skill folder, write a basic SKILL.md, and test it |
| 4 | [Build the README Wizard — Phase 2](04_build-readme-wizard-skill-part_2.md) | Add detail: badges, best practices, templates, and diagrams |
| 5 | [Build the README Wizard — Phase 3](05_build-readme-wizard-skill-part_3.md) | Refactor into the skill folder structure with references, assets, and scripts |
| 6 | [Build the README Wizard — Phase 4](06_build-readme-wizard-skill-part_4.md) | Add validation, evals, and test end-to-end |
| 7 | [Share Your Skill](07_share-your-skill.md) | Push to GitHub and install with the skills CLI |

## Project Structure

```
learn-agent-skills/
├── 01_build-first-agent-skill.md          # Tutorial 1: What skills are
├── 02_skill-deep-dive.md                  # Tutorial 2: Anatomy of a skill
├── 03_build-readme-wizard-skill-part_1.md # Tutorial 3: Phase 1 — Get it working
├── 04_build-readme-wizard-skill-part_2.md # Tutorial 4: Phase 2 — Add detail
├── 05_build-readme-wizard-skill-part_3.md # Tutorial 5: Phase 3 — Refactor
├── 06_build-readme-wizard-skill-part_4.md # Tutorial 6: Phase 4 — Validate
├── 07_share-your-skill.md                 # Tutorial 7: Share it
├── .github/
│   └── skills/
│       └── good-morning/                  # Example skill from Tutorial 1
│           └── SKILL.md
├── assets/                                # Images used in the tutorials
├── LICENSE
└── README.md
```

## Prerequisites

- **An AI coding agent**: [GitHub Copilot](https://github.com/features/copilot), [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [Cursor](https://cursor.sh), or any [skills-compatible agent](https://skills.sh)
- **A project to test against**: your own repo, or clone any public repo

## Use the skill on any project

Once you've built the README Wizard (or if you just want to try it), you can use it on any project.

**Install the finished skill:**

```bash
npx skills add debs-obrien/readme-wizard
```

**Then open any project and copy this prompt:**

```
Improve the README for this project using the readme-wizard skill.
```

That's it. The agent will scan the project, read the best practices, pick the right badges, and generate a polished README.

**Works with remote repos too.** Clone any GitHub repo and run it:

```bash
git clone https://github.com/OWNER/REPO.git
cd REPO
```

```
Improve the README for this project using the readme-wizard skill.
```

**Or be more specific:**

```
Improve the README for this project. Run the scan script first to detect the project metadata, then follow the readme-wizard skill instructions. Make sure to include badges, a quick start section, and a project structure tree.
```

## Contributing

Contributions are welcome. Open an issue or submit a pull request.

<a href="https://github.com/debs-obrien/learn-agent-skills/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=debs-obrien/learn-agent-skills" />
</a>

## License

MIT License — see [LICENSE](LICENSE) for details.

---

<div align="center">

[![Star History Chart](https://api.star-history.com/svg?repos=debs-obrien/learn-agent-skills&type=Date)](https://star-history.com/#debs-obrien/learn-agent-skills&Date)

</div>