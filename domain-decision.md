# Workshop Skill Domain Decision

> **Note:** The workshop structure has evolved since this doc was written. See `slides/slides.md` for the current workshop arc and timing. This doc remains the decision record for *why Repo Roast* and the reference for scripts, constraints, and operational prep.

## The Full Checklist

Every candidate domain must pass all of these to work as the workshop's canonical skill.

| # | Box | Why it matters | Used in workshop? |
|---|-----|---------------|-------------------|
| 1 | Technical enough for dev conference | Audience credibility | Yes — Block 2-5 |
| 2 | Scripts feel essential | Key differentiator of the workshop | Yes — Block 4, Block 6 deep dive |
| 3 | Clear before/after in <30 seconds | Demo quality, YouTube watchability | Yes — Block 2, Block 4 |
| 4 | Constraints are obvious/relatable | Block 4 personalization | Yes — Block 4 |
| 5 | Confidence scoring maps naturally | Block 5 hands-on | Yes — Block 5 |
| 6 | Phases make sense | Block 5 hands-on | Yes — Block 5 |
| 7 | Every attendee can run it immediately | No setup friction | Yes — Block 3 |
| 8 | Works in Claude Code | Primary build environment | Yes — Block 3-5 |
| 9 | Works in Cursor / Codex | Cross-tool portability | Yes — Block 6 portability mention |
| 10 | Works in Claude Desktop / Web | Portability story | Mentioned briefly — Block 6 |
| 11 | Useful to non-technical teammates | Portability story | Not a focus — cut from workshop arc |
| 12 | No AI slop stigma | Audience won't roll their eyes | Yes — throughout |
| 13 | Transcript reflection makes sense | Reference material | No — moved to handbook only |
| 14 | Eval story connects | Block 6 measurement quick hit | Yes — Block 6 Part 3 |

## Scorecard

> Historical: used during domain selection. Repo Roast was chosen. See analysis below.

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
| 10. Desktop / Web | ❌ | ❌ | ⚠️ | ✅ | ✅ |
| 11. Non-technical | ❌ | ❌ | ❌ | ✅ | ✅ |
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

Two tiers that evolve through the workshop: a **starter set** (Block 4, checkpoint 1) and an **enhanced set** (Block 5, checkpoint 2). Plus **language-specific add-ons** attendees can optionally add.

#### Starter Scripts (checkpoint 1 — Block 4)

Simple, git-only, works everywhere. No filtering beyond basic exclusions.

```markdown
## Context
Stale TODOs: !`grep -rn "TODO\|FIXME\|HACK\|WORKAROUND" . --include="*.*" --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=.git | head -20`
Hotspot files: !`git log --pretty=format: --name-only --since="6 months ago" | grep -v '^$' | sort | uniq -c | sort -rn | head -10`
Largest files: !`git ls-files | xargs wc -l 2>/dev/null | sort -rn | head -10`
README freshness: !`git log -1 --format="%ar" -- README.md`
Recent contributors: !`git log --format="%an" --since="3 months ago" | sort | uniq -c | sort -rn | head -5`
```

#### Enhanced Scripts (checkpoint 2 — Block 5)

Smarter filtering (pathspecs, bot exclusion, noise reduction) plus three new signals. Better evidence quality feeds into confidence scoring.

```markdown
## Context
Stale TODOs: !`git ls-files -- '*.ts' '*.tsx' '*.js' '*.jsx' '*.py' '*.rb' '*.go' '*.rs' '*.md' ':!tests/fixtures' ':!vendor' | xargs grep -n "TODO\|FIXME\|HACK\|WORKAROUND" 2>/dev/null | head -20`
Hotspot files: !`git log --pretty=format: --name-only --since="6 months ago" | grep -v '^$' | grep -v -E '(CHANGELOG|pnpm-lock|\.release-please|package\.json$)' | sort | uniq -c | sort -rn | head -10`
Largest files: !`git ls-files -- ':!tests/fixtures' ':!vendor' ':!*.lock' ':!pnpm-lock.yaml' ':!package-lock.json' | xargs wc -l 2>/dev/null | sort -rn | head -10`
README freshness: !`git log -1 --format="%ar" -- README.md`
Recent contributors: !`git log --format="%an" --since="3 months ago" | grep -v '\[bot\]' | sort | uniq -c | sort -rn | head -5`
Commit frequency: !`git log --oneline --since="6 months ago" | wc -l`
Test file ratio: !`echo "test files:"; git ls-files | grep -ciE '(test|spec)'; echo "total files:"; git ls-files | wc -l`
Dependency lockfile: !`found=$(ls -1 package-lock.json pnpm-lock.yaml yarn.lock bun.lockb Gemfile.lock go.sum Cargo.lock poetry.lock requirements.txt 2>/dev/null); echo "${found:-none found}"`

If any script returns no output or errors, skip that signal and note "no data available." Do not guess.
```

