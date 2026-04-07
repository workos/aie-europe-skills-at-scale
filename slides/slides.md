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

Portable skills for Claude Code, Codex, Cursor, and your own agents

<div class="abs-br m-6 flex gap-2 text-sm opacity-50">
  <span>Nick Nisi & Zack Proser</span>
  <span>·</span>
  <span>AIE Europe 2026</span>
</div>

<!--
BLOCK 1: THE PROBLEM + WHAT SKILLS ARE (7 min)

Nick opens. Don't read slides — this is conversational.

"Raise your hand if you've used an AI coding tool in the last week."
[hands go up]
"Keep it up if the first thing you did was re-explain your tech stack."
[groans]
"Yeah. We're going to fix that."
-->

---

# Who we are

<div class="grid grid-cols-2 gap-12">
<div class="flex flex-col items-center text-center">

<img src="/nick-nisi.webp" class="w-36 h-36 rounded-full object-cover mb-4" />

### Nick Nisi

**DX Engineer · WorkOS**

</div>
<div class="flex flex-col items-center text-center">

<img src="/zack-proser.webp" class="w-36 h-36 rounded-full object-cover mb-4" />

### Zack Proser

**DX Engineer · WorkOS**

</div>
</div>

<div class="mt-8 text-center text-sm text-gray-500">

Skills aren't a side project for us — they're how we build everything.

</div>

<!--
30 seconds. Don't read bios.

"I'm Nick, this is Zack. We're DX engineers at WorkOS."

"We built the WorkOS CLI — Agent SDK under the hood, but the brains are entirely skills-based. A RAG agentic pipeline. An agentic harness for DX engineering. All powered by skills."

"The weird part? The first versions made things worse. That's part of what we'll teach today."
-->

---

# The problem

<div class="grid grid-cols-2 gap-8 mt-2">
<div>

### Unreliable

Hallucinations, ignored instructions, generic output — you can't *depend* on it

</div>
<div>

### Amnesia

You keep re-explaining your stack, your conventions, your preferences — every conversation

</div>
</div>

<v-click>

<div class="mt-6 p-4 rounded-xl bg-[#6363F1]/5 border border-[#6363F1]/20 text-center">

**Skills fix this.** A markdown file that encodes your context, constraints, and judgment — so the AI is reliable every time.

</div>

</v-click>

<!--
1 minute max. Quick, don't dwell.

"Every developer using AI tools has these two problems."

"First: it's impressive but you can't depend on it. Hallucinations. Ignored instructions. Generic slop."

"Second: you keep re-explaining yourself. Your tech stack. Your conventions. Your preferences. Every new conversation."

[click]

"Skills fix both. A skill is a markdown file. That's it. It encodes your context, your constraints, your judgment. The AI becomes reliable because the skill tells it what you know."
-->

---

# Which would you trust?

<BadGoodCompare />

<!--
This is the hero moment. Let the component animate.

"Same repo. Same question. One with a skill, one without."

Wait for the good side to finish building.

"Which of these would you actually send to your manager? Which would you actually act on?"

[beat]

"The difference is about 30 lines of markdown."

TIMING: Should hit this slide by ~3:00.
-->

---

# Anatomy of a skill

<SkillAnatomy />

<!--
Let the component walk through each section.

"A skill has four parts."

[frontmatter highlights] "The name and description — this is how the AI finds your skill and decides when to use it."

[scripts highlight] "Context scripts — shell commands that run and inject real data. The AI reasons over evidence, not guesses."

[constraints highlight] "Constraints — what the AI must NOT do. Every unconstrained dimension is where it drifts."

[structure highlight] "And structure — what you want back. The shape of the output."

Keep it quick — they'll see all of this when they open the file.
-->

---

# Today: Repo Roast

A skill that audits any git repo's health using real data.

<div class="grid grid-cols-3 gap-4 mt-6">
<div class="p-4 rounded-xl bg-gray-50 border border-gray-200">
<div class="text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">The domain</div>

Stale TODOs, churn hotspots, large files, documentation gaps

