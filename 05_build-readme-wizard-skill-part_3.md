# Phase 3: Refactor into the skill structure

**Time estimate:** 45-90 minutes

**Success check:** Your skill folder includes references, assets, and scripts, and the scan script outputs JSON.

> 🎬 **Video 4: Refactor Your Skill** (12-15 min) — [Watch on YouTube](#) *(link coming soon)*


Now we're going to break the bloated SKILL.md into separate files. Each extraction has a clear reason. By the end, you'll understand exactly why skills have the folder structure they do.

#### Step 6: Extract best practices → `references/`

The best practices section is 40+ lines of writing guidance. The agent only needs this when it's about to write the README, not every time the skill loads. By moving it to a reference file, the agent reads it on demand instead of loading it into context upfront. This is what the `references/` folder is for: domain knowledge that loads only when needed.

Tell your agent:

> The best practices section in our SKILL.md is making the file too long. Move it into a new file at `.agents/skills/readme-wizard/references/readme-best-practices.md`. Include a table of contents at the top. Then update the SKILL.md to replace that section with a single line: "Read `references/readme-best-practices.md` for guidance on structure, tone, and what makes a README great."

The agent creates the reference file and updates the SKILL.md. Open both files. Notice how the SKILL.md is shorter and focused on the steps, while the reference file has all the deep knowledge about README writing.

#### Step 7: Extract badge templates → `assets/`

The badge guide section is data, not instructions. It's a catalog of shields.io URL formats that will grow as we add more badge types. By moving it to a JSON file, the agent looks up what it needs instead of reading through a wall of markdown. This is what the `assets/` folder is for: reusable data files that get plugged into the output.

Tell your agent:

> Move the badge guide section from SKILL.md into `.agents/skills/readme-wizard/assets/badges.json`. Organize badges into categories (status, social, extras) with `{{PLACEHOLDER}}` markers for dynamic values like owner, repo, and channel IDs. Update the SKILL.md to reference the file.

The agent creates the JSON file and updates the SKILL.md. The instructions now point to the badge catalog instead of listing every URL format inline.

#### Step 8: Extract the template and diagrams → `assets/`

The README template and Mermaid diagrams are also output files, not instructions. Let's move them to assets too. The template ensures consistent structure every time, and the diagram templates give the agent starting points for different project types.

This is also a good example of **selective loading**. Not every project needs an architecture diagram. A simple library or a small CLI tool doesn't benefit from one. By putting the diagram templates in a separate file, the SKILL.md can tell the agent: "only read `assets/diagrams.md` if the project has multiple components or a clear data flow." Simple projects skip the file entirely and save those tokens.

Tell your agent:

> Move the README template from SKILL.md into `.agents/skills/readme-wizard/assets/readme-template.md` with `{{PLACEHOLDER}}` markers for dynamic content. Also move the Mermaid diagram templates into `.agents/skills/readme-wizard/assets/diagrams.md` with templates for common project types. Update the SKILL.md to reference both files.

The agent creates both asset files and updates the SKILL.md. The instructions now say "use this template" and "pick a diagram from these templates" instead of embedding them inline.

#### Step 9: Extract scanning logic → `scripts/`

Here's a big one. Every time we test the skill, the agent writes the same code to parse package.json, read the git remote, check for a license file, and detect the CI setup. That's wasted tokens and it's error-prone: sometimes it parses the git remote wrong, sometimes it misses the CI workflow. By moving this into a bash script, the agent runs it once and gets clean JSON back. This is what the `scripts/` folder is for: deterministic, repeatable work that runs without loading into the agent's context.

Tell your agent:

> Create `.agents/skills/readme-wizard/scripts/scan_project.sh` that takes a project directory path and outputs JSON with everything we need: project name, description, license, git remote (owner/repo), package manager, CI setup, social links, and directory structure. For social links, search local project files first, then the GitHub API for the homepage URL, then crawl the homepage for links in the footer. Also resolve YouTube channel IDs and Discord server IDs so we can use live count badges. Make sure it works on both macOS and Linux. Make it executable and update the SKILL.md to reference it.

The agent creates the script and updates the SKILL.md. Now instead of the agent writing scanning code from scratch every time, it runs one script and gets structured JSON back. Faster, more reliable, and it doesn't eat into the context window.

Test the script right away:

```bash
bash .agents/skills/readme-wizard/scripts/scan_project.sh /path/to/your/project
```

You should see clean JSON with all the detected metadata.

### Prerequisites and limits

- The script assumes bash, `grep`, `sed`, and `curl` are available
- GitHub API lookups can hit rate limits; set `GITHUB_TOKEN` for reliability
- On Windows, use WSL to run the script

### Troubleshooting (if the script fails or returns empty JSON)

- Check file permissions: `chmod +x .agents/skills/readme-wizard/scripts/scan_project.sh`
- Run it with a full path to the project directory
- If GitHub API fails, verify your `GITHUB_TOKEN` or remove the API step temporarily
