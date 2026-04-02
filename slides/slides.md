---
theme: default
title: "Skills at Scale"
info: |
  ## Skills at Scale
  Write once, run in Claude, Codex, Cursor, and your own agents.

  An 80-minute hands-on workshop.
author: Nick Nisi & Zack Proser
keywords: skills,agents,claude,ai
highlighter: shiki
drawings:
  persist: false
transition: slide-left
mdc: true
colorSchema: dark
duration: 80min
timer: countdown
---

# Skills at Scale

Write once, run in Claude, Codex, Cursor, and your own agents

<div class="abs-br m-6 flex gap-2 text-sm opacity-50">
  <span>Nick Nisi & Zack Proser</span>
  <span>·</span>
  <span>AIE Europe 2026</span>
</div>

<!--
Welcome everyone. 80 minutes. You're going to leave with a working skill installed in your AI tools, ready to use Monday morning.

Core promise — say it now: "You're leaving with one reusable skill for a real task you do every week."
-->

---
layout: section
---

# The Problem

<!--
5 minutes. Set the stage. Show the pain.
-->

---

# You've done this before

<v-clicks>

- Open Claude / Cursor / Codex
- Type the same instructions you typed yesterday
- Get roughly the same output
- Tweak it the same way you tweaked it last time
- Repeat tomorrow

</v-clicks>

<!--
Every developer using AI tools has this problem. You prompt the same way, for the same tasks, over and over.

You've explained your coding style 50 times. You've described your project structure 50 times. You've said "don't use semicolons" 50 times.

That's not a workflow. That's a habit.
-->

---

# If you've explained the same task to AI five times

# that should be a **file**, not a habit

<!--
This is the core insight. A skill is just a file. A markdown file that teaches any AI tool how to do a specific job.

Write one, drop it into your editor, and it just works. Across tools. Across teams.

Most people don't know this primitive exists.
-->

---

# What's a skill?

A portable unit of agent behavior — a markdown file that teaches any AI tool how to do a specific job.

<v-clicks>

- It's just a file (`.md`)
- Drop it in, it works
- Same file powers Claude Code, Cursor, Codex, Claude Desktop
- **No repos to clone. No dependencies to install.**

</v-clicks>

<!--
A skill is a markdown file. That's it. There's no SDK, no build step, no configuration. You write it, you drop it in a skills directory, and the AI tool reads it.

The same file works across tools. That's the "write once, run everywhere" promise.
-->

---

# Today's workshop

<v-clicks>

**You're leaving with one reusable skill for a real task you do every week.**

Three acts, one skill, progressively better:

1. 🔨 **Build the foundation** — constraints, scripts, structure
2. 🧠 **Make it smarter** — phases, confidence scoring, reflection
3. 🚀 **Why this scales** — eval, composition, portability

</v-clicks>

<!--
Here's the plan. One skill, built across three acts. Each act layers new techniques onto the same skill.

We teach the guitar, not the song. The techniques transfer to any domain.

Repeat the promise: "You're leaving with one reusable skill for a real task you do every week."
-->

---
layout: section
---

# Act 1: Build the Foundation

<div class="text-2xl opacity-70">20 minutes · hands-on</div>

<!--
Transition to Act 1. This is where they build.
-->

---
layout: quote
---

# "Instructions decay, enforcement persists."

<!--
Story time. 30-60 seconds, punchy.

From building Case — a multi-agent harness for 20+ repos. Early versions gave agents prose instructions. Context windows compressed, agents forgot, they started skipping phases and creating fake evidence.

The fix wasn't better instructions. It was mechanical constraints — things agents can't ignore because they're structural, not advisory.

That's the same principle behind a good skill.
-->

---

# Bad skill

```markdown
# Repo Health Check
Look at this repository and tell me how it's doing.
Be helpful and thorough.
```

<v-click>

Output: *"Your codebase looks pretty good overall. Consider adding more tests."*

</v-click>

<!--
This is what most people's "skills" look like. Vague, positive instructions, no guardrails.

Run this on any repo — you get the same generic advice. It's useless.
-->

---

# Good skill

