# Workshop Skill Domain Decision

## The Full Checklist

Every candidate domain must pass all of these to work as the workshop's canonical skill.

| # | Box | Why it matters |
|---|-----|---------------|
| 1 | Technical enough for dev conference | Audience credibility |
| 2 | Scripts feel essential | Key differentiator of the workshop |
| 3 | Clear before/after in <30 seconds | Demo quality, YouTube watchability |
| 4 | Constraints are obvious/relatable | Act 1 personalization |
| 5 | Confidence scoring maps naturally | Act 2 hands-on |
| 6 | Phases make sense | Act 2 hands-on |
| 7 | Every attendee can run it immediately | No setup friction |
| 8 | Works in Claude Code | Primary build environment |
| 9 | Works in Cursor / Codex | Cross-tool portability demo |
| 10 | Works in Claude Desktop / Cowork | The accessibility/scale close |
| 11 | Useful to non-technical teammates | "Skills for everyone" story |
| 12 | No AI slop stigma | Audience won't roll their eyes |
| 13 | Transcript reflection makes sense | Act 2 demo connects |
| 14 | Eval story connects | Act 3 negative-skill anecdote |

## Scorecard

| Box | PR preflight | Code review | PR descriptions | Release notes | Diff explainer |
|-----|:-:|:-:|:-:|:-:|:-:|
| 1. Technical | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2. Scripts essential | ✅✅ | ✅ | ✅ | ✅✅ | ✅ |
| 3. Clear before/after | ✅ | ✅ | ✅ | ✅ | ✅ |
| 4. Constraints obvious | ✅ | ✅ | ✅ | ✅ | ✅ |
| 5. Confidence natural | ✅ | ✅ | ⚠️ | ✅ | ✅ |
| 6. Phases make sense | ✅ | ✅ | ⚠️ | ✅ | ✅ |
| 7. Every attendee can run | ⚠️ needs staged changes | ✅ | ⚠️ needs PR | ✅ any repo with history | ✅ |
| 8. Claude Code | ✅ | ✅ | ✅ | ✅ | ✅ |
| 9. Cursor / Codex | ✅ | ✅ | ✅ | ✅ | ✅ |
| **10. Desktop / Cowork** | ❌ | ❌ | ⚠️ | ✅ | ✅ |
| **11. Non-technical** | ❌ | ❌ | ❌ | ✅ | ✅ |
| 12. No slop stigma | ✅ | ✅ | ✅ | ✅ | ✅ |
| 13. Transcript reflection | ⚠️ | ⚠️ | ⚠️ | ✅ | ✅ |
| 14. Eval connects | ✅ | ✅ | ✅ | ✅ | ✅ |

## Analysis

### Ruled Out

**PR preflight, Code review** — fail boxes 10 and 11. Developer-only tools. The Desktop/Cowork close falls flat — you can't show a PM using a PR preflight skill.

**PR descriptions** — weak on confidence scoring and phases (boxes 5, 6). The output is too short to sustain three acts of technique layering. Also fails box 11.

### Top Contenders

#### Release Notes / Changelog

Checks every box. The strongest candidate because:

- **Before/after is funny.** Raw commit messages vs organized, audience-appropriate changelog. The bad skill just dumps `git log`. The good skill groups by feature area, flags breaking changes, adapts tone to audience.
- **Scripts are essential.** `!git log --oneline origin/main..HEAD`, `!git diff --stat`, `!gh pr list --state merged` — the skill gathers its own input from real git history. Without scripts this skill is useless.
- **Constraints are rich and relatable.** "Never use internal jargon in customer-facing notes." "Always flag breaking changes prominently." "Group by feature area, not by commit order." "Never include merge commits."
- **Confidence maps well.** "Am I sure this is a breaking change? Did I capture every PR? Did I miss a feature area?"
- **Phases are natural.** Phase 1: gather history and categorize changes. Phase 2: draft notes for the detected audience. Phase 3: refine, run constraints checklist.
- **Context detection is the star.** Same skill, three audiences, three outputs:
  - Developer: internal changelog, technical detail, linked PRs
  - Customer: feature-focused, no jargon, breaking changes highlighted
  - Leadership: high-level summary, business impact, metrics
