---
theme: default
title: "Skills at Scale"
info: |
  ## Skills at Scale
  Portable skills for Claude Code, Codex, Cursor, and your own agents.

  An 80-minute hands-on workshop at AIE Europe 2026.
author: Nick Nisi & Zack Proser
keywords: skills,agents,claude,ai
highlighter: shiki
drawings:
  persist: false
transition: slide-left
mdc: true
colorSchema: light
fonts:
  sans: Inter
  mono: IBM Plex Mono
  provider: google
themeConfig:
  primary: '#6363F1'
duration: 80min
timer: countdown
---

# Skills at Scale

Write once, run in Claude Code, Codex, Cursor, and your own agents

<div class="abs-br m-6 flex gap-2 text-sm opacity-50">
  <span>Nick Nisi & Zack Proser</span>
  <span>·</span>
  <span>AIE Europe 2026</span>
</div>

<!--
Presenter A opens. Conversational, not monologue.

"Welcome. 80 minutes. You're going to build one working skill and leave with it installed in your AI tools."

Presenter B reacts, sharpens — "And the techniques you learn transfer to any task, not just the one we build today."

TIMING: Open section is 5 minutes total, hard stop at 4:30.
-->

---

# Who we are

<div class="grid grid-cols-2 gap-12">
<div class="flex flex-col items-center text-center">

<img src="/nick-nisi.webp" class="w-36 h-36 rounded-full object-cover mb-4" />

### Nick Nisi

**DX Engineer · WorkOS**

- Former co-host, JS Party
-
-

</div>
<div class="flex flex-col items-center text-center">

<img src="/zack-proser.webp" class="w-36 h-36 rounded-full object-cover mb-4" />

### Zack Proser

**DX Engineer · WorkOS**

- <!-- TODO: 2-3 bullet points -->
-
-

</div>
</div>

<!--
Keep this to 30-60 seconds. Don't read the bullets — the slide establishes credibility, the conversation establishes rapport.

"I'm Nick, this is Zack. We're DX engineers at WorkOS. We build the tools and skills we're about to teach you."
-->

---

# Built by WorkOS

<div class="flex items-center gap-8">
<div class="flex-1">

WorkOS builds developer infrastructure for enterprise features: SSO, SCIM, RBAC, FGA, and auth.

The skills and agent patterns in this workshop were developed while building the **WorkOS CLI** and its 15-framework installer, powered by the Claude Agent SDK.

Everything we teach today ships in production.

</div>
</div>

<!--
30 seconds max. This is a sponsor/context slide, not a sales pitch.

"WorkOS is where we work. The patterns we're teaching come from building real developer tools — the CLI, the skills plugin, the agent harness. This isn't theoretical."
-->

---

# You've done this before

- Open your AI tool
- Type the same instructions you typed yesterday
- Get roughly the same output
- Tweak it the same way you tweaked it last time
- Repeat tomorrow

<!--
"Every developer using AI tools has this problem. You prompt the same way, for the same tasks, over and over."

"You've explained your coding style 50 times. You've described your project structure 50 times."

Keep it fast — 60 seconds max. This is setup, not the hook.
-->

---

# What is a skill?

A **skill** is a markdown file that teaches an AI tool how to do a specific job. It has structure: a description for routing, scripts for gathering evidence, and constraints for guardrails.

| | |
|---|---|
| **Skill** | A reusable `.md` file you author and share |
| **Tool** | The agent that loads and runs it (Claude Code, Cursor, Codex) |
| **Scripts** | Shell commands that gather real data from the environment |

**When to write one:** You've repeated the same instructions across sessions, or you want the LLM to follow a specific process every time.

**When not to:** The LLM already does it well enough, or the task changes every time. Not everything needs to be a skill. But when a task is repeatable, the skill makes it reliable.

<!--
This is the core definition. Ground the audience before showing examples.

"A skill is just a file. The tool runs it. Scripts give it real data."

"You don't need a skill for everything. But when you find yourself re-explaining the same process — how to review code, how to check repo health, how to onboard — that's when a skill pays off."

"The key insight: the LLM is already good at many things. Skills are for the tasks where you need consistency, evidence, and guardrails."

Don't over-explain portability yet — that's "Why this scales."
-->

---

# What a bad skill looks like

```markdown
# Repo Health Check
Look at this repository and tell me how it's doing.
Be helpful and thorough.
```

<v-click>