````md magic-move
```markdown
# Repo Health Check
Look at this repository and tell me how it's doing.
Be helpful and thorough.
```
```markdown
# Repo Roast

## Context
Stale TODOs: !`grep -rn "TODO\|FIXME\|HACK" . --include="*.*" | head -20`
Hotspot files: !`git log --pretty=format: --name-only --since="6 months ago" 
  | sort | uniq -c | sort -rn | head -10`
Largest files: !`git ls-files | xargs wc -l 2>/dev/null | sort -rn | head -10`
README freshness: !`git log -1 --format="%ar" -- README.md`
Recent contributors: !`git log --format="%an" --since="3 months ago" 
  | sort | uniq -c | sort -rn | head -5`

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
Walk through this slowly. Three sections they need to understand:

1. CONTEXT — scripts. The ! backtick syntax runs shell commands inline. The skill gathers its own evidence. It doesn't guess, it checks.

2. CONSTRAINTS — what it should never do. Not "be thorough" but "never be vague, cite files and counts."

3. STRUCTURE — what the output looks like. Not "be helpful" but a specific format.
-->

---

# The `!` backtick: skills that gather evidence

```markdown
Stale TODOs: !`grep -rn "TODO\|FIXME\|HACK" . --include="*.*" | head -20`
```

<v-click>

The skill runs the command and injects the output. Now it has **real data** — not LLM guesses.

</v-click>

<v-click>

This is what makes skills more than prompt templates.

Without scripts → the model guesses about your code
With scripts → the model has the actual diff, actual errors, actual file sizes

</v-click>

<!--
This is the key differentiator of the workshop. Spend time here.

The ! backtick syntax runs a shell command and replaces it with the output. The skill now gathers its own context from the real environment.

A skill without scripts is just a prompt. A skill WITH scripts is a tool.
-->

---

# The output difference

<div class="grid grid-cols-2 gap-8">
<div>

### Bad skill
*"Your codebase looks pretty good overall. Consider adding more tests and updating documentation."*

</div>
<div>

### Good skill
*"Health score: 4/10. Your largest file is `handler.ts` at 2,847 lines — it handles auth, routing, AND database queries. You have 14 TODO comments, the oldest from March 2023. Your README was last updated 8 months ago and references `yarn start` but your lockfile is `pnpm-lock.yaml`."*

</div>
</div>

<!--
This is the laugh-then-whoa moment. The bad skill is useless. The good skill found specific, devastating findings with evidence.

Let the audience react. This is where they go "oh, I want that."
-->

---

# Technique: Constraints > Instructions

<v-clicks>

**Don't tell the model what to do. Tell it what it must never do.**

| Instead of... | Write... |
|--------------|---------|
| "Be thorough" | "Maximum 10 findings, ordered by severity" |
| "Be specific" | "Never be vague — cite files and counts" |
| "Give good advice" | "Never recommend rewrite from scratch" |
| "Be helpful" | "Every finding needs: issue, evidence, severity, fix" |

Negative constraints close failure modes.
Positive instructions leave them open.

</v-clicks>

<!--
This is the first transferable technique. Constraints > instructions.

Models are better at avoiding known-bad patterns than discovering ideal patterns. "Never use absolute positioning" is more enforceable than "use responsive layout."

The skills repo at WorkOS encodes 3-7 constraints per topic, all sourced from real eval failures.
-->

---

# Your turn: build your skill

<div class="text-lg">

Open Claude Code (or your tool of choice).

**Start with the starter skill file** — customize it, don't write from scratch.

Focus on:
1. **Scripts** — what context does YOUR repo need? Add 1-2 commands.
2. **Constraints** — what should it NEVER do? Add 1-2 constraints.
3. **Tone** — blunt roast? Professional assessment? Your call.

</div>

<div class="mt-8 opacity-70">

*If you don't have a repo handy, use the demo repo: `[URL TBD]`*

</div>

<!--
Give them time to work. This is the build block.

Walk the room. Help people with script syntax. The most common issue will be the ! backtick syntax.

Narrate what you see: "I see someone adding a script for test coverage — great idea." Fill dead air.

Timer: ~8-10 minutes for building.
-->

---

# Let's see what you got

<div class="text-xl">

Run your skill on your repo.

Compare: what did the bad skill say vs what yours says?

</div>

<!--
Have a few people share their results. This is the fun moment — comparing roasts.

If someone got a great result, show it. If someone's skill didn't work, troubleshoot from stage — that's teaching too.

Transition: "You've got a working skill. Now let's make it smarter."
-->

---
layout: section
---

# Act 2: Make It Smarter

<div class="text-2xl opacity-70">25 minutes · hands-on + demo</div>

<!--
Repeat the through-line: "You already have a working skill. You're leaving with one reusable skill for a real task you do every week. Now let's make it better."
-->

---
layout: quote
---

# "LLMs are good at reasoning about code. They're bad at being state machines."

<!--
Story time. 30-60 seconds.

Another lesson from Case. Early pipeline versions let agents decide their own next steps. They skipped phases, retried excessively, made up their own workflows.

The fix: deterministic flow control outside the model, structured self-assessment inside. That's what we're adding now.
-->

---

# Technique: Progressive Disclosure

Don't dump everything at once. Phase-gate with checkpoints.

<v-click>

Add this to your skill:

```markdown
## Workflow
Phase 1: Run all context scripts. Summarize raw findings. 
         Present counts and hotspots. Stop.
