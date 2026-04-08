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
git clone https://github.com/workos/aie-europe-skills-at-scale.git
cd aie-europe-skills-at-scale
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

**Goal:** Build up a bare-bones skill into a real repo health assessment with scripts, constraints, and tone.

**Time:** ~20 minutes

**Techniques you'll learn:** Constraints > instructions, structure, scripts (inline `!` shell calls)

### What you're starting with

Open `.claude/skills/repo-roast/SKILL.md` in your editor. It's intentionally thin — one script, one constraint, a vague description. Run it now and notice how generic the output is. You're about to fix that.

### Your job

**1. Write a real description.** The starter says "Analyzes repository health." — too vague. The description is how the agent decides whether to use your skill. Include:
- What it does: "...by running git and file-system scripts to find stale TODOs, churn hotspots, large files, and documentation gaps"
- When to trigger: "Use when the user asks for a repo assessment, health check, code quality review, or tech debt audit"
- When NOT to trigger: "Do NOT use for simple file lookups, git history questions, or code review of specific changes"

**Test it:** Ask your agent "When would you use the repo-roast skill?" If it can't articulate when, the description needs work.

**2. Add scripts.** The starter has one script (TODO grep). Add 2-3 more to the `## Context` section — each gives the agent real evidence to reason over:
```markdown
Hotspot files: !`git log --pretty=format: --name-only --since="6 months ago" | grep -v '^$' | sort | uniq -c | sort -rn | head -10`
Largest files: !`git ls-files | xargs wc -l 2>/dev/null | sort -rn | head -10`
README freshness: !`git log -1 --format="%ar" -- README.md`
Recent contributors: !`git log --format="%an" --since="3 months ago" | sort | uniq -c | sort -rn | head -5`
```

**3. Add constraints.** The starter has one. Add 2-3 that reflect YOUR judgment:
- "Every finding must include: what's wrong, evidence, severity, recommendation"
- "Never recommend rewrite from scratch"
- "Maximum 10 findings, ordered by severity"
- "Only make findings backed by observed repo evidence"
- Or your own: "Never flag files under 500 lines as too large"

**4. Set your tone.** The starter is neutral. Make it yours:
- Blunt roast? Add: "Be direct and slightly sarcastic. Name names (files, not people)."
- Professional assessment? Add: "Use formal language suitable for a team lead report."
- Friendly orientation? Add: "Be welcoming. Frame issues as opportunities, not failures."

### Run it

Save the file, then run `/repo-roast` on your target repo. Compare the output to what you saw in setup — your constraints and tone should visibly change the result.

### If you're behind

```bash
./setup.sh --checkpoint 1
```

---

## Step 2: Make It Smarter

**Goal:** Add phased workflow and per-finding confidence checks. Re-run and compare.

**Time:** ~22 minutes

**Techniques you'll learn:** Progressive disclosure (phases), confidence scoring (self-assessment)

### Add phases

Right now the skill one-shots everything. Add a `## Workflow` section after Constraints:

```markdown
## Workflow
Work through these phases in order. Do not skip phases.
1. Run all context scripts. Gather raw data. Summarize counts and hotspots.
2. Categorize findings by type (complexity, coverage, dependencies, documentation, churn). Score severity. Run self-assessment. Drop or flag weak findings.
3. Build prioritized recommendations. Run constraints checklist. Present final assessment.
```

**What changes:** Instead of dumping everything at once, the skill works through distinct stages — gather, assess, recommend. Each phase builds on the previous one. Combined with self-assessment, weak findings get filtered before reaching the final report.

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
./setup.sh --checkpoint 2
```

---

## Step 3: Skills Beyond the Editor

**Time:** ~15 minutes (hands-on + presenter-led)

### Level up your scripts (hands-on, ~5 min)

Pick one advanced script and add it to your `## Context` section. Re-run and see how the new signal changes the roast:

- **Test-to-source ratio:** `!``echo "test files:"; git ls-files | grep -ciE '(test|spec)'; echo "total files:"; git ls-files | wc -l``
- **Commit frequency:** `!``git log --oneline --since="6 months ago" | wc -l``
- **Dependency lockfile:** `!``found=$(ls -1 package-lock.json pnpm-lock.yaml yarn.lock bun.lockb Gemfile.lock go.sum Cargo.lock 2>/dev/null); echo "${found:-none found}"``

### Presenter-led demos

1. **Same skill, different audiences.** The same Repo Roast findings reframed for a developer (blunt roast), an engineering manager (business impact), and a new teammate (welcoming orientation). Same data, different delivery — all from one skill.

2. **Portability.** The same skill file works in Claude Code, Codex, and Cursor. In Claude Desktop (no shell access), constraints and structure still shape the output even without scripts.

3. **Measurement matters.** When skills become load-bearing, vibes aren't enough. A skill that looks helpful can make output worse. Even lightweight measurement (before/after on three test cases) beats pure intuition.

---

## Close: Share & Install

### Share your skill

```bash
./share.sh --name "Your Name"
```

This sends your skill to the presenter. We'll pull a few up on the projector — compare with your neighbor. What constraints did you add? What's different?

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

To see the fully evolved version with audience detection, scoring rubric, and example findings:
```bash
./setup.sh --checkpoint 3
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