</div>
<div class="p-4 rounded-xl bg-gray-50 border border-gray-200">
<div class="text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">The point</div>

The patterns — not the domain. Constraints, scripts, phases, confidence.

</div>
<div class="p-4 rounded-xl bg-gray-50 border border-gray-200">
<div class="text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">Make it yours</div>

We provide baselines + checkpoints. You decide tone, constraints, and signals.

</div>
</div>

<!--
"Today you're building one skill: Repo Roast. A repo health assessment."

"The domain is the vehicle. The patterns are what you're taking home. Everything you learn — constraints, scripts, phases, confidence — works for any skill, not just this one."

"We have checkpoints if you fall behind. But customize. Add a constraint that matters to YOUR team. Change the tone."

Transition: "So what does that markdown file actually look like? Let's get set up and you'll see."
-->

---

# Get set up

<div class="grid grid-cols-2 gap-8">
<div>

```bash
git clone https://github.com/workos/aie-europe.git
cd aie-europe && ./setup.sh
```

Then: `Roast this repo`

Health score? You're ready.

</div>
<div class="flex items-center justify-center">

<img src="/qr-workshop-repo.svg" class="w-48 h-48" alt="QR code to clone repo" />

</div>
</div>

<!--
BLOCK 2: SETUP (5 min)

"Clone this repo. Run setup.sh — it copies the starter skill into the right directory for your tool."

Nick talks through setup, Zack walks the room helping people who hit issues.

"Start your agent — Claude Code, Codex, or Cursor. Ask it to roast the repo. If you see a health score, you're ready."

Keep to 90 seconds of talking. The rest is helping people.
-->

---

# How skills load

Every tool discovers skills differently, but the file is the same.

| Tool | Discovery path |
|---|---|
| **Claude Code** | `.claude/skills/repo-roast/SKILL.md` |
| **Codex** | `.agents/skills/repo-roast/SKILL.md` |
| **Cursor** | `.cursor/rules/repo-roast.md` |

**The dev loop (same in every tool):**

```
edit skill → save → invoke → see output → edit again
```

No restart. No reload. This loop is the entire workshop.

<!--
"The skill file is identical across tools. Only the directory changes. That's portability."

"This loop — edit, save, run, observe, fix — is what you'll do for the next hour."

Keep to 60 seconds.

Transition: "OK, let's build."
-->

---
layout: section
---

# Build the Foundation

<div class="text-2xl opacity-70">20 minutes · hands-on</div>

<!--
BLOCK 3: BUILD THE FOUNDATION (20 min)

"Now we build."

Presenter switch: one drives live edits, the other translates for the room.

TIMING: Teach concepts = 5 min. Hands-on = 10 min. Discussion while working = 5 min.
-->

---

# Constraints > Instructions

<div class="grid grid-cols-2 gap-8 mt-4">
<div>

### Instead of telling the AI what to do...

- "Be thorough"
- "Give good advice"
- "Analyze the repo carefully"

<div class="text-sm text-gray-400 mt-2">Vague. Unenforceable. The AI drifts.</div>

</div>
<div>

### Close off what it shouldn't do

- "Never be vague — cite files and counts"
- "Never recommend rewrite from scratch"
- "Only report findings backed by evidence"
- "Maximum 10 findings, ordered by severity"

<div class="text-sm text-[#6363F1] mt-2 font-semibold">Every unconstrained dimension is where the AI drifts.</div>

</div>
</div>

<!--
"Don't tell the AI what to do — close off what it shouldn't do."

"Positive instructions are aspirational. 'Be thorough' means nothing. Negative constraints are enforceable. 'Never be vague — cite specific files and counts' closes a failure mode."

"Think of it as degrees of freedom. Every dimension you don't constrain is a dimension where the AI will drift."
-->

---

# The `!` backtick: evidence, not guesses

Scripts run shell commands and inject the output into the skill's context.