**What changes between starter → enhanced:**
- TODO grep switches from `grep --include` (BSD/GNU portability issues) to `git ls-files` piped to `xargs grep` (portable, filtered by pathspec)
- Hotspots filter out CHANGELOG, lockfiles, release-please manifests (noise reduction)
- Largest files filter out test fixtures, vendor, lockfiles
- Contributors filter out bot accounts
- Three new scripts: commit frequency, test file ratio, dependency lockfile detection
- Error handling note added

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

### Constraints (Block 4 personalization)

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

> See `outline.md` for the full workshop arc. This section documents how the Repo Roast domain maps to each block.

#### Block 2: Bad vs Good Output (the hook)

**Bad skill output:** "Your code looks pretty good overall."

**Good skill output:** "Health score: 4/10. Your largest file is `handler.ts` at 2,847 lines — it handles auth, routing, AND database queries. You have 14 TODO comments, the oldest from March 2023. Your README was last updated 8 months ago and references `yarn start` but your lockfile is `pnpm-lock.yaml`."

Show the *output* contrast first. Reveal the skill code later in Block 4.

#### Block 4: Build the Foundation (constraints + scripts)

Attendees open the starter skill and customize constraints, description, tone, and optionally scripts. The bad/good skill examples below are the reference material for what they're building toward.

**Bad skill (checkpoint 0):**
```markdown
# Repo Health Check
Look at this repository and tell me how it's doing.
Be helpful and thorough.
```

**Good skill (checkpoint 1):**
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

#### Block 5: Make It Smarter (phases + confidence)

**Phases (checkpoint 2):**
```markdown
## Workflow
Phase 1: Run all context scripts. Summarize raw findings. Present counts and hotspots. Stop.
Phase 2: Categorize findings by type (complexity, coverage, dependencies, documentation, churn). Score severity. Present structured report. Stop.
Phase 3: Based on feedback, build prioritized recommendations. Run constraints checklist. Present final assessment.
Do not skip phases. Each phase requires confirmation before proceeding.
```

**Confidence scoring (checkpoint 2):**
```markdown
## Self-Assessment
Rate each finding:
- Evidence quality (1-10): Is this backed by data or inference?
- Severity accuracy (1-10): Is this actually a problem, or could it be intentional?
- Actionability (1-10): Can someone act on this recommendation immediately?

If any finding scores below 6 on evidence quality, drop it or flag as "needs investigation."
If overall confidence is below 7, state what additional information would help.
```

#### Block 6: Skills Beyond the Editor

The portability story. Same skill file works across the ecosystem:
- **Editor tools** (Claude Code, Codex, Cursor) — full script execution, evidence-driven
- **Claude Desktop, Claude for Web** — no scripts, but constraints and structure still shape output from pasted context
- **Claude Agent SDK, Pi** — skills as the brains of programmatic agents and product workflows
- **CI pipelines** — automatic skill execution on push

Honest framing: in coding tools, the skill gathers its own evidence via scripts. In Desktop/Web, it works from shared or pasted context. The skill file is the same — the execution context differs. Don't overclaim identical behavior everywhere.

Also includes a scripts deep dive with a mini-exercise, and a quick measurement hit (negative-scoring skill story).

### The Name

- **Stage framing:** "Repo Roast" — fun, memorable, gets a laugh
- **Durable artifact:** "Repo Health Check" — professional, what you'd actually keep and reuse
- **Slides/marketing:** "Repo Roast: A Health Assessment With Attitude"

The roast tone is the wrapper, not the permanent identity.

### Operational Notes

#### Demo Repo Fallback
Not every attendee will have a meaty repo ready. Prepare:
- A known demo repo with enough history to produce interesting findings (use a WorkOS repo or a popular OSS project)
- Attendees can use their own repo if they want, or follow along with the demo repo
- The demo repo should have: some large files, stale TODOs, churn hotspots, an outdated README — enough skeletons to make the roast land

#### Block 4 Scaffolding Strategy
Block 4 is packed (scripts + constraints + structure + personalization in 20 minutes). Reduce pressure by giving attendees a **starter skill file**, not a blank page:
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
- Time Block 4 aggressively — this is the tightest block
- Record fallback demos with the demo repo before the workshop
- Test the universal script set across macOS and Linux (conference laptops vary)
- Have the language-specific add-ons ready but don't demo them unless time permits
