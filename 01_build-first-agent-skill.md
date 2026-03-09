# Build Your First Agent Skill

Learn what agent skills are, how they work, and build one from scratch using your AI coding agent. This tutorial covers **GitHub Copilot** and **Claude Code**, but skills work across many agents.

**Success check:** You can say "Good morning" in a new chat and the agent responds using your `good-morning` skill.

### What you'll build in this tutorial

We're going to build a simple `good-morning` skill that teaches your agent to greet you in a personalized way. It's a quick win that shows you how skills work before we tackle something bigger.

### What you'll build in this series

In later tutorials, you'll build a **README Wizard** skill that takes a basic README like this:

```
# My Project
Some setup instructions
npm install
npm run dev
```

And transforms it into something like this:

![Before vs After](assets/before-vs-after.png)

A polished README with a hero section, badges with live subscriber and member counts, quick start, project structure, Mermaid diagrams, documentation table, contributor avatars, social links, and a star history chart.

But first, let's start simple.

---

## Table of Contents

- [What Are Skills?](#what-are-skills)
- [Build Your First Skill](#build-your-first-skill)
- [How Skills Get Loaded](#how-skills-get-loaded)
- [Where Skills Live](#where-skills-live)
- [The Skills Ecosystem](#the-skills-ecosystem)
- [Next Steps](#next-steps)

---

## What Are Skills?

[![What Are Agent Skills?](https://img.youtube.com/vi/2REiUlciObk/maxresdefault.jpg)](https://youtu.be/2REiUlciObk?si=im87wwgj8vcN91br)

### The problem

AI agents are smart. But they're generic. Your agent is trained on a ton of general knowledge, but it doesn't have your specific domain knowledge. It doesn't know your preferences, your team's conventions, or how you personally want things done.

When we learn a new skill — playing basketball, riding a bike — we're adding knowledge we didn't have before. Skills work the same way for your agent. You give it the domain knowledge it's missing, personalized to how you want things done.

### What is a skill?

A skill is a reusable set of instructions that teaches an AI agent how to do a specific task well. Think of it like a recipe card you hand to a talented chef. The chef knows how to cook, but they don't know your family's secret sauce. The recipe card tells them exactly what to do.

- **Without a skill** → the agent produces generic output
- **With a skill** → the agent follows your instructions and produces exactly what you want, every time

At its simplest, a skill is just **one file**: a `SKILL.md` with a name, description, and instructions. That's it. You can add extras like scripts, references, assets, and evals — but you don't have to. We'll cover those in [Tutorial 2](02_skill-deep-dive.md). All you need right now is the `SKILL.md` file.

Let's build one.

## Build Your First Skill

Open VS Code in your project directory. We're going to create a `good-morning` skill step by step.

**Step 1: Create the skill folder and file**

We need a folder for our skill with a `SKILL.md` file inside it. The `.agents/skills/` path is the cross-agent convention that works with Copilot, Goose, and others. Claude Code requires `.claude/skills/` instead.

Copy this prompt:

```
Create a new skill folder at .agents/skills/good-morning/ with an empty SKILL.md file inside it.
```

You should end up with:

```
your-project/
└── .agents/
    └── skills/
        └── good-morning/
            └── SKILL.md
```

> **Claude Code users:** Use `.claude/skills/good-morning/` instead.

**Step 2: Write the skill**

Now let's fill in the SKILL.md with a complete skill. The file has two parts:

1. **YAML frontmatter** — the metadata at the top between `---` markers. The `name` must match the folder name exactly. The `description` tells the agent when to use this skill.

2. **Markdown body** — the instructions the agent follows when the skill triggers.

Copy this prompt:

```
Replace the contents of .agents/skills/good-morning/SKILL.md with a skill that responds to "good morning" greetings. The frontmatter should have name: good-morning and a description that says it responds to good morning with a cheerful greeting.

The body should tell the agent to:
- Greet the user by name (use "Debbie" as the example)
- Ask if they have done any sport today
- Include a funny joke about sports

Include an example exchange showing what the response should look like.
```

The agent creates a complete `SKILL.md` with frontmatter and instructions. Open it and take a look — it should be around 15-20 lines.

**Important things to know:**

- **The name must match the folder name.** If the folder is called `good-morning`, the name must be `good-morning`. If they don't match, the skill will not load.

- **The name and description are always in context.** Every time you're working in this project, the agent sees the name and description so it knows what skills are available.

- **The body only loads when triggered.** Everything below the frontmatter only gets added to context when the skill is called, not all the time.

Make it as personal as you like — put your own name in there, change the topic from sports to whatever you want.

### Test it

Start a **new chat session** (skills are discovered at session start) and test the skill.

Copy this prompt:

```
Good morning
```

The agent finds the skill, reads the `SKILL.md` file, and responds with a personalized greeting, a question about sports, and a joke.

Skills work across agents. The same `SKILL.md` file works in Copilot, Claude Code, Cursor, and others. Each agent discovers the skill, reads the instructions, and follows them.

### Troubleshooting (if it doesn't trigger)

- Start a **new chat session** after creating or moving skills
- Confirm the folder name matches the `name:` in frontmatter exactly
- Double-check the path for your agent (`.agents/skills/` vs `.claude/skills/`)

That's a skill in action. Now imagine instead of "good morning", the instructions told the agent how to generate a polished README, write commit messages in your team's format, or review code against your standards. Same idea, bigger impact.

## How Skills Get Loaded

Skills are designed to be efficient with context windows. They use a three-level loading system. The agent only loads what it needs, when it needs it.

![How Skills Get Loaded](assets/how-skills-get-loaded.png)

**Level 1** is always in the agent's context. It's just the name and description (~100 words). This is how the agent decides whether to use the skill. If someone says "improve my README", the agent scans its available skills and picks the one whose description matches.

**Level 2** loads when the skill triggers. The full SKILL.md body with all the instructions, steps, and examples. This is ideally under 500 lines.

**Level 3** loads on demand. Scripts, references, and assets that the agent pulls in only when it needs them. Scripts can even run without being loaded into context at all, saving tokens. And some resources might not load at all for certain projects. For example, a diagram template file only needs to be read if the project is complex enough to need an architecture diagram. Simple projects skip it entirely.

This matters because context windows are limited. A well-designed skill is lean at the top and detailed at the bottom.

## Where Skills Live

Skills can be installed at two levels:

- **Project-level**: in your project directory, available only when you're in that directory
- **Personal**: in your home directory, available from anywhere

Each agent checks slightly different locations:

**Quick pick:**
- Use `.agents/skills/` for GitHub Copilot in VS Code
- Use `.claude/skills/` for Claude Code

**GitHub Copilot (VS Code)**:
```
# Project-level (any of these work)
your-project/.github/skills/
your-project/.claude/skills/
your-project/.agents/skills/

# Personal (works from any directory)
~/.copilot/skills/
~/.claude/skills/
~/.agents/skills/
```

**Claude Code**:
```
# Project-level
your-project/.claude/skills/

# Personal (works from any directory)
~/.claude/skills/
```

The `.agents/skills/` path is part of the [Agent Skills open standard](https://agentskills.io) which is a cross-tool standard, but Claude Code uses its own `.claude/` directory structure, not `.agents/`.

## The Skills Ecosystem

There's a whole directory of skills at [skills.sh](https://skills.sh) where you can browse and discover skills built by the community.

To install a skill, use the skills CLI:

```bash
npx skills add anthropics/skills --skill skill-creator
```

This installs the `skill-creator` skill from Anthropic. A skill that helps you create other skills. One command and it's ready to use.

You can see what you have installed:

```bash
npx skills list
```

And search for skills:

```bash
npx skills find
```

Skills work across multiple AI agents — Copilot, Claude Code, Cursor, Goose, and many more. The skills CLI handles installing to the right location for each agent.

And that's just the beginning. The skills ecosystem is growing fast with new skills being added all the time. You can build your own skill and share it with the world, or just explore what's out there and install the ones that look useful.

## Next Steps

You've built your first skill. Now let's look inside a more complex one to understand the full folder structure.

**Next:** [Tutorial 2: Anatomy of a Skill →](02_skill-deep-dive.md)