> "Your codebase looks pretty good overall. Consider adding more tests and updating documentation."

</v-click>

<!--
"This is what most people's 'skills' look like. Vague instructions, no guardrails."

"Run this on any repo, you get the same generic advice. It's useless."

Pause after the output. Let the room react to how weak it is.
-->

---

# What a good skill looks like

```markdown {maxHeight:'200px'}
---
name: repo-roast
description: Analyzes repository health by running git
  and file-system scripts. Use for repo assessments
  or code quality reviews.
---
# Repo Roast
## Context
Stale TODOs: !`grep -rn "TODO\|FIXME" . --include="*.*" | head -20`
Largest files: !`git ls-files | xargs wc -l 2>/dev/null
  | sort -rn | head -10`
## Constraints
- Never be vague — cite specific files and counts
- Maximum 10 findings, ordered by severity
```

<v-click>

> Health score: 4/10. `handler.ts` is 2,847 lines handling auth, routing, AND database queries. 14 TODO comments, oldest from March 2023. README references `yarn start` but lockfile is `pnpm-lock.yaml`.

</v-click>

<!--
Show BOTH the skill and the output. The contrast with the bad skill is the point.

"Description for routing. Scripts for evidence. Constraints for guardrails. And the output is completely different."

"Same repo. Same question. The difference is the skill."

TIMING: Should hit this slide by ~3:00.
-->

---

# Today's plan

**You're leaving with one reusable skill for a real task you do every week.**

| | Time | Mode | What happens |
|---|---:|---|---|
| **Build the foundation** | 20 min | Build | Constraints, scripts, structure. A working skill. |
| **Make it smarter** | 25 min | Build | Phases + confidence. A smarter skill. |
| **Why this scales** | 20 min | Watch | Audience adaptation, composition, measurement |
| **Close** | 10 min | Build | Compare, install, share |

We teach the guitar, not the song. The techniques transfer to any domain.

<!--
"Three acts, one skill — Repo Roast. Each act layers techniques. The techniques work for any skill, not just this one."

"We all build the same skill so debugging from stage works and the recording has a clear through-line."

TIMING: Finish the Open by 5:00. Hard stop. Transition to setup + Build the Foundation.
-->

---

# What we're building: Repo Roast

A skill that audits any git repo's health using real data: stale TODOs, churn hotspots, large files, documentation gaps.

**We all build the same skill** so we can debug from stage and the recording has a clear through-line.

**But make it yours.** We provide baselines and checkpoints. You decide:
- What constraints matter for your codebase
- What tone fits your team (blunt roast? professional report?)
- What extra signals to gather

The techniques are the lesson. The domain is the vehicle. Experiment.

<!--
"We all build Repo Roast today. That's the vehicle for learning. But the point is the techniques — constraints, scripts, phases, confidence — and those work for any skill."

"We have checkpoints if you fall behind. But don't just copy them — customize. Add a constraint that matters to YOUR team. Change the tone. Add a script for something you actually care about."

"The skill you leave with should be yours, not ours."
-->

---

# Get set up

<div class="grid grid-cols-2 gap-8">
<div>

```bash
git clone https://github.com/workos/aie-europe.git
cd aie-europe
./setup.sh        # installs the starter skill
claude  # or codex, or cursor
```

Then: `Roast this repo`

</div>
<div class="flex items-center justify-center">

<img src="/qr-workshop-repo.svg" class="w-48 h-48" alt="QR code to clone repo" />

</div>
</div>

<!--
"Clone this repo. Run setup.sh — it copies the starter skill into the right directory for your tool. Start your agent. Ask it to roast the repo. If you see a health score, you're ready."

"setup.sh handles the install path differences between tools. You can also run it with --cleanup to remove the skill later."

Keep this to 90 seconds max. The QR code is for people who prefer scanning to typing.

If someone doesn't have Claude Code or Codex installed, they can still follow along conceptually.
-->

---

# How skills load

Every tool discovers skills differently, but the file is the same.

| Tool | Discovery path |
|---|---|
| **Claude Code** | `.claude/skills/repo-roast/SKILL.md` |
| **Codex** | `.agents/skills/repo-roast/SKILL.md` |
| **Cursor** | `.cursor/rules/repo-roast.md` |

The tool reads the **name** and **description** at startup. The full skill loads when invoked.

**The development loop (same in every tool):**

```
edit skill → save → invoke → see output → edit again
```

No restart. No reload. No version bump. This is the loop for the entire workshop.