- **Desktop/Cowork works.** PM writes customer-facing release notes in Desktop. Marketing turns them into an announcement in Cowork. No scripts needed — same skill adapts.
- **Every attendee can run it.** Any git repo with history works. No staged changes or open PRs required.
- **No AI slop stigma.** It's extraction and organization, not generation from nothing. The substance comes from git history — the skill structures it.
- **Transcript reflection connects.** The skill learns what release note patterns worked well, what got edited by humans, what style resonated.

#### Diff Explainer

Also checks every box, but weaker because:
- Less natural constraint surface (what are the "never do X" rules for explaining a diff?)
- Phases feel more forced (explain... then explain more?)
- The before/after is less dramatic (both are just text explanations)
- Overlaps heavily with code review, which we already passed on

### Also Considered (Round 2)

These were explored after release notes felt too dry:

**"Catch me up" (repo briefing)** — "What happened while I was on vacation?" Universally relatable, fun framing, but thin on technique meat. Not enough constraint surface or phase depth to sustain 3 acts.

**"WTF is this code?" (code archaeology)** — Given confusing code, dig into git blame and explain WHY it exists. Very fun ("temporary fix from 2 years ago"), but requires attendees to have specific confusing code ready. Hard setup.

**"My week in code" (dev retrospective)** — Evidence-based summary of your own work. Satisfying output, but thin on constraints and technique surface.

---

## Decision: Repo Health Assessment ("Repo Roast")

**Status:** ✅ Locked

### The Concept

A repo health assessment with attitude. The roast is the hook. The assessment is the substance. The business case is the scale story.

Combines two ideas:
- **"Roast my repo"** — fun, specific, devastating findings with evidence
- **"Tech debt lawyer"** — actionable, builds the case for fixing things, useful output

### Why This Wins

1. **Fun factor is high.** Everyone's repo has skeletons. The bad skill says "looks fine." The good skill finds your 2,847-line god file, your 14 stale TODOs, and your README that references `yarn start` when you use pnpm. The room laughs, then goes "oh, that's actually useful."
2. **Scripts ARE the skill.** Without scripts, this is just guessing. With scripts, it's forensic.
3. **Useful artifact.** They leave with a skill they'll actually run on Monday — and the output (a health report with prioritized findings) is something they can send to their manager.
4. **Comparing roasts across the room is entertainment.** Everyone's output is different. People will want to show each other.

### Scorecard

| Box | Repo Health Assessment |
|-----|:-:|
| 1. Technical | ✅ Git archaeology, dependency analysis, test coverage, churn detection |
| 2. Scripts essential | ✅✅ The entire skill IS scripts |
| 3. Clear before/after | ✅ "Looks fine" vs devastating specifics with file names and numbers |
| 4. Constraints obvious | ✅ "Every finding needs evidence." "Never be vague." "Never say rewrite from scratch." |
| 5. Confidence natural | ✅ Per-finding: "Is this intentional or accidental?" Overall: repo health score |
| 6. Phases natural | ✅ Gather evidence → categorize → score severity → recommend |
| 7. Every attendee can run | ✅ Almost any repo; demo repo as fallback for sparse projects |
| 8. Claude Code | ✅ |
| 9. Cursor / Codex | ✅ |
| 10. Desktop / Cowork | ✅ PM checks risk. Manager compares across repos. New hire gets oriented. |
| 11. Non-technical | ✅ Output is a health report / business case, not code |
| 12. No slop | ✅ Analysis and evidence, not content generation |
| 13. Transcript reflection | ✅ Learns which findings mattered, recalibrates severity over time |
| 14. Eval connects | ✅ Does it find real problems? Miss important ones? Are severities calibrated? |

### Scripts

Two tiers: a **universal core** that works in any git repo (the live build), and **language-specific add-ons** (optional upgrades attendees can add if relevant).

#### Universal Core (git-only, works everywhere)

