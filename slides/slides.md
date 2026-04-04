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

Core promise — say it now: "You're leaving with one reusable skill for a real task you do every week."

Presenter B reacts, sharpens — "And the techniques you learn transfer to any task, not just the one we build today."

TIMING: Open section is 5 minutes total, hard stop at 4:30.
-->

---
layout: section
---

# The Problem

<!--
Set the stage fast. Don't linger. The goal is to get to the bad/good comparison ASAP.
-->

---

# You've done this before

<v-clicks>

- Open your AI tool
- Type the same instructions you typed yesterday
- Get roughly the same output
- Tweak it the same way you tweaked it last time
- Repeat tomorrow

</v-clicks>

<!--
"Every developer using AI tools has this problem. You prompt the same way, for the same tasks, over and over."

"You've explained your coding style 50 times. You've described your project structure 50 times."

Keep it fast — 60 seconds max. This is setup, not the hook.
-->

---

# If you've explained it five times, it should be a **file**

<v-clicks>

A **skill** is a markdown file that teaches any AI tool how to do a specific job.

Three things to keep straight:

| | |
|---|---|
| **Skill** | The reusable artifact you author (a `.md` file) |
| **Tool** | The environment that loads and runs it (Claude Code, Cursor, Codex) |
| **Scripts** | How the skill gathers evidence from the real environment |

No SDK. No build step. No dependencies. Drop it in, it works.

</v-clicks>

<!--
This is the core definition. Say the three-part distinction now and repeat it throughout.

"A skill is just a file. The tool runs it. Scripts give it real data."

Don't over-explain portability yet — that's Act 3.
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

# What a good skill produces

> Health score: 4/10. Your largest file is `handler.ts` at 2,847 lines — it handles auth, routing, AND database queries. You have 14 TODO comments, the oldest from March 2023. Your README was last updated 8 months ago and references `yarn start` but your lockfile is `pnpm-lock.yaml`.

<v-click>

Same repo. Same question. Different skill.

**That's the gap this workshop fills.**

</v-click>

<!--
This is the laugh-then-whoa moment. Let the audience react.

"Same repo. Same question. The difference is the skill."

Transition: "Here's the plan for the next 75 minutes."

TIMING: Should hit this slide by ~3:00.
-->

---

# Today's plan

**You're leaving with one reusable skill for a real task you do every week.**

| | Time | Mode | What happens |
|---|---:|---|---|
| **Build the foundation** | 20 min | Build | Constraints, scripts, structure — a working skill |
| **Make it smarter** | 25 min | Build | Phases + confidence — a smarter skill |
| **Why this scales** | 20 min | Watch | Audience adaptation, composition, measurement |
| **Close** | 10 min | Build | Compare, install, share |

We teach the guitar, not the song. The techniques transfer to any domain.

<!--
"Three acts, one skill — Repo Roast. Each act layers techniques. The techniques work for any skill, not just this one."

"We all build the same skill so debugging from stage works and the recording has a clear through-line."

TIMING: Finish the Open by 5:00. Hard stop. Transition to Act 1.
-->

---

# Get set up

<div class="grid grid-cols-2 gap-8">
<div>

```bash
git clone https://github.com/nicknisi/aie-europe.git
cd aie-europe
claude  # or codex
```

Then: `/repo-roast` on any repo

</div>
<div class="flex items-center justify-center">

<img src="/qr-workshop-repo.svg" class="w-48 h-48" alt="QR code to clone repo" />

</div>
</div>

<!--
"Clone this repo. Start your agent. Run /repo-roast. If you see a health score, you're ready."

Keep this to 90 seconds max. The QR code is for people who prefer scanning to typing.

If someone doesn't have Claude Code or Codex installed, they can still follow along conceptually.
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
layout: quote
---

# "Instructions decay, enforcement persists."

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
description: Analyzes repository health by running git and
  file-system scripts to find stale TODOs, churn hotspots,
  large files, and documentation gaps. Use when the user asks
  for a repo assessment, health check, or code quality review.
  Do NOT use for simple file lookups or git history questions.
---

# Repo Roast

## Context
Stale TODOs: !`grep -rn "TODO\|FIXME\|HACK" . --include="*.*" | head -20`
Hotspot files: !`git log --pretty=format: --name-only
  --since="6 months ago" | sort | uniq -c | sort -rn | head -10`
Largest files: !`git ls-files | xargs wc -l 2>/dev/null
  | sort -rn | head -10`
README freshness: !`git log -1 --format="%ar" -- README.md`
Recent contributors: !`git log --format="%an"
  --since="3 months ago" | sort | uniq -c | sort -rn | head -5`

## Constraints
- Never be vague — cite specific files and counts as evidence
- Every finding: what's wrong, evidence, severity, recommendation
- Never recommend "rewrite from scratch"
- Maximum 10 findings, ordered by severity