<!--
"The skill file is identical across tools. Only the directory changes. That's what makes skills portable."

"Today we'll use Claude Code or Codex, but the skill you build works in Cursor too — just copy it to the right path."

"This loop — edit, save, run, observe, fix — is the entire workshop. Every hands-on block is this loop."

Keep to 60 seconds. The attendees need this mental model before they start editing.
-->

---
layout: section
---

# Build the Foundation

<div class="text-2xl opacity-70">20 minutes · hands-on</div>

<!--
"Now we build."

Presenter switch: Driver edits the live skill, Support translates into room instructions.

TIMING: Setup talk before attendees type = 6 min MAX. Hands-on + first run = ~14 min.
-->

---

# Lesson from production: instructions decay

We gave 20+ agents prose instructions. Context windows compressed. Agents forgot. They started skipping phases and fabricating evidence.

The fix wasn't better instructions. It was **mechanical constraints**.

<!--
Story time — 30-60 seconds. Punchy.

"From building Case — a multi-agent harness for 20+ repos. Early versions gave agents prose instructions. Context windows compressed, agents forgot, they started skipping phases and creating fake evidence."

"The fix wasn't better instructions. It was mechanical constraints — things agents can't ignore because they're structural, not advisory."

"That's the same principle behind a good skill."
-->

---

# From bad to good

````md magic-move
```markdown
# Repo Health Check
Look at this repository and tell me how it's doing.
Be helpful and thorough.
```
```markdown
---
name: repo-roast
description: Analyzes repository health by running git
  and file-system scripts. Use for repo assessments or
  code quality reviews. Do NOT use for simple file lookups.
---
# Repo Roast

## Context
Stale TODOs: !`grep -rn "TODO\|FIXME" . --include="*.*" | head -20`
Hotspot files: !`git log --pretty=format: --name-only | sort
  | uniq -c | sort -rn | head -10`
Largest files: !`git ls-files | xargs wc -l 2>/dev/null | head -10`
README freshness: !`git log -1 --format="%ar" -- README.md`

## Constraints
- Never be vague — cite specific files and counts
- Every finding: issue, evidence, severity, fix
- Never recommend "rewrite from scratch"
- Maximum 10 findings, ordered by severity

## Structure
1. One-line health verdict (with score)
2. Top findings (max 10) with evidence
3. One thing the repo does well
```
````

<!--
Walk through the transformation slowly. Four sections:

1. DESCRIPTION — "This is the routing rule. Claude sees 100+ skills at startup and picks based on description alone. 'Helps with repos' = never fires. This description tells Claude WHEN to use it AND when NOT to."

2. CONTEXT — "Scripts. The ! backtick syntax runs shell commands and injects the output. The skill gathers its own evidence."

3. CONSTRAINTS — "What it must never do. Not 'be thorough' — 'never be vague, cite files and counts.'"

4. STRUCTURE — "What the output looks like. A specific format, not 'be helpful.'"

Don't rush this slide. It's the centerpiece of "Build the Foundation."
-->

---

# The `!` backtick: evidence, not guesses

```markdown
Stale TODOs: !`grep -rn "TODO\|FIXME\|HACK" . --include="*.*"
  --exclude-dir=node_modules --exclude-dir=dist | head -20`
```

The skill runs the command and injects the output.

**Without scripts:** the model guesses about your code

**With scripts:** the model has actual file sizes, actual TODOs, actual churn data

This is what separates a skill from a prompt template.

<!--
"The skill gathers its own context from the real environment. It doesn't guess, it checks."

"A skill without scripts is just a prompt. A skill WITH scripts is a tool."

Don't turn this into a shell workshop. If someone asks about grep flags, say "you can swap commands later — the pattern is what matters."
-->

---

# Constraints > Instructions

**Don't tell the model what to do. Tell it what it must never do.**

| Instead of... | Write... |
|--------------|---------|
| "Be thorough" | "Maximum 10 findings, ordered by severity" |
| "Be specific" | "Never be vague — cite files and counts" |
| "Give good advice" | "Never recommend rewrite from scratch" |
| "Be helpful" | "Every finding needs: issue, evidence, severity, fix" |

Negative constraints close failure modes. Positive instructions leave them open.

> "The specificity is the skill."

<!--
"Models are better at avoiding known-bad patterns than discovering ideal patterns from scratch."

"'Never use absolute positioning' is more enforceable than 'use responsive layout.'"

