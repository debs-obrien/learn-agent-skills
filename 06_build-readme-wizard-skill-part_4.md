# Phase 4: Validate and Finish

**Success check:** Generate a README end-to-end and verify the check script passes.

**Prerequisites:** Bash, `grep`, `sed`, and `curl`. If you want GitHub API lookups, set `GITHUB_TOKEN` to avoid rate limits. On Windows, use WSL for the scripts.

### Step 10: Add a validation script

We want a quick way to check if a generated README has all the expected sections. This is another good use of `scripts/`: a repeatable check that gives us a pass/fail report.

Copy this prompt:

```
Create .agents/skills/readme-wizard/scripts/check_readme.sh that takes a README file path and validates it has all expected sections: headings, badges, code blocks, project structure, docs, contributing, social links, star history, and contributor avatars. Format the output as a nice report with ✅ and ❌ and a pass/fail summary. Make sure it works on both macOS and Linux. Make it executable.
```

The agent creates the validation script. Now we can check any generated README instantly.

### Step 11: Add evals

Evals are test cases that define what "good" looks like. Think of them like unit tests for your skill. They're optional but useful for tracking whether changes to the skill improve or break things.

Copy this prompt:

```
Create .agents/skills/readme-wizard/evals/evals.json with 2 test cases for the readme-wizard skill. Each should have a realistic prompt (the kind of thing a real developer would type), an expected output description, and plain English assertions describing what the improved README should contain. One prompt should be straightforward ("improve the README for this project") and one should be more casual ("my repo needs a better README, can you make it look professional?").
```

The agent creates the evals file. You now have a formal definition of what the skill should produce.

### Step 12: Test the final version

Let's test the fully refactored skill end-to-end. The agent will now use the scan script, read the reference file, pick badges from the catalog, fill in the template, and improve the README.

Copy this prompt:

```
Improve the README for the project at /path/to/your/project. Use the readme-wizard skill: run the scan script first, then follow the SKILL.md instructions.
```

The agent will:
1. Run `scripts/scan_project.sh` → get JSON metadata
2. Read `references/readme-best-practices.md` for guidance
3. Pick badges from `assets/badges.json`
4. Fill in `assets/readme-template.md`
5. If the project is complex enough, read `assets/diagrams.md` and add a Mermaid diagram
6. Generate the full README

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

Each bug led to a fix in the scan script and a new rule in the SKILL.md. That's normal. Skills get better through iteration.

## What We Built

Look at your skill folder now:

```
.agents/skills/readme-wizard/
├── SKILL.md                    ← the brain (lean, focused on steps)
├── scripts/
│   ├── scan_project.sh         ← mechanical work (runs without loading)
│   └── check_readme.sh         ← validation (repeatable checks)
├── references/
│   └── readme-best-practices.md  ← domain knowledge (loaded on demand)
├── evals/
│   └── evals.json              ← test cases (what "good" looks like)
└── assets/
    ├── badges.json             ← badge catalog (plugged into output)
    ├── readme-template.md      ← README structure (consistent every time)
    └── diagrams.md             ← Mermaid templates (starting points)
```

Every folder earned its place. We didn't start with this structure. We started with one file, hit the limits, and extracted pieces as we needed them. That's how real skills get built.

Want to compare your skill against ours? Check out the finished [README Wizard skill](https://github.com/debs-obrien/readme-wizard) with all the files, scripts, and examples.

## Next Steps

Your skill is complete. Now let's share it with the world.

**Next:** [Tutorial 7: Share Your Skill →](07_share-your-skill.md)
