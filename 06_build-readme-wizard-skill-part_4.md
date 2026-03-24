# Phase 4: Validate and Finish

**Success check:** Generate a README end-to-end and verify the check script passes.

**Prerequisites:** Bash, `grep`, `sed`, and `curl`. If you want GitHub API lookups, set `GITHUB_TOKEN` to avoid rate limits. On Windows, use WSL for the scripts.

### Step 10: Add a validation script

We want a quick way to check if a generated README has all the expected sections. This is another good use of `scripts/`: a repeatable check that gives us a pass/fail report.

Copy this prompt:

```
Create .agents/skills/readme-wizard/scripts/check_readme.sh that takes a README file path and validates it has all expected sections: headings, badges, code blocks, project structure, docs, contributing, star history, and contributor avatars. For social links, only check if the project actually has social links — skip the check with a note if none exist (this is expected for projects without social media presence). Format the output as a nice report with ✅ and ❌ and a pass/fail summary. Make sure it works on both macOS and Linux. Make it executable.
```

The agent creates the validation script. Now we can check any generated README instantly.

*(Tip: Just like in the previous step, make sure to manually run `chmod +x .agents/skills/readme-wizard/scripts/check_readme.sh` in your terminal if the agent forgot to make it executable!)*

### Step 11: Add evals

Evals are test cases that define what "good" looks like. Think of them like unit tests for your skill. They're optional but useful for tracking whether changes to the skill improve or break things.

Copy this prompt:

```
Create .agents/skills/readme-wizard/evals/evals.json with 4 test cases for the readme-wizard skill. Each should have a realistic prompt (the kind of thing a real developer would type), an expected output description, and plain English assertions describing what the improved README should contain. The test cases should cover: (1) a straightforward request ("improve the README for this project"), (2) a casual request ("my repo needs a better README, can you make it look professional?"), (3) a minimal project ("Generate a README for this project. It's just a small script, nothing fancy." — verify the README is proportional to the project size and doesn't bloat), and (4) a badge-focused request ("I want to add some nice badges to my README, the shields.io kind. Can you help?" — verify badges are correctly formatted and only reference things that exist).
```

The agent creates the evals file. You now have a formal definition of what the skill should produce.

### Step 12: Test the final version

Let's test the fully refactored skill end-to-end. The agent will now use the scan script, read the reference file, pick badges from the catalog, fill in the template, and improve the README.

Copy this prompt:

```
Improve the README for this project. Use the readme-wizard skill: run the scan script first, then follow the SKILL.md instructions.
```

The agent will follow the 6-step workflow in the SKILL.md:
1. Run `scripts/scan_project.sh` → get JSON metadata
2. Read `references/readme-best-practices.md` for guidance on structure, tone, and project-type adaptation
3. Build the README using `assets/readme-template.md`, adapting sections to the project type
4. Add badges from `assets/badges.json` — only for things that actually exist
5. Validate with `scripts/check_readme.sh`
6. If the project is complex enough, read `assets/diagrams.md` and add a Mermaid diagram

Then validate it.

Copy this prompt:

```
Run the check_readme.sh script against the generated README and show me the validation report.
```

If everything passes, great! If something fails, that's the build loop in action. Fix the issue and test again.

## Troubleshooting

- Confirm your README follows the template sections in `assets/readme-template.md`
- Ensure badges are shields.io and use `style=for-the-badge`
- If a section is missing (docs, contributors, star history), update the SKILL.md rules and re-run

When we built this skill, we went through several rounds of fixes:
- **Git remote parsing**: HTTPS URLs weren't extracting owner/repo correctly
- **CI workflow detection**: it missed workflow files with non-standard names like `playwright.yml`
- **YouTube URL formats**: the regex only handled `/@handle` but not `/c/name`
- **Social link guessing**: the agent invented social media handles that didn't exist
- **Social link checks failing**: the validation script marked social links as ❌ even for projects that don't have any — fixed by making the check conditional

Each bug led to a fix in the scan script and a new rule in the SKILL.md. That's normal. Skills get better through iteration.

## What We Built

Look at your skill folder now:

```
.agents/skills/readme-wizard/
├── SKILL.md                    ← the brain (lean 6-step workflow)
├── scripts/
│   ├── scan_project.sh         ← mechanical work (runs without loading)
│   └── check_readme.sh         ← validation (conditional social check)
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