Mention the railroading trap briefly: "Don't over-constrain either — tight on fragile operations, loose on creative work. If every instruction is a constraint, you've built a script, not a skill."
-->

---

# Descriptions are routing rules, not marketing copy

The name and description are the **only** things loaded at startup.

Claude picks which skill to activate from potentially 100+ based on description alone.

**Test it:** ask Claude *"When would you use the repo-roast skill?"*

If it can't articulate when to use it, the description needs work.
If it fires on things it shouldn't, add negative triggers.

<!--
Keep this beat to 2 minutes max.

"A vague description — 'helps with repos' — means the skill never fires. A good description includes what it does AND when to use it, plus negative triggers."

"Here's a 30-second debugging exercise: after you write the description, just ask the model when it would use it. It'll quote the description back and explain its reasoning."

TIMING: Should be ready to hand off to attendees by ~11:00.
-->

---

# Your turn: build your Repo Roast

<div class="text-lg">

Start with the **starter skill file**. Customize it, don't write from scratch.

**Three required edits:**
1. **Description**: adapt triggers to your context
2. **1-2 constraints**: what should it NEVER do?
3. **Tone**: blunt roast? Professional assessment? Your call.

**Optional:** add one extra script if you're ahead.

</div>

<div class="mt-4 text-sm opacity-60">

Behind? Catch up: `cp checkpoints/1-starter.md .claude/skills/repo-roast/SKILL.md`

</div>

<!--
HANDS-ON TIME. ~8-10 minutes.

Support presenter gives explicit checkpoint language:
- "Everyone should be in the starter skill file now."
- "Only change these three things first."
- "Don't add new scripts yet unless you're ahead."
- "If you're done early, add one extra script or tune your tone."

Driver walks the room. Most common issue: the ! backtick syntax.

If someone is behind: "Copy the checkpoint file and keep going. Run: cp checkpoints/1-starter.md .claude/skills/repo-roast/SKILL.md"

If someone is ahead: "Add one extra script or tune your tone for a specific audience." Do NOT open multiple extension paths.

Narrate what you see to fill dead air: "I see someone adding a constraint about test coverage — that's exactly the kind of thing that makes YOUR skill different from the generic one."
-->

---

# Run it

Type exactly:

```
Roast this repo
```

**What you should see change:**

| Bad skill | Your skill |
|-----------|-----------|
| "Your codebase looks pretty good overall..." | Specific files, line counts, dates |
| Generic advice anyone could give | Evidence from YOUR repo's git history |
| No structure | Score, findings, severity, recommendations |

<!--
This is the make-or-break moment. First successful roast = workshop has momentum.

If someone got a great result, show it from stage. If someone's skill broke, troubleshoot live — that's teaching too.

If a script fails: "If your script failed, leave it as-is and keep going. The skill should skip missing signals instead of guessing."

Repeat the through-line: "You now have a working skill. You're leaving with one reusable skill for a real task you do every week."

TIMING: "Build the Foundation" should wrap by ~25:00.
-->

---

# While you work

<div class="grid grid-cols-2 gap-8">
<div>

### You're doing

- Customize description and triggers
- Add 1-2 constraints
- Set your tone
- Run `/repo-roast` on your repo

</div>
<div>

### Let's talk about

- Why most viral "skills" are 4 lines with no constraints
- The railroading trap: when over-constraining kills adaptability
- What makes scripts fail (and what to do when they do)

</div>
</div>

<!--
This is the discussion slide for the recording. Advance to this AFTER the "Run it" instruction.

DISCUSSION GUIDE for presenters while attendees work:

1. "Why most public skills are 4 lines" — "Search Twitter for 'Claude skills' and you'll find threads with millions of views sharing a name, a one-liner, and nothing else. No constraints, no scripts, no phases. That's why we're here — to build the other thing."

2. "The railroading trap" — "Don't over-constrain either. If every line is a 'never do X,' you've built a script, not a skill. Tight on fragile operations (never recommend rewrite from scratch), loose on creative work (let it choose how to phrase findings)."

3. "What makes scripts fail" — "The ! backtick syntax runs in the repo's directory. If the repo doesn't have a README, the freshness script returns nothing. That's fine — the skill should handle missing data, not crash."

Walk the room between discussion points. Narrate what you see: "I see someone adding a constraint about test coverage — that's exactly the kind of thing that makes YOUR skill different from the generic one."

