# Phase 4: Validate and Finish

**Success check:** Generate a README end-to-end and confirm it has badges, a Quick Start section, a project structure tree, and contributor avatars.

**Prerequisites:** Bash, `grep`, `sed`, and `curl` (for the scan script). On Windows, use WSL for the scripts.

### Prerequisites Checklist for Phase 4

Before you start, verify you have:

- ✅ Tutorial 5 completed (references, assets, and scripts folders exist)
- ✅ `scan_project.sh` tested successfully (outputs valid JSON)
- ✅ Scripts are executable (ran `chmod +x` or confirmed they work)
- ✅ Agent ready for a new chat session

---

### Step 10: Add evals

Evals are test cases that define what "good" looks like. Think of them like unit tests for your skill. They're optional but useful for tracking whether changes to the skill improve or break things.

Copy this prompt:

```
Create .agents/skills/readme-wizard/evals/evals.json with 4 test cases for the readme-wizard skill. Each should have a realistic prompt (the kind of thing a real developer would type), an expected output description, and plain English assertions describing what the improved README should contain. The test cases should cover: (1) a straightforward request ("improve the README for this project"), (2) a casual request ("my repo needs a better README, can you make it look professional?"), (3) a minimal project ("Generate a README for this project. It's just a small script, nothing fancy." — verify the README is proportional to the project size and doesn't bloat), and (4) a badge-focused request ("I want to add some nice badges to my README, the shields.io kind. Can you help?" — verify badges are correctly formatted and only reference things that exist).
```

The agent creates the evals file. You now have a formal definition of what the skill should produce.

### Step 11: Test the final version

Let's test the fully refactored skill end-to-end. The agent will now use the scan script, read the reference file, pick badges from the catalog, fill in the template, and improve the README.

Copy this prompt:

```
Improve the README for this project. Use the readme-wizard skill: run the scan script first, then follow the SKILL.md instructions.
```

The agent will follow the workflow in the SKILL.md:
1. Run `scripts/scan_project.sh` → get JSON metadata
2. Read `references/readme-best-practices.md` for guidance on structure, tone, and project-type adaptation
3. Build the README using `assets/readme-template.md`, adapting sections to the project type
4. Add badges from `assets/badges.json` — only for things that actually exist
5. If the project is complex enough, read `assets/diagrams.md` and add a Mermaid diagram

Review the output yourself. Does it have the right sections? Are the badges real? Is the tone right? You can also ask the agent to validate:

```
Review the generated README against the assertions in evals/evals.json. Check for placeholder text, fabricated badges, missing sections, or unnecessary bloat.
```

If something's wrong, that's the build loop in action. Fix the issue and test again.

## Troubleshooting

- Confirm your README follows the template sections in `assets/readme-template.md`
- Ensure badges are shields.io and use `style=for-the-badge`
- If a section is missing (docs, contributors, star history), update the SKILL.md rules and re-run

### Bugs we found and fixed during development

When we built this skill, we went through several rounds of fixes. These are common issues you might hit too:
- **Git remote parsing**: HTTPS URLs weren't extracting owner/repo correctly
- **CI workflow detection**: it missed workflow files with non-standard names like `playwright.yml`
- **YouTube URL formats**: the regex only handled `/@handle` but not `/c/name`
- **Social link guessing**: the agent invented social media handles that didn't exist

Each bug led to a fix in the scan script and a new rule in the SKILL.md. That's normal. Skills get better through iteration.

## What We Built

Look at your skill folder now:

```
.agents/skills/readme-wizard/
├── SKILL.md                    ← the brain (lean workflow)
├── scripts/
│   └── scan_project.sh         ← mechanical work (runs without loading)
├── references/
│   └── readme-best-practices.md  ← domain knowledge (includes project-type adaptation)
├── evals/
│   └── evals.json              ← 4 test cases (what "good" looks like)
└── assets/
    ├── badges.json             ← badge catalog (plugged into output)
    ├── readme-template.md      ← README structure (consistent every time)
    └── diagrams.md             ← Mermaid templates (starting points)
```

Every folder earned its place. We didn't start with this structure. We started with one file, hit the limits, and extracted pieces as we needed them. That's how real skills get built.

Want to compare your skill against ours? Check out the finished **README Wizard skill** right here in this repository under the `.agents/skills/readme-wizard/` folder! It includes all the files, scripts, and examples we've built.

## Next Steps

Your skill is complete. Now let's share it with the world.

**Next:** [Tutorial 7: Share Your Skill →](07_share-your-skill.md)
