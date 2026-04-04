# Skills at Scale — Workshop Guide

Build a portable AI skill from scratch, test it on a real repo, and leave with a reusable tool.

## What You'll Build

A **Repo Roast** skill — a markdown file that teaches any coding agent to analyze repository health by running real scripts, applying constraints, and scoring its own confidence. The same skill works in Claude Code, Codex, Cursor, and other agent environments.

## Prerequisites

- A coding agent with local shell access: **Claude Code**, **Codex**, or **Cursor**
- A local git repo you're comfortable analyzing — or use any public repo
- macOS, Linux, or WSL recommended

> If you only have Claude.ai / Desktop, you can follow the concepts, but the hands-on script-driven build is designed for tools with local shell access.

---

## Setup

### 1. Clone the workshop repo

```bash
git clone https://github.com/nicknisi/aie-europe.git
cd aie-europe
```

### 2. Verify the skill loads

**Claude Code:**
```bash
claude
```
Then ask: "What skills do you have available?" — you should see `repo-roast` in the list.

**Codex:** Run the setup script to symlink the skill:
```bash
./setup.sh
```

### 3. Pick a target repo

You'll run the skill against a real repo. Options:
- **Your own repo** — any git repo with some history
- **This workshop repo** — works but is small
- **A popular open source project** — clone one you're curious about

### 4. Test it

Navigate to your target repo and run:
```
/repo-roast
```
or ask: "Roast this repo" / "Give me a repo health check"

You should see output with findings, evidence, and a health score. If you do, you're ready.

---

## Step 1: Build the Foundation

**Goal:** Customize the starter skill with your own constraints, tone, and scripts.

**Time:** ~20 minutes

**Techniques you'll learn:** Constraints > instructions, structure, scripts (inline `!` shell calls)

### What you're starting with

Open `.claude/skills/repo-roast/SKILL.md` in your editor. You'll see:

- **Frontmatter** (`name`, `description`) — how the agent discovers and decides to use the skill
- **Context scripts** — shell commands prefixed with `!` that gather real data from the repo
- **Constraints** — rules the agent must follow (what it must never do)
- **Structure** — the output format

### Your job

**Customize the description.** The description is how the agent decides whether to use your skill. A vague description means it never fires. Test it: ask your agent "When would you use the repo-roast skill?" If it can't articulate when, the description needs work.

**Add 1-2 constraints.** What do YOU never want to see in a health report? Examples:
- "Never mention test coverage percentages without checking for actual test files"
- "Never flag files under 500 lines as too large"
- "Always include the git blame author for the oldest TODO"

**Set your tone.** The starter is neutral. Make it yours:
- Blunt roast? Add: "Be direct and slightly sarcastic. Name names (files, not people)."
- Professional assessment? Add: "Use formal language suitable for a team lead report."
- Friendly orientation? Add: "Be welcoming. Frame issues as opportunities, not failures."

**Optional: add a script.** If you want to gather more data, add a line to the Context section:
```markdown
Branch count: !`git branch -a | wc -l`
```

### Run it

Save the file, then run `/repo-roast` on your target repo. Compare the output to what you saw in setup — your constraints and tone should visibly change the result.

### If you're behind

```bash
cp checkpoints/1-starter.md .claude/skills/repo-roast/SKILL.md
```

---

## Step 2: Make It Smarter

**Goal:** Add phased workflow and per-finding confidence checks. Re-run and compare.

**Time:** ~25 minutes

**Techniques you'll learn:** Progressive disclosure (phases), confidence scoring (self-assessment)

### Add phases

Right now the skill one-shots everything. Add a `## Workflow` section after Constraints:

```markdown
## Workflow
Phase 1: Run all context scripts. Summarize raw findings. Present counts and hotspots. Stop.
Phase 2: Categorize findings by type (complexity, coverage, dependencies, documentation, churn). Score severity. Present structured report. Stop.
Phase 3: Based on feedback, build prioritized recommendations. Run constraints checklist. Present final assessment.
Do not skip phases. Each phase requires confirmation before proceeding.
```

**What changes:** Instead of dumping everything at once, the skill now stops after presenting raw data. You steer it — "Focus on the large files" or "Skip the TODOs, they're intentional" — before it builds recommendations.

### Add confidence scoring

The model is good at reasoning but bad at knowing when it's guessing. Add a `## Self-Assessment` section:

```markdown
## Self-Assessment
Rate each finding before presenting:
- Evidence quality (1-10): Is this backed by script output or inference?
- Severity accuracy (1-10): Is this actually a problem, or could it be intentional?
- Actionability (1-10): Can someone act on this recommendation today?

If any finding scores below 6 on evidence quality, drop it or flag as "needs investigation."
Show the scores for each finding so the reader can see your reasoning.
```

**What changes:** The model catches its own drift. Low-evidence findings get dropped automatically. Speculative noise disappears.

### Run it again

Save and run `/repo-roast` on the same repo. Compare:
- Do the phases make the interaction more collaborative?
- Did confidence scoring drop any findings that were in the first run?
- Is the output quality visibly better?

### If you're behind

```bash
cp checkpoints/2-with-phases.md .claude/skills/repo-roast/SKILL.md
```

---

## Step 3: Why This Scales (presenter-led)

This section is presenter-led — watch the demos, no new hands-on work.

**What you'll see:**

1. **Same skill, different audiences.** The same Repo Roast findings reframed for a developer (blunt roast), an engineering manager (business impact), and a new teammate (welcoming orientation). Same data, different delivery — all from one skill.

2. **Composition in production.** The WorkOS CLI uses the same patterns — constraints, scripts, phased workflow, confidence scoring — to power 15 framework integrations. Each framework is a skill composed with others, wired into an agent via the Claude Agent SDK.

3. **Measurement matters.** When skills become load-bearing, vibes aren't enough. A skill that looks helpful can make output worse. Even lightweight measurement (before/after on three test cases) beats pure intuition.

---

## Close: Share & Install

### Compare outputs

If you're comfortable, share your roast output with the room. Everyone ran the same skill structure on different repos — the variety is the fun part.

### Install permanently

Your skill already lives in this repo. To make it available globally:

**Claude Code:**
```bash
cp -r .claude/skills/repo-roast ~/.claude/skills/repo-roast
```

**Codex:**
```bash
cp -r .claude/skills/repo-roast ~/.agents/skills/repo-roast
```

Now `/repo-roast` works in any project, not just this repo.

### The complete skill

To see the fully evolved version with audience detection, scoring rubric, and internal phased reasoning:
```bash
cp checkpoints/3-complete.md .claude/skills/repo-roast/SKILL.md
```

### What comes next

You built one skill well. The pattern works for any recurring task:
1. Gather context (scripts)
2. Add constraints (what must never happen)
3. Structure the output
4. Phase the workflow
5. Define what "good" means (confidence scoring)

**Accelerators:**
- **skill-creator** — Claude's built-in tool can generate new skills from natural language descriptions. Now that you know the techniques, it scaffolds the next one in minutes.
- **The [handbook](handbook.md)** — full technique library with 12 techniques, skill categories, pattern archetypes, and companion reading.
- **Transcript reflection** — review past sessions to see which findings were useful and which were ignored. The conversation is the most honest record of how the work went.