TIMING: This slide stays up for ~8-10 minutes during hands-on.
-->

---
layout: section
---

# Make It Smarter

<div class="text-2xl opacity-70">25 minutes · hands-on</div>

<!--
Transition: "You have a working skill. It's already better than 90% of what people share online. Now let's make it smart."

Repeat promise: "You're leaving with one reusable skill for a real task you do every week. Now let's make it better."
-->

---

# Lesson from production: LLMs make bad state machines

Agents skipped phases, retried excessively, invented their own workflows.

The fix: **structure outside, self-assessment inside.** That's what we're adding now.

<!--
Story time — 30-60 seconds.

"Another lesson from Case. Early pipeline versions let agents decide their own next steps. They skipped phases, retried excessively, made up their own workflows."

"The fix: deterministic flow control outside the model, structured self-assessment inside. That's what we're adding now — phases the model follows, and a self-check it runs before presenting."
-->

---

# Technique: Progressive Disclosure

Don't dump everything at once. Phase-gate with checkpoints.

```markdown
## Workflow
Phase 1: Run all context scripts. Summarize raw findings.
         Present counts and hotspots. Stop.
Phase 2: Categorize findings by type (complexity, coverage,
         dependencies, documentation, churn). Score severity.
         Present structured report. Stop.
Phase 3: Based on feedback, build prioritized recommendations.
         Run constraints checklist. Present final assessment.
Do not skip phases. Each phase requires confirmation
before proceeding.
```

<!--
"Without phases, the model one-shots everything. You get a wall of text. No way to steer."

"With phases, it stops after each one. You review Phase 1 — 'yeah, focus on the auth module' — and Phase 2 is targeted."

"The WorkOS CLI uses this same pattern: detect framework → install → configure → verify. Each step produces output the next step needs."

Anti-pattern: "When you split into multiple files later, keep references one level deep. SKILL.md → reference file is fine. SKILL.md → file → another file loses information."

TIMING: Explanation before attendees edit = 4 min MAX.
-->

---

# One-shot vs phased

<div class="grid grid-cols-2 gap-8">
<div>

### Without phases

One massive dump. Take it or leave it.

No way to steer. No way to focus.

*"Here are 10 findings about everything."*

</div>
<div>

### With phases

**Phase 1:** "Found 14 TODOs, 3 churn hotspots, one 2800-line file. Want me to focus anywhere?"

**You:** "Focus on the auth module."

**Phase 2:** Targeted analysis of exactly what matters.

</div>
</div>

<!--
"Phases turn the skill from a fire-and-forget dump into a conversation. That's the difference between a report and a collaboration."
-->

---

# Technique: Confidence Scoring

The skill grades its own work. What it can't back up, it drops.

```markdown
## Self-Assessment
Rate each finding:
- Evidence quality (1-10): Is this backed by data or inference?
- Severity accuracy (1-10): Is this actually a problem, or intentional?
- Actionability (1-10): Can someone act on this immediately?

If any finding scores below 6 on evidence quality,
drop it or flag as "needs investigation."
If overall confidence is below 7, state what additional
information would help.
```

<!--
"This is the simplest possible feedback loop. Zero infrastructure. The model grades itself and revises."

"Key insight: decompose confidence into meaningful dimensions, not just a single number. 'Confidence: 7/10' is useless. 'Evidence: 9, Severity: 5, Actionability: 8' tells you exactly what's weak."

"The Ideation plugin does a more sophisticated version: 5 dimensions, each 0-20, requiring 95 total points to advance. But even this simple version dramatically improves output."
-->

---

# Without vs with confidence

<div class="grid grid-cols-2 gap-8">
<div>

### Without

*"Your handler.ts file is too large and should be split up."*

Is it? Says who? Based on what?

</div>
<div>

### With

*"Finding: handler.ts (2,847 lines)*

| Dimension | Score |
|---|---|
| Evidence quality | 9/10 — line count from scripts |
| Severity | 7/10 — large but could be intentional |
| Actionability | 8/10 — split into route, auth, data |

</div>
</div>

Low-evidence findings get dropped automatically. No more speculative noise.

<!--
"The difference is trust. Without scoring, you're getting opinions. With scoring, the model tells you HOW SURE it is and WHY."

"The model catches its own drift. That's self-correction without infrastructure."
-->

---

# We didn't follow our own process

We wrote all four skill versions in one pass from planning docs. No testing.

First real run: **84 seconds, 60KB of noise.** Even the people teaching the loop skipped the loop.

