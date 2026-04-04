# Skills at Scale Workshop

## References

- [Slack discussion](https://work-os.slack.com/archives/D087UBR1VK5/p1773176258391629)
- [Granola notes with Zack](https://notes.granola.ai/t/6c345af4-94af-4fbc-b123-5f8deefa1f6e-008umkv4)
- [Feedback Loopable](https://ampcode.com/notes/feedback-loopable)
- [Case Statement: Building a Harness](https://nicknisi.com/posts/case-statement/)
- [Writing my first evals](https://nicknisi.com/posts/writing-my-first-evals/)
- [Ideation: Because planning needs more than a mode](https://nicknisi.com/posts/ideation/)

Skills at Scale

Write once, run in Claude, Codex, Cursor, and your own agents

Every developer using AI tools has the same problem: they prompt the same way, for the same tasks, over and over. Skills fix this. A skill is a portable unit of agent behavior that teaches any AI tool how to do a specific job. Write one, drop it into your editor, and it just works. Across tools. Across teams.

Most people don't know this primitive exists. In this hands-on workshop, you'll write a real skill, test it live in coding tools, and see how the same core skill artifact can travel across Claude Code, Cursor, Codex, and other agent environments — with execution context varying by tool.

Then we'll go deeper. You'll see how the WorkOS CLI uses this same pattern to power 15 framework
integrations — each one a skill composed with others, wired into an agent that installs and configures
AuthKit in under 60 seconds. That's not a demo. That's production code, shipping today.

What you'll do:

Build a Repo Roast / Repo Health Check skill step by step
Add scripts, constraints, phased workflow, and confidence checks
Test it in a local coding tool on a real repo
See how the same patterns scale into production agent systems


What you'll leave with:

One working skill you can reuse and adapt
A repeatable pattern for turning recurring work into portable skills
A clear sense of when a skill is enough and when you need a larger agent system

### Prerequisites

**Bring:**
- A coding agent with local shell access: Claude Code, Cursor, Codex, or similar
- A local git repo you're comfortable analyzing — or use the provided demo repo
- macOS, Linux, or WSL recommended

**Notes:**
- If you only bring Claude.ai / Desktop, you can follow the concepts, but the hands-on script-driven build is designed for local coding tools
- If you can't use employer code with AI tools, use the demo repo instead

---

## Workshop Arc (80 minutes)

### Core Promise

**You're leaving with one reusable skill for a real task you do every week.**

Technique-first workshop. Each act layers techniques onto one shared skill — Repo Roast. The techniques transfer to any domain. We teach the guitar, not the song.

| Block | Time | Mode | What happens |
|-------|------|------|-------------|
| **Open: The problem** | 5 min | Watch | Show a bad repo roast vs an evidence-based one. Frame the promise. |
| **Act 1: Build the foundation** | 20 min | **Build** | Attendees start from a Repo Roast starter skill and customize description, constraints, tone, and scripts. |
| **Act 2: Make it smarter** | 25 min | **Build** | Add phases and per-finding confidence checks. Re-run the same skill and compare output quality. |
| **Act 3: Why this scales** | 20 min | Watch | Same skill adapting to different audiences, composition via WorkOS CLI, and why eval matters. |
| **Close: Share & install** | 10 min | **Build** | Compare outputs, install/share the skill, point to handbook for deeper techniques. |

### What's taught vs what's referenced

Not everything is live curriculum. The [handbook](handbook.md) is the full reference — a handout, a blog post, a companion doc. Live, we teach a subset:

| Delivery | Techniques |
|----------|-----------|
| **Hands-on (attendees build)** | Constraints > instructions, source of truth, structure, scripts (inline `!` calls), progressive disclosure, confidence scoring |
| **Stage demo / proof (presenters)** | Audience adaptation / context detection, composition in a production system, lightweight eval framing |
| **Closing / handbook / next steps** | Transcript reflection, memory, hooks, folder-based skills, model-specific tuning, Desktop/Cowork nuances, skill-creator |

For the full technique library with sources, first-person stories, and deep dives, see the [handbook](handbook.md).

### Dead Air Strategy

The workshop will be recorded for YouTube. Dead air kills recordings. Mitigations:

1. **Pre-baked fallbacks for every live demo.** Record each demo beforehand. If something hangs or breaks, cut to the recording and narrate over it. The audience sees the same result; the video stays clean.
2. **Narrate the wait.** When the agent is working, don't just watch — talk through what it's doing, why it's making those choices, what the audience should watch for. This is where the teaching happens.
3. **Parallel activity during agent runs.** While one demo runs, switch to slides or the attendee exercise. "While this runs, here's what I want you to try." The agent finishes in the background.
4. **Short loops, not long runs.** Structure demos as quick iterations (10-30 seconds each) rather than one long 3-minute agent run. Each loop teaches one thing.
5. **Planted questions / co-presenter banter.** Zack and Nick can volley during any wait. Pre-plan 2-3 talking points per demo to fill gaps naturally.
6. **Timer discipline.** If a demo hasn't completed in 60 seconds, cut to the fallback. Don't hope it finishes.

---

## The Exercise: One Skill, Three Acts

### Live Workshop Domain: Repo Roast

For the live workshop, everyone starts from the same canonical skill: **Repo Roast / Repo Health Check**. This keeps the room synchronized, makes debugging support possible, and ensures the recording has a clear through-line.

Advanced attendees can adapt the same skeleton to another domain after the core build is working, but the live path is shared. For the full skill categories taxonomy (9 categories from Anthropic), see the [handbook](handbook.md#skill-categories-anthropics-taxonomy).

### Why a Shared Domain

- **80 minutes is tight.** A shared starting point prevents decision paralysis and ensures everyone finishes.
- **Debugging from stage requires a common structure.** Everyone's skill has the same sections (constraints, workflow, self-assessment) even if they customize differently.
- **The recording needs a through-line.** The YouTube arc is: naive skill → constrained → self-aware → part of a system. That story works when everyone builds the same thing.
- **The point is the technique, not domain brainstorming.**

### Starter File, Not a Blank Page

To ensure everyone finishes, attendees start from a prebuilt Repo Roast starter skill rather than a blank page. The workshop is about learning the pattern through customization and iteration, not about typing boilerplate from scratch.

### Minimum Success Criteria

**By end of Act 1:** A skill file with a good description, at least one custom constraint, at least one working script, and one successful run.

**By end of Act 2:** Phases added, per-finding confidence checks added, one re-run with visibly improved output.

### Act 1: Build the Foundation — Constraints & Structure

**Technique focus:** Constraints > instructions, source of truth discipline, structure, scripts.

**The story that opens this act:**

> "Instructions decay, enforcement persists."

From building Case — a multi-agent harness for 20+ repos — I learned this the hard way. Early versions gave agents prose instructions for how to behave. Context windows compressed, agents forgot, and they started skipping phases and creating fake evidence. The fix wasn't better instructions. It was mechanical constraints — things agents *can't* ignore because they're structural, not advisory.

That's the same principle behind a good skill. Don't tell the model what to do. Tell it what it must never do, and point it at the real source of truth. (See: [Case Statement](https://nicknisi.com/posts/case-statement/))

**Before they write anything — the description matters:** The skill's name and description are the only things loaded at startup. Claude uses the description to decide whether to activate a skill from potentially 100+ available. A vague description ("helps with repos") means the skill never fires. A good description includes what it does AND when to use it: "Analyzes repository health by running git and file-system scripts. Use when the user asks for a repo assessment, health check, or code quality review." You can also add negative triggers to prevent over-firing: "Do NOT use for simple file lookups or general git questions." Teach this as a 2-minute beat before they start writing.

**Debug it by asking Claude.** After writing the description, have attendees ask Claude: "When would you use the [skill name] skill?" Claude quotes the description back and explains its reasoning. If it can't articulate when to use the skill, the description needs work. If it fires on things it shouldn't, add negative triggers. This is a 30-second exercise that turns description-writing from abstract to testable. When in doubt about whether your skill works, just ask the model — they're surprisingly good at debugging themselves.

**What they start with:** A bad Repo Roast skill plus a starter file for the good version.

**What they build:** A customized Repo Roast / Repo Health Check skill with evidence-gathering scripts, constraints, tone, and a clear structure.

**The starter skill** (from [domain-decision.md](domain-decision.md)):

```markdown
---
name: repo-roast
description: Analyzes repository health by running git and file-system scripts to find stale TODOs, churn hotspots, large files, and documentation gaps. Use when the user asks for a repo assessment, health check, code quality review, or tech debt audit. Do NOT use for simple file lookups, git history questions, or code review of specific changes.
---

# Repo Roast

## Context
Stale TODOs: !`grep -rn "TODO\|FIXME\|HACK\|WORKAROUND" . --include="*.*" | head -20`
Hotspot files: !`git log --pretty=format: --name-only --since="6 months ago" | sort | uniq -c | sort -rn | head -10`
Largest files: !`git ls-files | xargs wc -l 2>/dev/null | sort -rn | head -10`
README freshness: !`git log -1 --format="%ar" -- README.md`
Recent contributors: !`git log --format="%an" --since="3 months ago" | sort | uniq -c | sort -rn | head -5`

## Constraints
- Never be vague — cite specific files and counts as evidence
- Every finding must include: what's wrong, evidence, severity, recommendation
- Never recommend "rewrite from scratch"
- Maximum 10 findings, ordered by severity

## Structure
1. One-line health verdict (with overall score)
2. Top findings (max 10), each with: issue, evidence, severity, fix
3. One thing the repo does well
```

**Required customizations** (what attendees change):
- Description — adapt triggers to their context
- 1–2 constraints — what do THEY never want to see?
- Tone — blunt roast? Professional assessment? Their call.
- Optional: one extra script if time allows

**Key teaching moments:**

- **Scripts:** The `!` backtick syntax runs a shell command inline and injects its output into the skill. This is what makes skills more than prompt templates. The skill now gathers its own context from the real environment — it doesn't guess, it checks.
- **Constraints > instructions:** "The specificity is the skill." Don't tell the model what to do. Tell it what it must never do. But watch the railroading trap — over-constraining kills adaptability. Tight on fragile operations, loose on creative work. (See [handbook](handbook.md#1-constraints--instructions-degrees-of-freedom) for the full degrees-of-freedom framework.)
- **Most public skills are shallow** — viral threads with millions of views share names and one-liners, no constraints, no scripts, no phases. That's the gap this workshop fills.

**What they see change:** Run the same prompt with the bad skill and the constrained skill. The difference is immediate — "Your code looks pretty good overall" vs "Health score: 4/10. Your largest file is `handler.ts` at 2,847 lines. You have 14 TODO comments, the oldest from March 2023. Your README references `yarn start` but your lockfile is `pnpm-lock.yaml`."

### Act 2: Make It Smarter — Phases + Confidence

**Hands-on techniques:** Progressive disclosure, confidence scoring.

**The story that opens this act:**

> "LLMs are good at reasoning about code. They're bad at being state machines."

Another lesson from Case. Early pipeline versions let agents decide their own next steps. They skipped phases, retried excessively, made up their own workflows. The fix: deterministic flow control outside the model, structured self-assessment inside. That's what we're adding now — phases the model follows, and a self-check it runs before presenting. (See: [Case Statement](https://nicknisi.com/posts/case-statement/))

#### Hands-On: Progressive Disclosure
Instead of one-shotting output, the skill works in phases (from [domain-decision.md](domain-decision.md)):

```markdown
## Workflow
Phase 1: Run all context scripts. Summarize raw findings. Present counts and hotspots. Stop.
Phase 2: Categorize findings by type (complexity, coverage, dependencies, documentation, churn). Score severity. Present structured report. Stop.
Phase 3: Based on feedback, build prioritized recommendations. Run constraints checklist. Present final assessment.
Do not skip phases. Each phase requires confirmation before proceeding.
```

**What they see change:** Output becomes collaborative. They steer after Phase 1 instead of accepting whatever comes out.

**Anti-pattern to mention:** When splitting into reference files later, keep references one level deep from SKILL.md. Deeper nesting loses information.

#### Hands-On: Confidence Scoring

**The real-world design:** The Ideation plugin scores confidence across 5 specific dimensions, each 0-20, requiring 95 total points before advancing. (See: [Ideation](https://nicknisi.com/posts/ideation/))

For the workshop, we use repo-specific dimensions (from [domain-decision.md](domain-decision.md)):

```markdown
## Self-Assessment
Rate each finding:
- Evidence quality (1-10): Is this backed by data or inference?
- Severity accuracy (1-10): Is this actually a problem, or could it be intentional?
- Actionability (1-10): Can someone act on this recommendation immediately?

If any finding scores below 6 on evidence quality, drop it or flag as "needs investigation."
If overall confidence is below 7, state what additional information would help.
```

**What they see change:** The model catches its own drift. Low-evidence findings get dropped automatically. No more speculative noise padding the report.

### Act 3: Why This Scales — Presenter-Led Payoff

You built the primitive. Here's why it matters beyond today.

**The story that opens this act:**

> "Trust isn't a feeling. It's a number."

This act is fast-paced, presenter-led. No new hands-on work. Three proof points only — payoff, not concept pile-up. (See: [Writing My First Evals](https://nicknisi.com/posts/writing-my-first-evals/))

#### 1. Same Skill, Different Audiences

The centerpiece of Act 3. Same Repo Roast findings, three audiences, three outputs:

```markdown
## Audience Detection
Determine the audience from the user's request:
- **Developer** → Roast mode. Be blunt, specific, actionable. Name files. Suggest fixes.
- **Engineering manager** → Assessment mode. Quantify impact. Frame as business cost.
- **New teammate** → Orientation mode. Explain the landscape. Be welcoming, not alarming.
If unclear, ask: "Who's this for — you, your manager, or someone new to the repo?"
```

**Developer:** "Here are the 5 worst hotspots. Start with `handler.ts` — split it into route handlers, auth middleware, and a data layer."

**Manager:** "The auth module has been modified 47 times in 6 months by 8 different contributors. That level of churn usually signals coordination cost."

**New teammate:** "Welcome. 3 areas healthy, 2 hot spots to know about before diving in."

This is the "at scale" moment within a single skill. Same findings, different delivery.

#### 2. Composition — Skills as Building Blocks in Production

Their skill solves one problem. Skills composed together are a system.

**The full-circle story:** The WorkOS CLI's validation-driven retry loop — where the agent gets typecheck errors fed back to it and self-corrects — was born from an Ideation session. The same techniques from today (progressive disclosure, confidence scoring, phased workflow) produced the production system we're showing now. (See: [Ideation](https://nicknisi.com/posts/ideation/))

- The WorkOS CLI: framework detection routes to the right installation skill, which uses validation-driven retry loops to self-correct.
- 15 framework integrations, each a skill composed with others, wired into an agent via the Claude Agent SDK.
- That's production code, shipping today.

#### 3. Measurement Matters Once Skills Are Load-Bearing

Keep this short. Tell the negative-scoring skill story:

> "I built a skill for directory sync and SSO. It looked helpful. Then I ran the eval — same test cases, with and without the skill. The skill made the output *worse*. -12% to -20% delta."

The message: start with the skill-reviewer. Graduate to eval when skills become load-bearing. Even lightweight measurement (before/after on three test cases) beats pure intuition. Anthropic themselves acknowledge vibes still play a role — measurement is the direction, not an absolute.

#### Portability (brief note, not a section)

The same core skill artifact — description, constraints, structure, scripts, workflow — travels across coding agents and teams. What changes is the execution context: coding tools gather evidence directly from the repo; Desktop/chat tools work from pasted or shared context. Same skill file, different input mode. Don't overclaim "works identically everywhere."

### Progression Summary

| Act | Mode | Techniques | What visibly changes |
|-----|------|-----------|---------------------|
| **1: Build the foundation** | Build | Constraints, source of truth, structure, scripts | Generic noise → focused output grounded in real project data |
| **2: Make it smarter** | Build | Phases, per-finding confidence scoring | One-shot → collaborative, self-correcting |
| **3: Why this scales** | Watch | Audience adaptation, composition, eval | One skill → adapted, composed, measured |

### The Through-Line (repeat at each transition)

> "You're leaving with one reusable skill for a real task you do every week."

Say this:
- At the **open**, when framing the promise
- After the **first successful roast** in Act 1
- At the **start of Act 3**, reminding them the skill they built IS the thing we're now showing at scale
- At the **close**, when they install it and share it

### Closing

**Compare & share:** Run roasts, compare outputs across the room (opt-in only — roast the repo, not the people). Install the skill. Share it via git.

**What comes next:** Today was about learning the pattern by building one skill well. The next step is adapting it to another recurring task: gather context, add constraints, structure the output, phase the workflow, define what "good" means.

**Post-workshop accelerators:**
- **skill-creator:** Claude's built-in skill can generate new skills from natural language descriptions. It interviews you, produces a SKILL.md, and runs an evaluation before install. Now that you know the techniques, skill-creator scaffolds the next one in minutes.
- **Transcript reflection:** After running your skill a few times, review past sessions to see which findings were useful, which were ignored, and what constraints should change. The conversation is the most honest record of how the work went.
- **The [handbook](handbook.md):** Full technique library, skill categories, pattern archetypes, and companion reading for going deeper.
