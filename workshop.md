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

Most people don't know this primitive exists. In this hands-on workshop, you'll write real skills, test them live, and see how one file can power Claude.ai, Claude Code, Cursor, and Codex without changing a line.

Then we'll go deeper. You'll see how the WorkOS CLI uses this same pattern to power 15 framework
integrations — each one a skill composed with others, wired into an agent that installs and configures
AuthKit in under 60 seconds. That's not a demo. That's production code, shipping today.

What you'll do:

Write 2+ skills for tasks you actually do at work
Install and test them across AI tools in real time
Learn the craft of good skill writing — specificity, constraints, composability
See how skills compose and scale inside a real CLI powered by the Claude Agent SDK


What you'll leave with:

Working skills installed in your AI tools, ready to use Monday morning
A repeatable pattern for turning any recurring task into a portable skill
The mental model for when a skill is enough and when you need a full agent


No repos to clone. No dependencies to install. Bring a laptop with Claude Code or Claude.ai and something you're tired of doing manually.

---

## Workshop Arc (80 minutes)

### Core Promise

**You're leaving with one reusable skill for a real task you do every week.**

Technique-first workshop. Each act layers techniques onto a single skill. The domain is the attendee's choice — we teach the guitar, not the song.

| Block | Time | Mode | What happens |
|-------|------|------|-------------|
| **Open: The problem** | 5 min | Watch | You prompt the same way, for the same tasks, over and over. Show the pain. |
| **Act 1: Build the foundation** | 20 min | **Build** | Bad skill vs good skill. Attendees pick a domain, write a constrained skill with script calls and their style baked in. |
| **Act 2: Make it smarter** | 25 min | **Build** + Demo | Add phased workflow + confidence scoring (hands-on). Then transcript reflection demo from stage. |
| **Act 3: Why this scales** | 20 min | Watch | Eval (skill-reviewer live on an audience skill), composition (WorkOS CLI), portability, Claude Desktop. |
| **Close: Share & install** | 10 min | **Build** | Install across tools. Push to repo. Pull a friend's. Leave with an artifact. |

### What's taught vs what's referenced

Not everything is live curriculum. The [handbook](handbook.md) is the full reference — a handout, a blog post, a companion doc. Live, we teach a subset:

| Delivery | Techniques |
|----------|-----------|
| **Hands-on (attendees build)** | Constraints > instructions, source of truth, structure, scripts (inline `!` calls), progressive disclosure, confidence scoring |
| **Stage demo (attendees watch)** | Transcript reflection / memory |
| **Proof / scale-up (presenter-led)** | Context detection, eval-driven improvement, composition, cross-tool portability, Claude Desktop / Cowork, self-improving systems |

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

## The Exercise: Technique-First, Domain-Second

We teach the guitar, not the song. Each act teaches transferable techniques. Attendees apply them to whatever domain fits their work. The skill is a vehicle for learning — the techniques are what they take home.

### Why Rails Still Matter

- **80 minutes is brutal.** We provide the skeleton and starter domains to prevent decision paralysis.
- **Debugging from stage requires a shared structure.** Everyone's skill has the same sections (constraints, workflow, self-assessment) even if the domain differs.
- **The recording needs a through-line.** The YouTube arc is: naive skill → constrained → self-aware → part of a system. That story works regardless of domain.

### Starter Domains (Pick One)