<!--
Brief. 30 seconds max. This sets up the hands-on block.

"When we built the checkpoints for this workshop, we wrote all four skill versions without running any of them. The first test run took 84 seconds and returned 60KB of noise."

"Even the people teaching the iterative loop didn't follow it. The pull toward authoring-without-testing is strong. That's why the loop matters."

The full story is in the 'While you work' discussion slide — you can expand there. This slide is just the hook.
-->

---

# Your turn: add phases + confidence

<div class="text-lg">

Add two sections to your skill:

1. **Workflow**: 2-3 phases with stop points between each
2. **Self-Assessment**: dimensions that matter for YOUR domain

Then **run it again** on the same repo. Compare to your first output.

Behind? `cp checkpoints/2-with-phases.md .claude/skills/repo-roast/SKILL.md`

</div>

<!--
HANDS-ON TIME. ~10 minutes.

Explicit checkpoint language:
- "Add the Workflow section first. Two or three phases is enough."
- "Then add Self-Assessment below it."
- "When both are in, run the same prompt: 'Roast this repo.'"
- "Compare: does Phase 1 now give you a triage before committing?"

Most common issue: people make phases too granular. Three phases is plenty.

If behind: "Copy the checkpoint: cp checkpoints/2-with-phases.md .claude/skills/repo-roast/SKILL.md"

Walk the room. Narrate: "Notice how Phase 1 is just a triage now — you get to decide where to go deeper before committing."

Side quest opportunity: tell the "we didn't follow our own process" meta-lesson story here. See workshop.md.

TIMING: "Make it smarter" should wrap by ~50:00.
-->

---

# While you work

<div class="grid grid-cols-2 gap-8">
<div>

### You're doing

- Add a `## Workflow` section with 2-3 phases
- Add a `## Self-Assessment` section
- Run `/repo-roast` again and compare

</div>
<div>

### Let's talk about

- Internal phases vs user-facing stops: when do pauses help?
- Why single-number confidence is useless
- "We built this skill without following our own process"

</div>
</div>

<!--
DISCUSSION GUIDE for presenters while attendees work:

1. "Internal vs user-facing phases" — "The complete skill (checkpoint 3) makes phases internal — the user gets one clean report. Checkpoint 2 has explicit stops. Both are valid. Stops are useful when the user needs to steer (which module to focus on). Internal phases are better when the skill should just do its job."

2. "Why single-number confidence is useless" — "Confidence: 7/10 tells you nothing. Evidence: 9, Severity: 5, Actionability: 8 tells you exactly what's weak. Decompose into dimensions that matter for your domain. The Ideation plugin uses 5 dimensions, each 0-20, requiring 95 total to advance."

3. META-LESSON — tell the full story here:
"When we built the checkpoints for this workshop, we wrote all four versions in one pass — from our planning docs, without running any of them. We authored a skill ABOUT evidence-based analysis without gathering evidence about whether the skill worked."

"The first time we ran it on a real repo, the grep took 84 seconds and returned 60KB of noise. The hotspot data was dominated by release bot commits. The confidence threshold was undefined. We had to rewrite every checkpoint."

"Even the people teaching the iterative loop defaulted to 'write it all up front.' That's why the loop matters."

TIMING: This slide stays up for ~10 minutes during hands-on.
-->

---

# Compare your outputs

**Before:** One-shot dump. Take it or leave it.

**After:** Phased, self-assessed, collaborative

Same skill. Same repo. The techniques made the difference.

| What to look for | |
|---|---|
| Did phases give you a triage before committing? | Steering > accepting |
| Did confidence scoring drop any findings? | Less noise, more signal |
| Is the output quality visibly better? | Evidence, not opinions |

<!--
Quick recap moment. Have a few people share if anyone got a strong before/after.

Transition: "You built the primitive. Here's why it matters beyond today."

Repeat the through-line: "The skill you just built IS the thing we're now showing at scale."
-->

---
layout: section
---

# Why This Scales

<div class="text-2xl opacity-70">20 minutes · presenter-led</div>

<!--
Transition: "You built a working, self-correcting skill. Now: three proof points for why this pattern matters at scale."

Fast-paced. No new hands-on. Three proofs: ~6 min each.

TIMING: "Why this scales" runs from ~50:00 to ~70:00.
-->

---

# A skill that made things worse

I built a skill I was proud of. It contained accurate information. It looked helpful.