## Structure
1. One-line health verdict (with overall score)
2. Top findings (max 10), each with: issue, evidence, severity, fix
3. One thing the repo does well
```
````

<!--
Walk through the transformation slowly. Four sections:

1. DESCRIPTION — "This is the routing rule. Claude sees 100+ skills at startup and picks based on description alone. 'Helps with repos' = never fires. This description tells Claude WHEN to use it AND when NOT to."

2. CONTEXT — "Scripts. The ! backtick syntax runs shell commands and injects the output. The skill gathers its own evidence."

3. CONSTRAINTS — "What it must never do. Not 'be thorough' — 'never be vague, cite files and counts.'"

4. STRUCTURE — "What the output looks like. A specific format, not 'be helpful.'"

Don't rush this slide. It's the centerpiece of Act 1.
-->

---

# The `!` backtick: evidence, not guesses

```markdown
Stale TODOs: !`grep -rn "TODO\|FIXME\|HACK" . --include="*.*" | head -20`
```

The skill runs the command and injects the output.

<v-clicks>

**Without scripts:** the model guesses about your code

**With scripts:** the model has actual file sizes, actual TODOs, actual churn data

This is what separates a skill from a prompt template.

</v-clicks>

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

<v-click>

Negative constraints close failure modes. Positive instructions leave them open.

> "The specificity is the skill."

</v-click>

<!--
"Models are better at avoiding known-bad patterns than discovering ideal patterns from scratch."

"'Never use absolute positioning' is more enforceable than 'use responsive layout.'"

Mention the railroading trap briefly: "Don't over-constrain either — tight on fragile operations, loose on creative work. If every instruction is a constraint, you've built a script, not a skill."
-->

---

# Descriptions are routing rules, not marketing copy

The name and description are the **only** things loaded at startup.

Claude picks which skill to activate from potentially 100+ based on description alone.

<v-click>

**Test it:** ask Claude *"When would you use the repo-roast skill?"*

If it can't articulate when to use it, the description needs work.
If it fires on things it shouldn't, add negative triggers.

</v-click>

<!--
Keep this beat to 2 minutes max.

"A vague description — 'helps with repos' — means the skill never fires. A good description includes what it does AND when to use it, plus negative triggers."

"Here's a 30-second debugging exercise: after you write the description, just ask the model when it would use it. It'll quote the description back and explain its reasoning."

TIMING: Should be ready to hand off to attendees by ~11:00.
-->

---

# Your turn: build your Repo Roast

<div class="text-lg">

Start with the **starter skill file** — customize, don't write from scratch.

**Three required edits:**
1. **Description** — adapt triggers to your context
2. **1-2 constraints** — what should it NEVER do?
3. **Tone** — blunt roast? Professional assessment? Your call.

**Optional:** add one extra script if you're ahead.

</div>

<div class="mt-4 text-sm opacity-60">

Don't have a repo? Use the demo repo: `[URL TBD]`

</div>

<!--
HANDS-ON TIME. ~8-10 minutes.

Support presenter gives explicit checkpoint language:
- "Everyone should be in the starter skill file now."
- "Only change these three things first."
- "Don't add new scripts yet unless you're ahead."
- "If you're done early, add one extra script or tune your tone."

Driver walks the room. Most common issue: the ! backtick syntax.

If someone is behind: "Stop where you are and use the starter content for the rest. The goal is a successful run, not perfect customization."

If someone is ahead: "Add one extra script or tune your tone for a specific audience." Do NOT open multiple extension paths.

Narrate what you see to fill dead air: "I see someone adding a constraint about test coverage — that's exactly the kind of thing that makes YOUR skill different from the generic one."
-->

---

# Run it

<div class="text-2xl">

Type exactly:

```
Roast this repo
```

Compare: what did the bad skill say vs yours?

</div>

<!--
This is the make-or-break moment. First successful roast = workshop has momentum.

If someone got a great result, show it from stage. If someone's skill broke, troubleshoot live — that's teaching too.

If a script fails: "If your script failed, leave it as-is and keep going. The skill should skip missing signals instead of guessing."

Repeat the through-line: "You now have a working skill. You're leaving with one reusable skill for a real task you do every week."

TIMING: Act 1 should wrap by ~25:00.
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
layout: quote
---

# "LLMs are good at reasoning about code. They're bad at being state machines."

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

The skill grades its own work — and drops what it can't back up.

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

<v-click>

Low-evidence findings get dropped automatically. No more speculative noise.

</v-click>

<!--
"The difference is trust. Without scoring, you're getting opinions. With scoring, the model tells you HOW SURE it is and WHY."

"The model catches its own drift. That's self-correction without infrastructure."
-->

---

# Your turn: add phases + confidence

<div class="text-lg">

Add two sections to your skill:

1. **Workflow** — 2-3 phases with stop points between each
2. **Self-Assessment** — dimensions that matter for YOUR domain

Then **run it again** on the same repo. Compare to your Act 1 output.

</div>

<!--
HANDS-ON TIME. ~10 minutes.

Explicit checkpoint language:
- "Add the Workflow section first. Two or three phases is enough."
- "Then add Self-Assessment below it."
- "When both are in, run the same prompt: 'Roast this repo.'"
- "Compare: does Phase 1 now give you a triage before committing?"

Most common issue: people make phases too granular. Three phases is plenty.

If behind: "Use the exact workflow and self-assessment blocks from the slide. Customize later."

Walk the room. Narrate: "Notice how Phase 1 is just a triage now — you get to decide where to go deeper before committing."

TIMING: Act 2 should wrap by ~50:00.
-->

---

# Compare your outputs

<div class="text-xl">

**Act 1:** One-shot dump — take it or leave it

**Act 2:** Phased, self-assessed, collaborative

Same skill. Same repo. The techniques made the difference.

</div>

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

TIMING: Act 3 runs from ~50:00 to ~70:00.
-->

---
layout: quote
---

# "Trust isn't a feeling. It's a number."

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

The **star** of Act 3. Same findings, three deliveries.

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

# 2. Composition: skills as building blocks

Your skill solves one problem. Skills composed together are a system.

<v-clicks>

**The WorkOS CLI:**
- Framework detection routes to the right installation skill
- 15 framework integrations, each a skill composed with others
- Validation-driven retry loops: typecheck fails → error fed back → agent self-corrects
- Wired into an agent via the Claude Agent SDK

That's production code, shipping today.

The same techniques from Act 1 and Act 2 power this system.

</v-clicks>

<!--
"The CLI's retry loop was born from an Ideation session. Rambling input → confidence gate → codebase exploration → spec → implementation."

"Progressive disclosure, confidence scoring, phased workflow — today's techniques — produced the production system we're showing now."

Keep this tight. Don't go deep into the CLI architecture. The message: the pattern you learned today IS the pattern that runs production systems.

TIMING: ~6 min for this proof point.
-->

---

# 3. Measurement matters

<v-clicks>

**Start here:** the skill-reviewer — structured feedback, zero infrastructure

**Graduate to this:** eval framework — run WITH and WITHOUT the skill, measure the delta

The WorkOS skills eval: 42 test cases, hard gates on regression, hallucination reduction targets.

**Even lightweight measurement beats pure intuition.**

Three test cases, before and after. That's enough to start.

</v-clicks>

<!--
Brief. Don't belabor eval methodology.

"Start with the skill-reviewer. It'll tell you if your description is vague, if your constraints are conflicting, if your structure is missing pieces."

"When skills become load-bearing — when you're composing them into agents or sharing them across a team — graduate to eval."

The negative-skill story is the hook; the framework is the proof. Keep the balance toward story.

TIMING: ~5 min. Act 3 should wrap by ~70:00.
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

# What you built

| Act | Technique | What changed |
|-----|-----------|-------------|
| **1** | Constraints, scripts, structure | Generic noise → evidence-backed, focused output |
| **2** | Phases, confidence scoring | One-shot dump → collaborative, self-correcting |
| **3** | Audience adaptation, composition, eval | One skill → adapted, composed, measured |

<v-click>

**The progression:** bad skill → better skill → smarter skill → scaled skill

</v-click>

<!--
Quick recap. Don't belabor — they lived it.

"Act 1 turned vague advice into forensic findings. Act 2 made it collaborative. Act 3 showed where it goes."
-->

---

# Install your skill

```bash
# Claude Code
~/.claude/skills/repo-roast/SKILL.md