```markdown
## Context
Stale TODOs: !`grep -rn "TODO\|FIXME" . --include="*.*" | head -20`
Hotspot files: !`git log --pretty=format: --name-only
  --since="6 months ago" | sort | uniq -c | sort -rn | head -10`
Largest files: !`git ls-files | xargs wc -l 2>/dev/null
  | sort -rn | head -10`
```

<v-click>

<div class="mt-4 p-3 rounded-lg bg-sky-50 border border-sky-200 text-sm">

**Without scripts:** the AI speculates about your repo.
**With scripts:** it has `git log`, file counts, TODO grep results — real data.

</div>

</v-click>

<!--
"The backtick-bang syntax is the single biggest upgrade to any skill."

"These commands run in the repo. The output gets injected into the skill's context. The AI reasons over evidence, not guesses."

[click]

"Without scripts, the skill is just a fancy prompt. With scripts, it's forensic."
-->

---

# Descriptions are routing rules

The description isn't marketing copy — it's how the AI decides *when* to use your skill.

```yaml
description: Analyzes repository health by running git scripts
  to find stale TODOs, churn hotspots, large files, and
  documentation gaps. Use for repo assessments, health checks,
  or tech debt audits. Do NOT use for simple file lookups,
  git history questions, or code review of specific changes.
```

<v-click>

**The test:** Ask your AI tool *"When would you use this skill?"*

If the answer doesn't match your intent, rewrite the description.

</v-click>

<!--
"The description is a routing rule. It tells the AI: use this skill when you see these signals, don't use it for these other things."

[click]

"Here's a test you can run right now: ask your tool 'when would you use this skill?' If the answer surprises you, the description is wrong."
-->

---

# Your turn: build your Repo Roast

Open `.claude/skills/repo-roast/SKILL.md` and customize:

<div class="grid grid-cols-2 gap-6 mt-2">
<div class="space-y-2 text-sm">

1. **Description** — routing rule that matches your intent
2. **Constraints** — add 1-2 that reflect YOUR judgment
3. **Tone** — roast? professional audit? diplomatic?
4. **Script** — optionally add one (test ratio, CI check, package manager)

</div>
<div class="space-y-2 text-sm">

Then run it:

```
Roast this repo
```

Compare with the bad output. Better?

**Behind?** `cp checkpoints/1-starter.md .claude/skills/repo-roast/SKILL.md`

</div>
</div>

<!--
"Open your skill file. Customize it. Make it yours."

"Write a description that routes correctly. Add constraints that matter to YOUR team. Pick a tone."

"Then run it. Compare with what you saw before."

Let them work. Switch to discussion topics.
-->

---

# While you work

<div class="space-y-6 mt-4">

<div class="p-4 rounded-xl bg-amber-50 border border-amber-200">

### "When a skill makes the AI dumber"
Nick's Next.js installer skill for AuthKit — over-prescribed so heavily that Claude got *worse* at Next.js than without the skill. Where's the line between useful constraints and over-prescribing?

</div>

<div class="p-4 rounded-xl bg-sky-50 border border-sky-200">

### "Scripts as the turning point"
Zack's RAG pipeline — what it produced when guessing vs. when scripts injected real evidence. Why scripts are the single biggest upgrade.

</div>

<div class="p-4 rounded-xl bg-purple-50 border border-purple-200">

### "Encoding voice as constraints"
Zack's blog-writing skill for the WorkOS blog. The difference between "write like our blog" (vague) and actual constraints that capture style.

</div>

</div>

<!--
Nick/Zack discussion while attendees work. For the YouTube recording.

These are real conversations, not lectures. Riff naturally.

Topic 1: Nick tells the AuthKit story. The skill was correct but it closed off Claude's actual strengths.

Topic 2: Zack talks about the RAG pipeline before/after scripts.

Topic 3: How do you encode voice and style? When does it produce on-brand slop?

TIMING: Check in with room at ~15:00. "Did your output get more specific? If it did, you just proved that constraints and evidence work. Now let's make it smarter."
-->

---
layout: section
---

# Make It Smarter

<div class="text-2xl opacity-70">25 minutes · hands-on</div>