Then I ran the eval, with and without the skill. **The skill made output worse.** Consistently. -12% to -20% delta.

Correct information, missing context. Measurement caught what vibes couldn't.

<!--
This one hits hardest. Slow down.

"I built a skill for directory sync and SSO. It looked helpful. It contained accurate information. I was proud of it."

"Then I ran the eval — same test cases, with and without the skill. The skill made the output WORSE. Consistently. -12% to -20% delta."

"The skill was teaching correct information but omitting critical context, and the model scored lower because of it."

Pause. Let it land.

"Even the eval itself can fail — 13 apparent regressions turned out to be scorer bugs. But the direction is clear: measure, don't vibe."
-->

---

# 1. Same skill, different audiences

The **star** of this section. Same findings, three deliveries.

```markdown
## Audience Detection
Determine the audience from the user's request:
- Developer → Roast mode. Blunt, specific, actionable.
- Engineering manager → Assessment mode. Quantify impact.
- New teammate → Orientation mode. Welcoming, not alarming.
If unclear, ask: "Who's this for?"
```

<!--
"This is the 'at scale' moment within a single skill. Same evidence, different delivery."

"Scale isn't just more tools. It's more audiences. The same evidence becomes useful differently depending on who needs it."

TIMING: ~6 min for this proof point.
-->

---

# Three audiences, one skill

<div class="grid grid-cols-3 gap-4 text-sm">
<div>

### Developer

*"5 worst hotspots. Start with `handler.ts` — split it into route handlers, auth middleware, and a data layer. Your oldest TODO is from March 2023."*

</div>
<div>

### Manager

*"The auth module was modified 47 times in 6 months by 8 contributors. That churn signals coordination cost. Recommend a focused cleanup sprint."*

</div>
<div>

### New teammate

*"Welcome. 3 areas healthy, 2 hot spots to be careful around. The auth module is being actively refactored — check with the team before touching it."*

</div>
</div>

<!--
Let the contrast speak. Don't over-explain.

"Same findings. Same evidence. Different framing. The skill adapts its delivery to who needs it."

"A developer needs the fix. A manager needs the business case. A new hire needs the map."

Brief Desktop note: "In coding tools, the skill gathers evidence via scripts. In Claude Desktop, it works from shared output or pasted context — a developer runs the roast, shares the report, a manager reframes it for planning. Same skill file, different execution context."
-->

---

# Try it: two audiences, same skill

<div class="text-lg">

Run your skill twice with different prompts:

```
Roast this repo — I'm the developer who owns it
```

```
Roast this repo — I'm a new teammate joining next week
```

Same skill. Same data. Watch the output change.

</div>

<div class="mt-4 text-sm opacity-60">

2-3 minutes. No edits needed, just different prompts.

</div>

<!--
MINI HANDS-ON. 2-3 minutes max. No skill edits required.

"You don't need to change anything in your skill file. Just change the prompt. Watch how the same evidence gets reframed."

This keeps momentum from the build sections. The audience gets to experience the adaptation instead of just hearing about it.

If someone's agent doesn't adapt tone: "That's because the skill doesn't have audience detection yet. The complete skill in checkpoint 3 has it. But even without it, the prompt shapes the output."

TIMING: Keep this tight. 2-3 minutes then move to composition.
-->

---

# 2. Composition: skills as building blocks

Your skill solves one problem. Skills composed together are a system.

**The WorkOS CLI:**
- Framework detection routes to the right installation skill
- 15 framework integrations, each a skill composed with others
- Validation-driven retry loops: typecheck fails → error fed back → agent self-corrects
- Wired into an agent via the Claude Agent SDK

That's production code, shipping today.

The same techniques you just learned power this system.

<!--
"The CLI's retry loop was born from an Ideation session. Rambling input → confidence gate → codebase exploration → spec → implementation."

"Progressive disclosure, confidence scoring, phased workflow — today's techniques — produced the production system we're showing now."

Keep this tight. Don't go deep into the CLI architecture. The message: the pattern you learned today IS the pattern that runs production systems.

TIMING: ~6 min for this proof point.
-->

---

# 3. Measurement matters

**Start here:** the skill-reviewer. Structured feedback, zero infrastructure.

**Graduate to this:** eval framework. Run WITH and WITHOUT the skill, measure the delta.

The WorkOS skills eval: 42 test cases, hard gates on regression, hallucination reduction targets.

**Even lightweight measurement beats pure intuition.**