We provide 3-4 starter skeletons. Each has the same structure (constraints, workflow, self-assessment) with domain-specific defaults. Attendees pick one and customize, or bring their own domain using the same skeleton. For the full skill categories taxonomy (9 categories from Anthropic), see the [handbook](handbook.md#skill-categories-anthropics-taxonomy).

| Domain | Why it works | Scripts it would use | Personalization surface |
|--------|-------------|---------------------|----------------------|
| **PR preflight** | Technical, everyone ships code. Scripts are essential. | `git diff`, `npm run lint`, `npm test`, `git log` | What to flag vs ignore, severity thresholds, ship/no-ship criteria |
| **Code review** | Everyone does it. Constraints and confidence scoring are natural. | `git diff origin/main`, `git log --oneline -10` | Review style (terse vs pedagogical), what to flag, severity priorities |
| **PR descriptions** | Everyone hates writing these. Fast to demo. Clear before/after. | `git diff --stat`, `git log --oneline origin/main..HEAD` | Level of detail, what context to include, tone |
| **Task breakdown** | Given a ticket, produce implementable subtasks. High value. | `find src/ -name "*.ts"`, `cat package.json` | How granular, what metadata, framework preferences |
| **Bring your own** | Same skeleton, any domain. | Whatever fits | Everything |

The stage demo uses ONE domain throughout (TBD — whatever demos fastest and clearest). Attendees follow along in their chosen domain.

### Act 1: Build the Foundation — Constraints & Structure

**Technique focus:** Constraints > instructions, source of truth discipline, structure, scripts.

**The story that opens this act:**

> "Instructions decay, enforcement persists."

From building Case — a multi-agent harness for 20+ repos — I learned this the hard way. Early versions gave agents prose instructions for how to behave. Context windows compressed, agents forgot, and they started skipping phases and creating fake evidence. The fix wasn't better instructions. It was mechanical constraints — things agents *can't* ignore because they're structural, not advisory.

That's the same principle behind a good skill. Don't tell the model what to do. Tell it what it must never do, and point it at the real source of truth. (See: [Case Statement](https://nicknisi.com/posts/case-statement/))

**Before they write anything — the description matters:** The skill's name and description are the only things loaded at startup. Claude uses the description to decide whether to activate a skill from potentially 100+ available. A vague description ("helps with repos") means the skill never fires. A good description includes what it does AND when to use it: "Analyzes repository health by running git and file-system scripts. Use when the user asks for a repo assessment, health check, or code quality review." You can also add negative triggers to prevent over-firing: "Do NOT use for simple file lookups or general git questions." Teach this as a 2-minute beat before they start writing.

**Debug it by asking Claude.** After writing the description, have attendees ask Claude: "When would you use the [skill name] skill?" Claude quotes the description back and explains its reasoning. If it can't articulate when to use the skill, the description needs work. If it fires on things it shouldn't, add negative triggers. This is a 30-second exercise that turns description-writing from abstract to testable. When in doubt about whether your skill works, just ask the model — they're surprisingly good at debugging themselves.

**What they start with:** A bad skill — vague, positive instructions, no guardrails.

**What they build:** A constrained skill with their style and priorities baked in.

**The skeleton every domain shares:**

```markdown
# [Skill Name]

## Context (gathered via scripts)
[What real data does this skill need before it can act?]
Current branch: !`git branch --show-current`
Recent changes: !`git diff --stat origin/main`
[Add domain-specific scripts: lint output, test results, file listings, etc.]

## Style
[How should the output sound/feel? What's your approach to this task?]

## Constraints
[What should it NEVER do? What are the known failure modes?]
- Never...
- Never...
- Always...

## Source of Truth
[What should it read/fetch before acting? Where does ground truth live?]
Read the following before starting: [URL or file reference]
If this file conflicts with fetched sources, follow the sources.

## Structure
[What's the output format? What sections, in what order?]
```

**Key teaching moments:**

- **Scripts:** The `!` backtick syntax runs a shell command inline and injects its output into the skill. This is what makes skills more than prompt templates. The skill now gathers its own context from the real environment — it doesn't guess, it checks.
- **Constraints > instructions:** "The specificity is the skill." Don't tell the model what to do. Tell it what it must never do. But watch the railroading trap — over-constraining kills adaptability. Tight on fragile operations, loose on creative work. (See [handbook](handbook.md#1-constraints--instructions-degrees-of-freedom) for the full degrees-of-freedom framework.)
- **Most public skills are shallow** — viral threads with millions of views share names and one-liners, no constraints, no scripts, no phases. That's the gap this workshop fills.

**What they see change:** Run the same prompt with the bad skill and the constrained skill. The difference is immediate — generic noise vs focused output grounded in real data from their actual project.

**Where they make it theirs:**
- Their scripts — what context does the skill need to gather? (`git log`, `npm test`, `ls src/`, custom commands)
- Their constraints — what do they never want to see?
- Their style — terse or detailed? Formal or casual?
- Their source of truth — what docs, repos, or examples should it always reference?

### Act 2: Make It Smarter — Phases + Confidence + Reflection Demo

**Hands-on techniques:** Progressive disclosure, confidence scoring.
**Stage demo:** Transcript reflection / memory.

**The story that opens this act:**

> "LLMs are good at reasoning about code. They're bad at being state machines."

Another lesson from Case. Early pipeline versions let agents decide their own next steps. They skipped phases, retried excessively, made up their own workflows. The fix: deterministic flow control outside the model, structured self-assessment inside. That's what we're adding now — phases the model follows, and a self-check it runs before presenting. (See: [Case Statement](https://nicknisi.com/posts/case-statement/))

Attendees add two capabilities to the same skill, then watch a demo of a third.

#### Hands-On: Progressive Disclosure
Instead of one-shotting output, the skill works in phases:

```markdown
## Workflow
Phase 1: [Quick assessment / triage / outline]. Stop and present.
Phase 2: [Full output based on approved Phase 1]. Stop and present.
Phase 3: [Revise based on feedback. Run constraints checklist]. Present final.
Do not skip phases. Each phase requires confirmation before proceeding.
```

**What they see change:** Output becomes collaborative. They steer after Phase 1 instead of accepting whatever comes out.

**Anti-pattern to mention:** When splitting into reference files later, keep references one level deep from SKILL.md. Deeper nesting loses information.

#### Hands-On: Confidence Scoring

**The real-world design:** The Ideation plugin scores confidence across 5 specific dimensions (problem clarity, goal definition, success criteria, scope boundaries, internal consistency), each 0-20, requiring 95 total points before advancing. When scores fall short, it asks targeted clarifying questions — not open-ended "what do you mean?" but concrete options. (See: [Ideation](https://nicknisi.com/posts/ideation/))

For the workshop, we simplify this into a pattern they can adapt to any domain:

```markdown
## Self-Assessment
After completing your output, rate across these dimensions:
- Constraint compliance (1-10): Did you violate any constraint?
- Completeness (1-10): Did you address everything asked for?
- Confidence (1-10): How sure are you this is correct/good?

If any score is below 7, revise before presenting. Show scores to the user.
If total is below 21, ask one targeted clarifying question before revising.
```

**What they see change:** The model catches its own drift. Weak output gets revised automatically. This is the simplest possible feedback loop — zero infrastructure, dramatic improvement in reliability. And they can make it more sophisticated later: add domain-specific dimensions, raise the threshold, require specific evidence for each score.

#### Stage Demo: Transcript Reflection

This one is shown from stage, not built. It's the "oh wow" moment.

**The real story:** When writing the blog post about building evals, I had Claude review the transcripts from the sessions where I actually built them. The transcripts surfaced anecdotes I'd forgotten — dead ends, surprising failures, moments where the approach changed. Those became the most compelling parts of the post. The conversation was the most honest record of how the work actually went. (See: [Writing My First Evals](https://nicknisi.com/posts/writing-my-first-evals/))

Show this live: an agent transcript from a previous session, then a skill that reads it and extracts decisions, mistakes, and patterns.

Then show Claude Code's auto-memory: every session already teaches the next session something. The tool persists learnings to memory files (`~/.claude/projects/*/memory/`) across sessions — the self-improving system pattern at the individual level. You don't even need a skill for this. It's already happening.

**Why demo, not hands-on:** This technique requires having a past transcript to reflect on. The attendees just started — they don't have one yet. But after running their skill a few times post-workshop, they will. Plant the seed now; they'll harvest it later.

The message: most people treat every AI session as stateless. The unlock is realizing transcripts and memory are a flywheel — work → reflect → extract → apply → better work.

### Act 3: Why This Scales — Presenter-Led Payoff

You built the primitive. Here's why it matters beyond today.

**The story that opens this act:**

> "Trust isn't a feeling. It's a number."

This act is fast-paced, presenter-led. No new hands-on work. The goal: show that the techniques they just learned are the same ones powering production systems. Frame as "here's where this goes," not "here are five more concepts." (See: [Writing My First Evals](https://nicknisi.com/posts/writing-my-first-evals/))

#### Live: Eval on an Audience Skill

Pull up someone's skill from the room. Run the skill-reviewer on it live. Get structured feedback, show where it's strong and weak.

**Then tell the negative-scoring skill story.** This is the moment that makes the room go quiet:

> "I built a skill for directory sync and SSO. It looked helpful. It contained accurate information. I was proud of it. Then I ran the eval — same test cases, with and without the skill. The skill made the output *worse*. Consistently. -12% to -20% delta. The skill was teaching correct information but omitting critical context, and the model was scoring lower because of it."

> "If the LLM already knows the answer, your skill is dead weight. If your skill adds noise, it's actively harmful. You can't know which one it is without measuring."

Show the production eval framework briefly: 42 test cases, with/without comparison, composite scoring across 7 dimensions, hard gates on regression. Then the scorer bug story — 13 apparent regressions that were actually scorer bugs. Even the eval can be wrong. That's why you calibrate against human judgment.

The message: start with the skill-reviewer today. Graduate to eval when skills become load-bearing. Anthropic themselves acknowledge that "there will be an element of vibes-based assessment" — measurement is the direction, not an absolute. But even lightweight measurement beats pure intuition. A before/after comparison on three test cases is better than "it feels right."

#### Show: Context Detection

Quick demo of context detection as a technique they can add later. The skill adapts to what it finds — different input types, different environments, different audiences — without being rewritten.

Show the WorkOS CLI doing this at scale: 15 frameworks detected automatically, the right skill activated for each one. Same pattern, production grade.

#### Show: Composition — Skills as Building Blocks

Their skill solves one problem. Skills composed together are a system.

**The full-circle story:** The WorkOS CLI's validation-driven retry loop — where the agent gets typecheck errors fed back to it and self-corrects — was born from an Ideation session. Rambling input → confidence gate → codebase exploration → contract → three-phase spec → implementation. The same techniques from today's workshop (progressive disclosure, confidence scoring, phased workflow) produced the production system we're now showing as proof. (See: [Ideation](https://nicknisi.com/posts/ideation/))

- The WorkOS CLI: framework detection routes to the right installation skill, which uses validation-driven retry loops to self-correct.
- 15 framework integrations, each a skill composed with others, wired into an agent via the Claude Agent SDK.
- That's production code, shipping today.

#### Note: Skills Are Folders, Not Just Files

In the workshop, attendees build a single SKILL.md. But production skills are folders — scripts, reference files, config, assets. On-demand hooks are a power feature: a skill can register session-scoped hooks that only activate when invoked (e.g., `/careful` blocks destructive commands, `/freeze` blocks edits outside a directory). The single-file skill they build today is the seed. The folder pattern is where it grows.

#### Note: Model-Dependent Behavior

A skill that works perfectly on Opus might need more guardrails on Haiku. If attendees plan to share skills across teams using different models or tools, they should test with all target models. Quick awareness note — "works for me" isn't the same as "works everywhere."

#### Show: Cross-Tool Portability

Cross-tool portability is the proven engagement hook — a viral thread listing 20 shallow skills for "Claude, ChatGPT & Gemini" hit 3.2M views. The "write once, run everywhere" promise is what the audience cares about most. Our version is deeper: not just "same file works everywhere" but "same *well-crafted* file works everywhere."

Three layers of scale — the payoff of the title:

1. **Personal scale:** Same skill file running in Claude Code → Cursor → Codex. No changes.
2. **Team scale:** Push to a repo, teammate pulls it. Works in their tool.
3. **Production scale:** Skills composed inside agents. Installed via `workos skills install` across all detected agents automatically.

#### Show: Claude Desktop / Cowork — Skills for Everyone

Not everyone on a team writes code.

- Open Claude Desktop. The same skill is there. It works.
- A non-technical teammate uses a skill without touching a terminal or GitHub.
- Claude Cowork extends this — skills in a collaborative context, not just solo.

Same skill, from terminal to desktop to team to production.

### Progression Summary

| Act | Mode | Techniques | What visibly changes |
|-----|------|-----------|---------------------|
| **1: Build the foundation** | Build | Constraints, source of truth, structure, scripts | Generic noise → focused output grounded in real project data |
| **2: Make it smarter** | Build + Demo | Phases, confidence scoring, transcript reflection (demo) | One-shot → collaborative, self-correcting. Seeds the memory flywheel. |
| **3: Why this scales** | Watch | Context detection, eval, composition, portability, Desktop | Single skill → measured, composed, portable, accessible system |

### The Through-Line (repeat at each transition)

> "You're leaving with one reusable skill for a real task you do every week."

Say this:
- At the **open**, when framing the promise
- At the **start of Act 2**, when they already have a working skill and are about to make it better
- At the **start of Act 3**, reminding them the skill they built IS the thing we're now showing at scale
- At the **close**, when they install it and share it

### Post-Workshop Accelerator: skill-creator

Mention in the closing: Claude's built-in `skill-creator` skill can generate skills from natural language descriptions. It interviews you, produces a SKILL.md with frontmatter, and runs an evaluation before you install. It's not a replacement for understanding the techniques (constraints, scripts, phases, confidence) — it's an accelerator for applying them faster. "Now that you know what makes a good skill, skill-creator can scaffold the next one in minutes."