<!--
BLOCK 4: MAKE IT SMARTER (25 min)

"You've got a skill that gives specific, evidence-backed findings. Now let's make it smarter."

TIMING: Teach = 5-7 min. Hands-on = 12-15 min. Discussion = 5 min.
-->

---

# Progressive disclosure

Break the skill's work into phases. Each phase loads different context.

<FolderTree />

<!--
Let the component animate through the phases.

"Progressive disclosure means the skill doesn't dump everything at once. It works in phases."

[Phase 1 highlights] "Phase 1 gathers raw data — runs the scripts, collects counts."

[Phase 2 highlights] "Phase 2 categorizes and scores — only if Phase 1 found something worth categorizing."

[Phase 3 highlights] "Phase 3 builds recommendations — only for the high-severity findings."

"Key insight: this only truly works when phases reference external files. If everything's in one file, the model sees it all at once. In-file phases are suggestions. External files are real gates."
-->

---

# Confidence scoring

The skill rates its own work. Findings below the threshold get dropped.

```markdown
## Self-Assessment
Rate each finding before presenting:
- Evidence quality (1-10): Backed by data or inference?
- Severity accuracy (1-10): Real problem or intentional?
- Actionability (1-10): Can someone act on this today?

If any finding scores below 6 on evidence quality,
drop it or flag as "needs investigation."
```

<v-click>

<div class="mt-3 p-3 rounded-lg bg-green-50 border border-green-200 text-sm">

**The result:** the skill knows when it's guessing and says so, instead of presenting everything with equal confidence.

</div>

</v-click>

<!--
"Confidence scoring gives the skill self-awareness."

"Three dimensions: is this backed by real evidence? Is this actually a problem? Can someone act on it?"

"Anything below a 6 on evidence gets dropped or flagged. The skill filters its own noise."

[click]

"This is the difference between a tool that dumps findings and one that only shows you what it's confident about."

Concrete example — use this: "I have an ideation skill that brainstorms feature ideas. Without confidence scoring, it would confidently recommend approaches it didn't have enough context for. After adding self-assessment, it started saying 'I'm not confident about this because I don't know your auth model' instead of guessing. That's the shift — from fake confidence to useful honesty."
-->

---

# The iteration loop

<div class="grid grid-cols-3 gap-6 mt-8">
<div class="text-center p-4 rounded-xl bg-gray-50 border border-gray-200">
<div class="text-3xl mb-2">🔨</div>
<div class="font-semibold">Build</div>
<div class="text-xs text-gray-500">Add phases + confidence</div>
</div>
<div class="text-center p-4 rounded-xl bg-gray-50 border border-gray-200">
<div class="text-3xl mb-2">▶️</div>
<div class="font-semibold">Run</div>
<div class="text-xs text-gray-500">See what it produces</div>
</div>
<div class="text-center p-4 rounded-xl bg-gray-50 border border-gray-200">
<div class="text-3xl mb-2">🔍</div>
<div class="font-semibold">Be honest</div>
<div class="text-xs text-gray-500">Is the output better?</div>
</div>
</div>

<div class="mt-8 text-center text-sm text-gray-500">

The first version is never the good version. Every skill we've built went through dozens of iterations.

</div>

<!--
"This is the real technique: build, run, be honest about the output, adjust."

"You're about to do exactly this. Add phases. Add confidence scoring. Re-run. Compare."

"The before/after comparison IS the lesson."
-->

---

# Your turn: add phases + confidence

Add two sections to your skill, then re-run.

<div class="grid grid-cols-2 gap-4 mt-2 text-sm">
<div>

**Add `## Workflow`**

```markdown {maxHeight:'120px'}
Phase 1: Run scripts. Summarize raw findings.
Phase 2: Categorize by type. Score severity.
Phase 3: Prioritized recommendations.
Do not skip phases.
```

**Add `## Self-Assessment`**

```markdown {maxHeight:'100px'}
Rate each finding:
- Evidence quality (1-10)
- Severity accuracy (1-10)
- Actionability (1-10)
Drop findings below 6 on evidence.
```

