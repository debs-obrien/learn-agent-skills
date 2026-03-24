# Phase 3: Refactor Into the Skill Structure

**Success check:** List the contents of the readme-wizard skill folder and confirm you see `references/`, `assets/`, and `scripts/`. Run the scan script and verify it outputs valid JSON.

> **Claude Code users:** Replace `.agents/skills/` with `.claude/skills/` in the prompts below.

### Prerequisites Checklist for Phase 3

Before you start, verify you have:

- ✅ Tutorial 4 completed (detailed SKILL.md with best practices, badges, diagrams)
- ✅ Skill tested twice with consistent results
- ✅ `.agents/skills/readme-wizard/SKILL.md` is around 150+ lines

**Note:** This phase requires bash scripts. **Windows users:** Make sure you have WSL2 or Git Bash set up (see Tutorial 1 for setup link). If not set up, you can skip the script sections.

### Scripts Must Be Executable ⚙️

When the agent creates bash scripts (`.sh` files), it should make them executable. However, if something goes wrong, you'll get a "permission denied" error when trying to run the script.

**Quick fix:** Open your terminal and run:

```bash
chmod +x .agents/skills/readme-wizard/scripts/*.sh
```

This makes all scripts in the folder executable. Do this once at the start of Phase 3, and you're covered for the rest of the tutorial.

---

Now we're going to break the bloated SKILL.md into separate files. Each extraction has a clear reason. By the end, you'll understand exactly why skills have the folder structure they do.

### Step 6: Extract best practices → `references/`

The best practices section is 40+ lines of writing guidance — structure, tone, project-type adaptation, common pitfalls. The agent only needs this when it's about to write the README, not every time the skill loads. By moving it to a reference file, the agent reads it on demand instead of loading it into context upfront. This is what the `references/` folder is for: domain knowledge that loads only when needed.

Copy this prompt:

```
The best practices section in our SKILL.md is making the file too long. Move it into a new file at .agents/skills/readme-wizard/references/readme-best-practices.md. Include a table of contents at the top with sections for Structure and Order, Writing Tone, Adapting to Project Type, Badge Best Practices, and Common Pitfalls. Then update the SKILL.md to tell the agent: "Read references/readme-best-practices.md before writing. It covers structure, tone, project-type adaptation, and common pitfalls."
```

The agent creates the reference file and updates the SKILL.md. Open both files. Notice how the SKILL.md is shorter and focused on the workflow steps, while the reference file has all the deep knowledge about README writing — including how to adapt the output for different project types and what mistakes to avoid.

### Step 7: Extract badge templates → `assets/`

The badge guide section is data, not instructions. It's a catalog of shields.io URL formats that will grow as we add more badge types. By moving it to a JSON file, the agent looks up what it needs instead of reading through a wall of markdown. This is what the `assets/` folder is for: reusable data files that get plugged into the output.

Copy this prompt:

```
Move the badge guide section from SKILL.md into .agents/skills/readme-wizard/assets/badges.json. Organize badges into categories (status, social, extras) with {{PLACEHOLDER}} markers for dynamic values like owner, repo, and channel IDs. Update the SKILL.md to reference the file.
```

The agent creates the JSON file and updates the SKILL.md. The instructions now point to the badge catalog instead of listing every URL format inline.

### Step 8: Extract the template and diagrams → `assets/`

The README template and Mermaid diagrams are also output files, not instructions. Let's move them to assets too. The template ensures consistent structure every time, and the diagram templates give the agent starting points for different project types.

This is also a good example of **selective loading**. Not every project needs an architecture diagram. A simple library or a small CLI tool doesn't benefit from one. By putting the diagram templates in a separate file, the SKILL.md can tell the agent: "only read `assets/diagrams.md` if the project has multiple components or a clear data flow." Simple projects skip the file entirely and save those tokens.

Copy this prompt:

```
Move the README template from SKILL.md into .agents/skills/readme-wizard/assets/readme-template.md with {{PLACEHOLDER}} markers for dynamic content. For the social links section, use an HTML comment that says to include the section ONLY if the project has social links and remove it entirely if none exist, with the heading "Connect". Also move the Mermaid diagram templates into .agents/skills/readme-wizard/assets/diagrams.md with templates for common project types. Update the SKILL.md to tell the agent to use the template as the base structure, replace placeholders with actual project data, and adapt rather than copy blindly — dropping sections that don't apply and adjusting tone to match the project type.
```

The agent creates both asset files and updates the SKILL.md. The instructions now say "use this template" and "pick a diagram from these templates" instead of embedding them inline.

### Step 9: Extract scanning logic → `scripts/`

Here's a big one. Every time we test the skill, the agent writes the same code to parse package.json, read the git remote, check for a license file, and detect the CI setup. That's wasted tokens and it's error-prone: sometimes it parses the git remote wrong, sometimes it misses the CI workflow. By moving this into a bash script, the agent runs it once and gets clean JSON back. This is what the `scripts/` folder is for: deterministic, repeatable work that runs without loading into the agent's context.

Copy this prompt:

```
Create .agents/skills/readme-wizard/scripts/scan_project.sh that takes a project directory path and outputs JSON with everything we need: project name, description, license, git remote (owner/repo), package manager, CI setup, social links, and directory structure (top 2 levels). Support detecting package managers for npm, yarn, pnpm, pip, cargo, Go (go.mod/go.sum), Gradle, and Deno. For Go projects, parse go.mod to extract the project name from the module path. For social links, search local project files first, then the GitHub API for the homepage URL, then crawl the homepage for links in the footer. Also resolve YouTube channel IDs and Discord server IDs so we can use live count badges. Return empty strings for anything the script can't find. Make sure it works on both macOS and Linux. Use Node.js, Python, or standard grep/sed to parse files so it works without requiring external libraries like jq. Make it executable and update the SKILL.md to reference it.
```

The agent creates the script and updates the SKILL.md. Now instead of the agent writing scanning code from scratch every time, it runs one script and gets structured JSON back. Faster, more reliable, and it doesn't eat into the context window.

Test the script right away.

Copy this prompt:

```
Run the scan_project.sh script on this project directory and show me the JSON output.
```

You should see clean JSON with all the detected metadata.

## Prerequisites and Limits

- The script assumes bash, `grep`, `sed`, and `curl` are available
- On Windows, use WSL to run the script

## Troubleshooting

- If the script won't run, make it executable. Copy this prompt:
  ```
  Make the scan_project.sh script executable.
  ```
- Run it with a full path to the project directory
- If GitHub API fails, check your network connection or remove the API step temporarily

## Stuck? Check the Reference Code

If your files are getting a little messy or you aren't sure if the folder structure is right, remember that **the finished version of this skill is included right here in the repository!** You can peek at the `.agents/skills/readme-wizard/` folder anytime to compare your work against the final "perfect" version.

## Next Steps

Your skill is now properly structured. Let's add evals and test it end-to-end.

**Next:** [Tutorial 6: Build the README Wizard — Phase 4 →](06_build-readme-wizard-skill-part_4.md)