Phase 2: Categorize findings by type (complexity, coverage, 
         dependencies, documentation, churn). Score severity. 
         Present structured report. Stop.
Phase 3: Based on feedback, build prioritized recommendations. 
         Run constraints checklist. Present final assessment.
Do not skip phases. Each phase requires confirmation before proceeding.
```

</v-click>

<!--
Without phases, the model one-shots everything. You get a wall of text. No way to steer.

With phases, it stops after each one. You review Phase 1 — "yeah, focus on the auth module" — and Phase 2 is targeted. Collaborative instead of a dump.

The WorkOS CLI uses this same pattern: detect framework → install → configure → verify. Each step produces output the next step needs.
-->

---

# Technique: Confidence Scoring

The skill grades its own work — and self-corrects.

<v-click>

Add this to your skill:

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

</v-click>

<!--
This is the simplest possible feedback loop. Zero infrastructure. The model grades itself and revises.

The Ideation plugin does a more sophisticated version: 5 dimensions, each 0-20, requiring 95 total points to advance. But even this simple version dramatically improves output. The model catches its own drift.

Key insight: confidence should be decomposed into meaningful dimensions, not just a single number.
-->

---

# What confidence scoring looks like

<div class="grid grid-cols-2 gap-8">
<div>

### Without
*"Your handler.ts file is too large and should be split up."*

<div class="text-sm opacity-50">Is it? Says who? Based on what?</div>

</div>
<div>

### With
*"Finding: handler.ts (2,847 lines)*
*Evidence quality: 9/10 — line count from scripts*
*Severity: 7/10 — large but could be intentional*
*Actionability: 8/10 — split into 3 modules"*

<div class="text-sm opacity-50">Evidence-backed. Self-assessed. Actionable.</div>

</div>
</div>

<!--
The difference is trust. Without scoring, you're just getting opinions. With scoring, the model tells you HOW SURE it is and WHY.

The low-confidence findings get dropped automatically. No more speculative noise padding the report.
-->

---

# Your turn: add phases + confidence

<div class="text-lg">

Add to your skill:
1. **Workflow section** — 2-3 phases with stop points
2. **Self-Assessment section** — dimensions that matter for YOUR domain

Then run it again. Compare the output to your Act 1 version.

</div>

<!--
Give them time to work. ~8-10 minutes.

Walk the room. The most common issue: people make phases too granular. Three phases is plenty.

Narrate: "Notice how Phase 1 is just a triage now — you get to decide where to go deeper before committing."
-->

---

# Demo: Transcript Reflection

<div class="text-xl opacity-70">The "oh wow" moment — watch this one from stage</div>

<!--
Transition to the demo. They've been building; now they watch something surprising.
-->

---

# The conversation is data

Most people treat every AI session as stateless.

Close the tab. Context gone.

<v-click>

But the transcript contains:
- Decisions you made (and why)
- Mistakes that were corrected
- Dead ends you abandoned
- Patterns that worked

</v-click>

<v-click>

**That's the most honest record of how the work actually went.**

</v-click>

<!--
Real story: When writing the blog post about building evals, I had Claude review the transcripts from the sessions where I actually built them.

The transcripts surfaced anecdotes I'd forgotten — dead ends, surprising failures, moments where the approach changed. Those became the most compelling parts of the post.
-->

---

# Claude Code already does this

<v-clicks>

**Auto-memory:** Every session teaches the next session something.

Claude Code persists learnings to memory files:

```
~/.claude/projects/*/memory/
```

These memories carry across sessions. The tool gets smarter about **you** over time.

You don't even need a skill for this. It's already happening.

**The flywheel:** work → reflect → extract → apply → better work

</v-clicks>

<!--
Show Claude Code's memory system. Open the memory directory, show what's in there.

The message: after running their skill a few times post-workshop, they'll have transcripts to reflect on. Plant the seed now; they'll harvest it later.
-->

---
layout: section
---

# Act 3: Why This Scales

<div class="text-2xl opacity-70">20 minutes · presenter-led</div>

<!--
Transition. Repeat through-line: "The skill you just built IS the thing we're now showing at scale. You're leaving with one reusable skill for a real task you do every week."
-->

---
layout: quote
---

# "Trust isn't a feeling. It's a number."

<!--
Story time. This one hits hardest.

"I built a skill for directory sync and SSO. It looked helpful. It contained accurate information. I was proud of it."

"Then I ran the eval — same test cases, with and without the skill. The skill made the output WORSE. Consistently. -12% to -20% delta."

"The skill was teaching correct information but omitting critical context, and the model was scoring lower because of it."

Let that land. Pause.
-->

---

# Live: Let's eval someone's skill

<div class="text-xl">

Who wants to volunteer their skill?

We'll run the skill-reviewer on it — right now, live.

</div>

<!--
Pull up someone's skill from the audience. Run the skill-reviewer. Show structured feedback.

This demonstrates the eval concept without infrastructure. The message: measuring is possible and necessary.

Then show the production version briefly: 42 test cases, with/without comparison, hard gates on regression. "This is where you graduate to when skills become load-bearing."
-->

---

# Measuring: vibes vs engineering

<v-clicks>

**"This skill feels better"** is not evidence.

A measured delta is.

The WorkOS skills eval framework:
- 42 test cases
- Run WITH and WITHOUT the skill
- Measure the delta
- Hard gates: no negative delta, hallucination reduction ≥ 50%

Even the eval can be wrong — 13 apparent regressions were actually scorer bugs.

**Start with the skill-reviewer today.** Graduate to eval when skills become load-bearing.

</v-clicks>

<!--
Brief — don't belabor this. Show the concept, reference the production version, move on.

Key message: measure, don't vibe.
-->

---

# Context Detection: same skill, different audiences

```markdown
## Audience Detection
Determine the audience from the user's request:
- Developer → Roast mode. Blunt, specific, actionable.
- Engineering manager → Assessment mode. Quantify impact. Business cost.
- New teammate → Orientation mode. Landscape overview. Be welcoming.
If unclear, ask: "Who's this for?"
```

<v-click>

**Developer:** *"Here are the 5 worst hotspots. Start with handler.ts."*

**Manager:** *"Auth module: 47 modifications, 8 contributors in 6 months. High churn signals coordination cost."*

**New hire:** *"Welcome. 3 areas healthy, 2 hot spots to know about."*

</v-click>

<!--
This is the "at scale" moment within a single skill. Same findings, different delivery.

Quick demo from the WorkOS CLI: 15 frameworks detected automatically, the right skill activated for each one. Same pattern, production grade.
-->

---

# Composition: skills as building blocks

<v-clicks>

Your skill solves one problem.

Skills composed together are a system.

**The WorkOS CLI:**
- 15 framework integrations
- Each one a skill composed with others
- Wired into an agent via the Claude Agent SDK
- Validation-driven retry loops (typecheck fails → error fed back → agent self-corrects)

That's production code. Shipping today.

The same techniques you learned in Act 1 and Act 2 power this system.

</v-clicks>

<!--
The full-circle story: the CLI's retry loop was born from an Ideation session. Rambling input → confidence gate → codebase exploration → spec → implementation.

Progressive disclosure, confidence scoring, phased workflow — the techniques from today — produced the production system we're showing now.
-->

---

# Cross-tool portability: the "at scale" payoff

<v-clicks>

**Personal scale:** Same skill file → Claude Code → Cursor → Codex. No changes.

**Team scale:** Push to a repo. Teammate pulls it. Works in their tool.

**Production scale:** Skills composed inside agents. `workos skills install` across all detected agents.

</v-clicks>

<!--
Demo time: show the same skill file working in Claude Code, then mention/show it in another tool. "We didn't change a line."

The point: skills are the substrate, tools are interchangeable.
-->

---

# Skills for everyone

<v-clicks>

Not everyone on your team writes code.

**Claude Desktop:** Same skill. No terminal. No GitHub.

A manager runs the health assessment to prep for a planning meeting.

A new teammate runs it to understand the landscape before their first PR.

**Same skill, from terminal to desktop to team to production.**

</v-clicks>

<!--
This is the accessibility close. Show Claude Desktop briefly if possible.

In coding tools, the skill gathers evidence via scripts. In Desktop, it works from shared output or pasted context. The skill file is the same — the execution context differs.
-->

---
layout: section
---

# Close: Share & Install

<div class="text-2xl opacity-70">10 minutes · hands-on</div>

<!--
Final build block. Make it real.

"You're leaving with one reusable skill for a real task you do every week. Let's make sure it's installed and shareable."
-->

---

# Install your skill

<div class="text-lg">

**Claude Code:**
```bash
# Drop your skill file into
~/.claude/skills/repo-roast/SKILL.md
```

**Cursor:**
```bash
~/.cursor/skills/repo-roast/SKILL.md
```

**Codex:**
```bash
~/.codex/skills/repo-roast/SKILL.md
```

Same file. Same skill. Different tools.

</div>

<!--
Walk them through installation. Help anyone who's stuck.

The key moment: it works in a different tool without changing anything.
-->

---

# Share it

<div class="text-lg">

<v-clicks>

1. Push your skill to a repo
2. Tell your neighbor to pull it
3. Watch them run it on their project

**Skills are just files. Sharing is just git.**

</v-clicks>

</div>

<!--
If time permits, have people actually do this. If not, describe the workflow.

The point: team scale is free. No marketplace, no registry, no deployment. Just git.
-->

---

# What you built today

<v-clicks>

**Act 1:** A skill with constraints, scripts, and structure
→ Generic noise became focused, evidence-backed output

**Act 2:** Added phases and confidence scoring
→ One-shot dump became collaborative and self-correcting

**Act 3:** Saw how it scales — eval, composition, portability, Desktop
→ One skill became a measured, portable, composable system

</v-clicks>

<!--
Quick recap. Don't belabor — they lived it.
-->

---

# What comes next

<v-clicks>

- **Run your skill for a week.** See what works and what doesn't.
- **Add constraints from failures.** Every bad output is a new constraint.
- **Try transcript reflection.** Your past sessions are data. Mine them.
- **Evaluate.** Start with the skill-reviewer. Graduate to evals.
- **Share.** Put it in a repo. Your team will thank you.

</v-clicks>

<!--
The artifact they're leaving with: a working skill installed in their tools, a template for making more, and the techniques to improve them over time.

"You're leaving with one reusable skill for a real task you do every week."

Thank the audience. Open for questions if time permits.
-->

---
layout: center
class: text-center
---

# Skills at Scale

**Workshop resources:** `[URL TBD]`

<div class="mt-8 opacity-70">

Technique library · Starter templates · Demo repo · Blog posts

</div>

<div class="abs-br m-6 text-sm opacity-50">
Nick Nisi & Zack · AIE Europe 2026
</div>

<!--
Final slide. Leave the resources URL up while people finish installing.

Resources should include: technique library handout, starter skill templates for each domain, the demo repo, and the blog posts (Case Statement, Writing My First Evals, Ideation, Feedback Loopable).
-->