```markdown
## Context
Stale TODOs: !`grep -rn "TODO\|FIXME\|HACK\|WORKAROUND" . --include="*.*" | head -20`
Hotspot files (most churn): !`git log --pretty=format: --name-only --since="6 months ago" | sort | uniq -c | sort -rn | head -10`
Largest tracked files: !`git ls-files | xargs wc -l 2>/dev/null | sort -rn | head -10`
README freshness: !`git log -1 --format="%ar" -- README.md`
Recent contributors: !`git log --format="%an" --since="3 months ago" | sort | uniq -c | sort -rn | head -5`
Commit frequency: !`git log --oneline --since="6 months ago" | wc -l`
```

These commands work in any git repo regardless of language, framework, or tooling. No `src/`, no `.ts`, no `npm`. Every attendee can run them.

#### Language-Specific Add-Ons (optional upgrades)

```markdown
## Optional: JavaScript/TypeScript
Dependency freshness: !`npm outdated 2>/dev/null | head -15`
Test file coverage: !`find . -name "*.ts" ! -name "*.test.*" ! -name "*.spec.*" ! -path "*/node_modules/*" | head -20`

## Optional: Python
Dependency freshness: !`pip list --outdated 2>/dev/null | head -15`
Type coverage: !`find . -name "*.py" ! -name "test_*" ! -path "*/__pycache__/*" | head -20`

## Optional: Go
Dependency freshness: !`go list -m -u all 2>/dev/null | grep "\[" | head -15`
```

Attendees add the ones that match their stack. The core skill works without them.

### Constraints (Act 1 personalization)

Starter constraints attendees can customize:

- Never be vague — cite specific files and counts as evidence
- Every finding must include: what's wrong, evidence, severity, and a recommendation
- Never recommend "rewrite from scratch" — suggest incremental fixes
- Never flag style issues — that's the linter's job
- Prioritize findings by impact, not by how easy they are to find
- Maximum 10 findings. If there are more, keep the most severe.

Personalization surface:
- What do YOU care about? (test coverage? dependency freshness? file size? churn?)
- What's your severity threshold? (some teams tolerate big files, others don't)
- What tone? (blunt roast vs professional assessment vs diplomatic report)

### How It Flows Through the Workshop

#### Act 1: The Roast (fun, hooks them)

**Bad skill:**
```markdown
# Repo Health Check
Look at this repository and tell me how it's doing.
Be helpful and thorough.
```

**Good skill (what they build):**
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

The before/after is the laugh-then-whoa moment. Bad skill: "Your code looks pretty good overall." Good skill: "Health score: 4/10. Your largest file is `handler.ts` at 2,847 lines — it handles auth, routing, AND database queries. You have 14 TODO comments, the oldest from March 2023. Your README was last updated 8 months ago and references `yarn start` but your lockfile is `pnpm-lock.yaml`."

#### Act 2: The Assessment (substance, makes it smart)

**Phases:**
```markdown
## Workflow
Phase 1: Run all context scripts. Summarize raw findings. Present counts and hotspots. Stop.
Phase 2: Categorize findings by type (complexity, coverage, dependencies, documentation, churn). Score severity. Present structured report. Stop.
Phase 3: Based on feedback, build prioritized recommendations. Run constraints checklist. Present final assessment.
Do not skip phases. Each phase requires confirmation before proceeding.
```

**Confidence scoring:**
```markdown
## Self-Assessment
Rate each finding:
- Evidence quality (1-10): Is this backed by data or inference?
- Severity accuracy (1-10): Is this actually a problem, or could it be intentional?
- Actionability (1-10): Can someone act on this recommendation immediately?

If any finding scores below 6 on evidence quality, drop it or flag as "needs investigation."
If overall confidence is below 7, state what additional information would help.
```

**Reflection demo from stage:** Show how the skill learns which findings you cared about (acted on vs ignored) and recalibrates severity over time. "The last three times I ran this, I ignored the TODO findings. The skill learned to deprioritize them for me."

#### Act 3: The Scale Story (context detection is the star)

The tone shift IS the context detection demo. Same skill, same findings, different audiences — and the skill adapts its delivery:

```markdown
## Audience Detection
Determine the audience from the user's request:
- **Developer** → Roast mode. Be blunt, specific, actionable. Name files. Suggest fixes.
- **Engineering manager / tech lead** → Assessment mode. Quantify impact. Frame as business cost. Build the case for prioritization.
- **New teammate / onboarding** → Orientation mode. Explain the landscape. Flag areas to be careful around. Be welcoming, not alarming.
If unclear, ask: "Who's this for — you, your manager, or someone new to the repo?"
```

**Developer (roast):** "Here are the 5 worst hotspots. Start with `handler.ts` — split it into route handlers, auth middleware, and a data layer."

**Engineering manager (assessment):** "The auth module has been modified 47 times in 6 months by 8 different contributors. That level of churn across that many people usually signals coordination cost and merge friction. Recommend investigating sprint impact and considering a focused cleanup."

**New teammate (orientation):** "Welcome to the repo. 3 areas are healthy, 2 are hot spots you should know about before diving in. The auth module is being actively refactored — check with the team before touching it."

This is the "at scale" moment: same skill, three audiences, three outputs.

#### Desktop / Cowork: Honest Framing

In coding tools (Claude Code, Cursor, Codex), the skill gathers evidence directly via scripts.

In Desktop / Cowork, the scripts won't run — there's no repo context. But the skill is still useful in two ways:
1. **From shared output:** A developer runs the roast in Claude Code, shares the health report. A manager opens it in Desktop and asks "reframe this for my planning meeting." The skill adapts the same findings for a new audience.
2. **From pasted context:** Someone pastes a `git log`, a dependency list, or a TODO dump into Desktop. The skill reasons over whatever it's given.

Don't overclaim "same skill works identically everywhere." The honest story: in coding tools, the skill gathers its own evidence. In Desktop, it works from shared or pasted context. Both are valuable. The skill file is the same — the execution context differs.

### The Name

- **Stage framing:** "Repo Roast" — fun, memorable, gets a laugh
- **Durable artifact:** "Repo Health Check" — professional, what you'd actually keep and reuse
- **Slides/marketing:** "Repo Roast: A Health Assessment With Attitude"

The roast tone is the wrapper, not the permanent identity. The audience adaptation (roast vs assessment vs orientation) is built into the skill itself — it's not just naming, it's the Act 3 context detection moment.

### Operational Notes

#### Demo Repo Fallback
Not every attendee will have a meaty repo ready. Prepare:
- A known demo repo with enough history to produce interesting findings (use a WorkOS repo or a popular OSS project)
- Attendees can use their own repo if they want, or follow along with the demo repo
- The demo repo should have: some large files, stale TODOs, churn hotspots, an outdated README — enough skeletons to make the roast land

#### Act 1 Scaffolding Strategy
Act 1 is packed (scripts + constraints + structure + personalization in 20 minutes). Reduce pressure by giving attendees a **starter skill file**, not a blank page:
- Pre-filled with the universal core scripts and default constraints
- Attendees customize 1-2 constraints, adjust tone, maybe add one script
- Nobody authors the whole thing from scratch
- Advanced attendees can go deeper; everyone else still finishes

#### Script Hardening
The universal core commands should handle edge cases gracefully. Add to the skill:
```markdown
If any script returns no output or errors, skip it and note "no data available" for that signal.
```
Known friction points to test:
- `grep --include` behavior varies across GNU/BSD — test on macOS and Linux
- `xargs wc -l` can break on filenames with spaces — consider `git ls-files -z | xargs -0 wc -l` 
- `git log -1 -- README.md` returns nothing if no README exists — that's fine, it's a finding ("no README")
- Hotspot detection may include generated/vendor files — add `--not --path "*/node_modules/*"` or similar exclusions

#### Rehearsal Priorities
- Time Act 1 aggressively — this is the tightest block
- Record fallback demos with the demo repo before the workshop
- Test the universal script set across macOS and Linux (conference laptops vary)
- Have the language-specific add-ons ready but don't demo them unless time permits