# Cursor
.cursor/rules/repo-roast.mdc

# Codex
codex-config/skills/repo-roast/SKILL.md
```

Same skill. Different tools. No changes needed.

**Share it:** push to a repo, tell a teammate to pull it. Skills are just files.

<!--
Walk them through installation. Help anyone who's stuck.

"Roast the repo, not the people." Repeat this if anyone shares.

If install becomes fiddly: emphasize the artifact over the mechanics. "You have a working skill. The install path varies by tool, but the file is identical."
-->

---

# What comes next

<v-clicks>

**This week:** Run your skill on a real repo. See what works.

**Next week:** Every bad output is a new constraint. Add them.

**When ready:**
- **skill-creator** — Claude generates skills from natural language, runs an eval before install
- **Transcript reflection** — your past sessions are data. Mine them for which findings mattered.
- **Eval** — start with the skill-reviewer. Graduate to full measurement when skills become load-bearing.

</v-clicks>

<v-click>

**The [handbook](handbook.md)** has the full technique library — 12 techniques, 9 skill categories, 5 pattern archetypes.

</v-click>

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

**Workshop resources:** `[URL TBD]`

<div class="mt-8 opacity-70">

Handbook · Starter skill · Demo repo · Blog posts

</div>

<div class="abs-br m-6 text-sm opacity-50">
Nick Nisi & Zack Proser · AIE Europe 2026
</div>

<!--
Final slide. Leave the resources URL up while people finish installing.

Resources: technique library handbook, starter skill template, demo repo, blog posts (Case Statement, Writing My First Evals, Ideation, Feedback Loopable).

"You're leaving with one reusable skill for a real task you do every week. Thanks for building with us."
-->