Three test cases, before and after. That's enough to start.

<!--
Brief. Don't belabor eval methodology.

"Start with the skill-reviewer. It'll tell you if your description is vague, if your constraints are conflicting, if your structure is missing pieces."

"When skills become load-bearing — when you're composing them into agents or sharing them across a team — graduate to eval."

The negative-skill story is the hook; the framework is the proof. Keep the balance toward story.

TIMING: ~5 min. "Why this scales" should wrap by ~70:00.
-->

---
layout: section
---

# Close

<div class="text-2xl opacity-70">10 minutes</div>

<!--
"You built a real thing. Let's compare, install, and take it home."

Repeat: "You're leaving with one reusable skill for a real task you do every week."
-->

---

# Share your roast

<div class="text-xl">

**Pair up.** Turn to the person next to you.

1. Show your **health score** and **one favorite finding**
2. What **constraint or tone choice** made it yours?

<div class="mt-4 text-sm opacity-60">90 seconds. Then we'll pull a few highlights.</div>

</div>

<!--
PAIR SHARE. 90 seconds, then pull 2-3 highlights from stage.

"Roast the repo, not the people." Say this before they share.

This makes the close feel communal instead of administrative. The room hears variety — different tones, different constraints, different findings — on the same skill structure.

After 90 seconds: "Anyone get a finding that surprised them?" Pull 2-3 from the room. Keep it to 2-3 minutes total.
-->

---

# What you built

| Step | Technique | What changed |
|-----|-----------|-------------|
| **Build the foundation** | Constraints, scripts, structure | Generic noise → evidence-backed, focused output |
| **Make it smarter** | Phases, confidence scoring | One-shot dump → collaborative, self-correcting |
| **Why this scales** | Audience adaptation, composition, eval | One skill → adapted, composed, measured |

**The progression:** bad skill → better skill → smarter skill → scaled skill

<!--
Quick recap. Don't belabor — they lived it.

"Step 1 turned vague advice into forensic findings. Step 2 made it collaborative. Step 3 showed where it goes."
-->

---

# Install your skill

```bash
# Make it available globally (not just this repo)
cp -r .claude/skills/repo-roast ~/.claude/skills/repo-roast

# Or for Codex
cp -r .claude/skills/repo-roast ~/.agents/skills/repo-roast

# Or use the setup script
./setup.sh            # install
./setup.sh --cleanup  # remove
```

Same skill file. Same format. Just different directories per tool.

**Share it:** push to a repo, tell a teammate to pull it. Skills are just files.

<!--
Walk them through installation. Help anyone who's stuck.

"Roast the repo, not the people." Repeat this if anyone shares.

If install becomes fiddly: emphasize the artifact over the mechanics. "You have a working skill. The install path varies by tool, but the file is identical."
-->

---

# What comes next

**This week:** Run your skill on a real repo. See what works.

**Next week:** Every bad output is a new constraint. Add them.

**When ready:**
- **skill-creator**: Claude generates skills from natural language and runs an eval before install
- **Transcript reflection**: your past sessions are data. Mine them for which findings mattered.
- **Eval**: start with the skill-reviewer. Graduate to full measurement when skills become load-bearing.

**The [handbook](handbook.md)** has the full technique library: 12 techniques, 9 skill categories, 5 pattern archetypes.

<!--
"Today was about learning the pattern by building one skill well. The next step is adapting it to another recurring task."

"Gather context, add constraints, structure the output, phase the workflow, define what 'good' means. You know this now."

Transcript reflection note: "After running your skill a few times, review past sessions. Which findings were useful? Which were ignored? That's data for improving the skill."

If time: open for questions. If not: "Thank you. The handbook and starter templates are at the URL on the next slide."
-->

---
layout: center
class: text-center
---

# Skills at Scale

**You're leaving with one reusable skill for a real task you do every week.**

`github.com/workos/aie-europe`

<div class="mt-8 opacity-70">

GUIDE.md · Handbook · Checkpoints · setup.sh

</div>

<div class="abs-br m-6 text-sm opacity-50">
Nick Nisi & Zack Proser · AIE Europe 2026
</div>

<!--
Final slide. Leave the resources URL up while people finish installing.

Resources: technique library handbook, starter skill template, demo repo, blog posts (Case Statement, Writing My First Evals, Ideation, Feedback Loopable).

"You're leaving with one reusable skill for a real task you do every week. Thanks for building with us."
-->