</div>
<div>

**Run it:** `Roast this repo`

**Compare with your last output:**
- Phases → conversation instead of dump?
- Confidence → less noise?
- Is the output *better*?

**Behind?** `cp checkpoints/2-with-phases.md .claude/skills/repo-roast/SKILL.md`

</div>
</div>

<!--
"Add two sections to your skill: Workflow and Self-Assessment."

"Then run it again on the same repo. Compare the output. Is it better?"

Let them work. Switch to discussion topics.
-->

---

# While you work

<div class="space-y-6 mt-4">

<div class="p-4 rounded-xl bg-amber-50 border border-amber-200">

### "Phase-gating honesty"
LLMs can just... skip phases. What actually works? External file references. Explicit stop points. What doesn't work? "Do not proceed" when all context is already loaded. Where's the line between useful structure and false sense of control?

</div>

<div class="p-4 rounded-xl bg-sky-50 border border-sky-200">

### "When confidence scoring saved us"
Nick's ideation skill: what happened when it generated ideas without self-assessment? It confidently recommended things it didn't have context for. Adding confidence dimensions surfaced gaps instead of guessing through them.

</div>

</div>

<!--
Nick/Zack discussion while attendees work. For the YouTube recording.

Topic 1: Be honest about the limits of phase-gating. Tell the specific story of which skill ignored phases and what the fix was. The audience is adding phases right now — they need to know where the limits are.

Topic 2: Tell the ideation skill story. What happened without self-assessment? What changed when confidence dimensions were added?

TIMING: Check in at ~40:00.

Transition: "Your skill works here. Does it work everywhere?"
-->

---
layout: section
---

# Skills Beyond the Editor

<div class="text-2xl opacity-70">15 minutes · hands-on + presenter-led</div>

<!--
BLOCK 5: SKILLS BEYOND THE EDITOR (15 min)

Open with energy — one more hands-on moment, THEN the portability talk.

"Your skill works here. Does it work everywhere?"
-->

---

# Level up your scripts

Pick one. Add it to your `## Context` section. Re-run.

<ScriptMenu />

<!--
"We've been using basic scripts. Let's go deeper."

"Pick one that sounds fun. Copy it into your skill. Run it again. See how the new signal changes the roast."

Let them work for 3-5 minutes. The ScriptMenu component is interactive — click to expand each option.

Nick/Zack riff while people work: what makes a good script, why these are all git-only (portability), which you'd keep in a production skill.
-->

---

# Same skill, everywhere

<PortabilityGrid />

<!--
Let the component animate through the three contexts.

"The skill you just built — the same markdown file — works beyond your editor."

[Claude Code panel] "In editor tools, scripts execute directly. Full evidence-driven analysis."

[Desktop panel] "In Claude Desktop or web, there are no scripts. But the constraints and structure still shape the output. Paste in a git log, the skill reasons over it."

[Agent SDK panel] "In the Agent SDK, skills are the brains of programmatic agents. The WorkOS CLI is built this way. Pi runs skills too. CI pipelines can load skills on every push."

"Skills are the portable unit of knowledge. The runtime is interchangeable."
-->

---

# Measurement matters

<div class="grid grid-cols-2 gap-8 mt-4">
<div>

### A skill that made things worse

Correct information, wrong recommendations. Missing context.

<div class="mt-3 p-3 rounded-lg bg-red-50 border border-red-200 text-center">
  <span class="text-2xl font-bold text-red-600">-12% to -20%</span>
  <div class="text-xs text-red-500 mt-1">Measured delta vs. no skill at all</div>
</div>

</div>
<div>

### If you rely on a skill, measure it

<div class="space-y-3 mt-2 text-sm">
<div class="flex items-center gap-2">
  <span class="h-2 w-2 rounded-full bg-green-500" />
  <span><strong>Quick:</strong> skill-reviewer pattern</span>
</div>
<div class="flex items-center gap-2">
  <span class="h-2 w-2 rounded-full bg-[#6363F1]" />
  <span><strong>Full eval:</strong> when the skill is load-bearing</span>
