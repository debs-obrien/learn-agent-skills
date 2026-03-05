### Phase 2: Add more detail

#### Step 4: Flesh out the SKILL.md

The basic skill works but the output is inconsistent. Let's add more detail to the instructions: specific badge formats, best practices for writing tone, a template for the README structure, and clearer rules.

Tell your agent:

> Update the readme-wizard SKILL.md to include more detail. Add a "Best Practices" section with guidance on README structure, section order, and writing tone. Add a "Badge Guide" with the exact shields.io URL formats for status badges (license, version, CI, stars) and social badges (YouTube with subscriber count, Discord with member count, Twitter, LinkedIn, Bluesky, Twitch) all using `style=for-the-badge`. Add a "README Structure" section listing the exact sections in order with a description of what each one contains. Add a "Mermaid Diagrams" section with templates for common project types.

The agent updates the SKILL.md with all this detail. Open it and look at the file size. It's probably 150+ lines now. All the badge formats, best practices, structure guide, and diagram templates are inline.

#### Step 5: Test again

Let's test the improved version.

Tell your agent:

> Improve the README for this project following the readme-wizard skill instructions.

Much better! The badges are consistent, the structure follows the template, the tone is right. But look at the SKILL.md  file. It's getting long and hard to maintain. The badge templates, best practices, README structure, and diagram templates are all mixed in with the instructions. If you want to update a badge format, you're scrolling through 150+ lines. If someone wants to customize just the template, they have to edit the whole file.

This is the problem that skill folders solve. By breaking the file into separate pieces:

- **Maintainability**: easier to find and update a specific piece (like a badge format) without scrolling through everything
- **Readability**: the SKILL.md stays focused on the steps, not buried in data
- **Customizability**: someone can swap out just the badges or the template without touching the instructions
- **Scripts save tokens**: a scan script runs without loading into the agent's context at all
- **Selective loading**: some files only need to load for certain projects (like diagram templates for complex projects)

Let's refactor.

![The Refactor](assets/the-refactor.png)


