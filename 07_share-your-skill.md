# Share your skill

Your skill is just files in a folder. To share it, push it to a GitHub repo so anyone can install it with a single command.

**Time estimate:** 20-30 minutes

**Success check:** You can install the skill from GitHub and it triggers in a new chat.

### Push to GitHub

Create a new repo for your skill. Keep the skill in the `.agents/skills/` structure, so your repo should look like this:

```
my-project/             ← repo root
└── .agents/
	└── skills/
		└── readme-wizard/
			├── SKILL.md
			├── scripts/
			├── references/
			├── assets/
			└── evals/
```

Tell your agent:

> Copy the readme-wizard skill folder from `.agents/skills/readme-wizard` into a new directory outside this project. Initialize it as a git repo and push it to a new GitHub repo called `readme-wizard` under my account.

Or do it manually:

```bash
cp -r .agents/skills/readme-wizard ~/readme-wizard
cd ~/readme-wizard
git init
git add .
git commit -m "feat: readme-wizard skill"
git remote add origin https://github.com/YOUR-USERNAME/readme-wizard.git
git push -u origin main
```

### Install with the skills CLI

The [skills CLI](https://github.com/vercel-labs/skills) (`npx skills`) is the package manager for the open agent skills ecosystem. No installation required — just run it with `npx`.

Anyone can now install your skill:

```bash
npx skills add YOUR-USERNAME/readme-wizard
```

The CLI will prompt you to choose which agents to install to and whether to symlink (recommended) or copy the files. It automatically detects which coding agents you have installed.

By default, skills install to **project scope** (e.g., `.agents/skills/` in the current project). To install globally so the skill is available across all projects, add the `-g` flag:

```bash
npx skills add YOUR-USERNAME/readme-wizard -g
```

### Make your skill global (available in every project)

Global skills are installed into your home directory so they work in any project without copying files. This is great for personal workflows or team-wide conventions.

Tell your agent:

> Install my `readme-wizard` skill globally so it is available in every project. Use the skills CLI and the global flag, then confirm the install location.

If you want to verify it manually, run:

```bash
npx skills list
```

### Install for specific agents

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

### Discover skills

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

### Other useful CLI commands

```bash
npx skills list          # List installed skills
npx skills check         # Check for updates
npx skills update        # Update all installed skills
npx skills remove        # Remove a skill interactively
npx skills init my-skill # Scaffold a new skill from a template
```

### Prerequisites

Skills are discovered automatically by agents that support the [Agent Skills specification](https://agentskills.io). The skills CLI handles installing to the right location for each agent, but here's what to know:

**GitHub Copilot**: Make sure Copilot Chat is enabled in VS Code. Skills in `.agents/skills/` are discovered automatically at session start.

**Claude Code**: Skills in `.claude/skills/` are discovered automatically at session start.

For both agents, start a **new session** after installing a skill.

### Troubleshooting (if the skill doesn't install or trigger)

- Verify your repo has `SKILL.md` at the repo root
- Re-run `npx skills add ...` and choose project scope if you're testing locally
- Start a new chat session so the agent re-discovers skills

### Key principles

1. **The description is the trigger**: make it specific and pushy so the agent knows when to use the skill
2. **Keep SKILL.md under 500 lines**: put detailed knowledge in references, data in assets
3. **Scripts save tokens**: they run without loading into the agent's context
4. **Selective loading**: not every file needs to load every time. Tell the agent when to skip
5. **Iterate**: write, test, fix, repeat. Skills get better through use

### What to build next

Now that you know how skills work, here are some ideas:

- **Commit message generator**: follows your team's conventional commits format
- **PR description writer**: reads the branch diff and writes a structured PR body
- **Code review checklist**: applies your team's review standards
- **Changelog generator**: reads git log between tags and produces a formatted CHANGELOG
- **API documentation generator**: scans endpoints and generates docs

### Useful links

- [skills.sh](https://skills.sh): browse and discover skills
- [Skills CLI source code](https://github.com/vercel-labs/skills): the open source CLI
- [Agent Skills specification](https://agentskills.io): the full spec
- [Example skills by Anthropic](https://github.com/anthropics/skills): official examples
- [GitHub Copilot](https://github.com/features/copilot): AI coding agent in VS Code
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code): Anthropic's AI coding agent

