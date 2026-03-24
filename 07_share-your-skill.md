# Share your skill

Your skill is just files in a folder. To share it, push it to a GitHub repo so anyone can install it with a single command.

**Success check:** You can install the skill from GitHub and it triggers in a new chat.

## Two Ways to Share

| Approach | Best for | Install command |
|----------|----------|-----------------|
| **Subdirectory** | Tutorials, multi-skill repos | `npx skills add USER/REPO --skill skill-name` |
| **Dedicated repo** | Standalone skills, easier discovery | `npx skills add USER/skill-name` |

**Which should I choose?**
- **If you're following this tutorial:** Use **Option A (subdirectory)**. If you built the skill in a separate practice repo, this is the simplest path.
- **If you want standalone discovery on skills.sh:** Use **Option B (dedicated repo)**. This is better for long-term skill distribution.

---

### Option A: Skill in a subdirectory

Keep the skill inside an existing repo. Your skill is already here if you followed the tutorials:

```
your-project/
└── .agents/
    └── skills/
        └── readme-wizard/
            ├── SKILL.md
            ├── scripts/
            ├── references/
            ├── assets/
            └── evals/
```

Push your project to GitHub, then anyone can install the skill:

```bash
npx skills add YOUR-USERNAME/YOUR-REPO --skill readme-wizard
```

To see what skills are available in a repo:

```bash
npx skills add YOUR-USERNAME/YOUR-REPO --list
```

> **Claude Code users:** Your skill is in `.claude/skills/` — the CLI handles this automatically.

---

### Option B: Dedicated repo

Create a new repo just for the skill. The `SKILL.md` goes at the repo root:

```
readme-wizard/          ← repo root
├── SKILL.md
├── scripts/
├── references/
├── assets/
└── evals/
```

The safest workflow is:

1. Create a new GitHub repo called `readme-wizard`.
2. Create a local folder for that repo and clone it.
3. Copy the contents of your skill folder into the repo root so `SKILL.md` sits at the top level.
4. Commit and push using your normal `git` or `gh` workflow.

If you want your agent to prepare the files locally, use this prompt:

```
Copy the readme-wizard skill folder contents from .agents/skills/readme-wizard into a new local directory named readme-wizard-export. Put SKILL.md at the root, not in a subdirectory.
```

Then create the remote repo and push it yourself. That's more reliable than assuming your agent has GitHub authentication and permission to publish on your behalf.

Then anyone can install with a clean command:

```bash
npx skills add YOUR-USERNAME/readme-wizard
```

---

## Install Globally (Available in Every Project)

By default, skills only work in the project where they're installed. Use the `-g` flag to install a skill so it's available when you work on **any** project on your machine.

```bash
# Subdirectory skill
npx skills add YOUR-USERNAME/YOUR-REPO --skill readme-wizard -g

# Dedicated repo skill
npx skills add YOUR-USERNAME/readme-wizard -g
```

To verify installation:

```
List my installed skills and confirm readme-wizard is installed globally.
```

## Install for Specific Agents

The skills CLI supports 40+ agents including GitHub Copilot, Claude Code, Cursor, Codex, Windsurf, Amp, Roo, Gemini CLI, and many more. You can target specific agents:

```bash
# Install for a specific agent
npx skills add YOUR-USERNAME/readme-wizard -a github-copilot
npx skills add YOUR-USERNAME/readme-wizard -a claude-code
npx skills add YOUR-USERNAME/readme-wizard -a cursor

# Install for all supported agents at once
npx skills add YOUR-USERNAME/readme-wizard --all

# Non-interactive (useful for CI or scripts)
npx skills add YOUR-USERNAME/readme-wizard -a claude-code -g -y
```

## Discover Skills

Browse what others have built, or search from the command line:

```bash
# Interactive search
npx skills find

# Search by keyword
npx skills find readme

# List skills in a repo without installing
npx skills add vercel-labs/agent-skills --list
```

Visit [skills.sh](https://skills.sh) to browse the leaderboard of most-installed skills.

## Other Useful CLI Commands

```bash
npx skills list          # List installed skills
npx skills check         # Check for updates
npx skills update        # Update all installed skills
npx skills remove        # Remove a skill interactively
npx skills init my-skill # Scaffold a new skill from a template
```

## Troubleshooting (if the skill doesn't install or trigger)

- **Subdirectory skills**: Make sure you're using `--skill skill-name` flag
- **Dedicated repo skills**: Verify `SKILL.md` is at the repo root
- Run `npx skills add YOUR-USERNAME/YOUR-REPO --list` to see what skills are detected
- Re-run `npx skills add ...` and choose project scope if you're testing locally
- Start a new chat session so the agent re-discovers skills

## Key Principles

1. **The description is the trigger**: make it specific and pushy so the agent knows when to use the skill
2. **Keep SKILL.md under 500 lines**: put detailed knowledge in references, data in assets
3. **Scripts save tokens**: they run without loading into the agent's context
4. **Selective loading**: not every file needs to load every time. Tell the agent when to skip
5. **Iterate**: write, test, fix, repeat. Skills get better through use

## What to Build Next

Now that you know how skills work, here are some ideas:

- **Commit message generator**: follows your team's conventional commits format
- **PR description writer**: reads the branch diff and writes a structured PR body
- **Code review checklist**: applies your team's review standards
- **Changelog generator**: reads git log between tags and produces a formatted CHANGELOG
- **API documentation generator**: scans endpoints and generates docs

## Useful Links

- [skills.sh](https://skills.sh): browse and discover skills
- [Skills CLI source code](https://github.com/vercel-labs/skills): the open source CLI
- [Agent Skills specification](https://agentskills.io): the full spec
- [Example skills by Anthropic](https://github.com/anthropics/skills): official examples
- [GitHub Copilot](https://github.com/features/copilot): AI coding agent in VS Code
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code): Anthropic's AI coding agent