</div>
<div class="flex items-center gap-2">
  <span class="h-2 w-2 rounded-full bg-gray-400" />
  <span><strong>Deeper:</strong> see the handbook</span>
</div>
</div>

</div>
</div>

<!--
Keep this tight. 3 minutes.

Tell the SPECIFIC story: "We built a code review skill. The evidence it gathered was right — it found real issues. But the recommendations were wrong because it didn't have context about the team's conventions. It was flagging intentional patterns as bugs. When we measured, it was making reviews 12 to 20 percent worse than no skill at all."

"Vibes told us the skill was working. Measurement told us it wasn't. That's the difference."

"The handbook has the full eval framework if you want to go deeper."

Transition: go straight into sharing. No recap.
-->

---
layout: section
---

# Close

<div class="text-2xl opacity-70">8 minutes</div>

<!--
BLOCK 6: CLOSE (8 min)

Energy should flow directly from Block 5 into sharing.

"Let's see what everyone built."
-->

---

# Share your roast

<div class="grid grid-cols-2 gap-8">
<div>

```bash
./share.sh --name "Your Name"
```

We'll pull a few up on the projector.

Compare with your neighbor — what's different? What constraints did you add?

</div>
<div class="flex items-center justify-center">

<div class="p-6 rounded-xl bg-[#6363F1]/5 border border-[#6363F1]/20 text-center">
<div class="text-4xl mb-2">🔥</div>
<div class="font-semibold">Roast the repo, not the people.</div>
</div>

</div>
</div>

<!--
"Run share.sh — it sends your skill to us. We'll pull a few up on the projector."

"Pair up. Compare outputs. What's different? What constraints did you add? What surprised you?"

Pull 2-3 to the projector. React to the differences. Highlight interesting constraints or scripts people added.

TIMING: 3 minutes for sharing.
-->

---

# Install your skill + what comes next

<div class="grid grid-cols-2 gap-6">
<div>

### Make it global

```bash
# Claude Code
cp .claude/skills/repo-roast/SKILL.md ~/.claude/skills/repo-roast/SKILL.md
# Codex
cp .agents/skills/repo-roast/SKILL.md ~/.agents/skills/repo-roast/SKILL.md
# Cursor — copy to project .cursor/rules/
```

Share via git — anyone who clones gets the skill.

</div>
<div>

### Keep going

- **skill-creator** — build skills faster
- **Transcript reflection** — learn from past sessions
- **Eval framework** — measure your skills
- **The handbook** — all 12 techniques
- **Plugin registries + GitHub** — growing ecosystem

</div>
</div>

<!--
"Install your skill globally. Copy it to the global skills directory — now it's available in every project, not just this one."

"You can use this tomorrow morning."

Quick hits on what comes next. Don't dwell — one slide, fast.
-->

---
layout: center
---

# Skills at Scale

<div class="max-w-lg mx-auto text-center space-y-4">

<div class="text-lg text-gray-600">

Remember the show of hands?

**That's what the skill replaces.** Tomorrow you won't re-explain. The skill already knows.

</div>

<div class="text-sm text-gray-400">Constraints · Scripts · Phases · Confidence · Portability</div>

<div class="text-lg font-semibold text-[#6363F1]">Now go build skills for the tasks *you* repeat.</div>

<div class="flex justify-center gap-6 mt-6 text-xs text-gray-400">
  <span>github.com/workos/aie-europe</span>
  <span>·</span>
  <span>GUIDE.md</span>
  <span>·</span>
  <span>handbook.md</span>
</div>

</div>

<!--
The Spiral Return. Callback to the opening.

"Remember the show of hands? Re-explaining your stack every conversation? That's what the skill replaces."

"Tomorrow morning, you won't re-explain. The skill already knows."

[beat]

"You learned the patterns: constraints, scripts, phases, confidence, portability. You built a working skill. Now go build skills for the tasks YOU repeat."

"That's how AI stops being a toy and starts being a tool."

"Thank you."
-->
