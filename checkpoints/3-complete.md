---
name: repo-roast
description: Analyzes repository health by running git and file-system scripts to find stale TODOs, churn hotspots, large files, and documentation gaps. Use when the user asks for a repo assessment, health check, code quality review, tech debt audit, or wants to understand the state of a codebase. Also triggers on casual requests like "how's this repo looking", "what's the state of this codebase", "should I be worried about tech debt", "give me the lay of the land", "can you audit this before I hand it off", or "what should I know before contributing to this repo." Do NOT use for simple file lookups, git history questions, or code review of specific changes.
---

# Repo Roast

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

## Constraints
- Never be vague — cite specific files and counts as evidence
- Every finding must include: what's wrong, evidence, severity, recommendation
- Never recommend "rewrite from scratch" — suggest incremental fixes
- Never flag style issues — that's the linter's job
- Maximum 10 findings, ordered by severity
- Prefer script output over assumptions. If evidence from the repo conflicts with prior knowledge, trust the repo.
- Only make findings backed by observed repo evidence
- Prioritize by impact, not by how easy the finding was to discover

## Workflow
Work through these phases internally before presenting the final report. Internal phasing lets you filter weak findings before presenting, so the user sees only high-confidence results.
1. Run all context scripts. Gather raw data.
2. Categorize findings by type (complexity, coverage, dependencies, documentation, churn). Score severity. Run self-assessment. Drop or flag weak findings.
3. Build prioritized recommendations. Adapt output to the detected audience. Run constraints checklist.

Present the final assessment as one complete report. Only stop for user input if overall confidence is low (more than half of findings score below 7 on evidence quality) and you need clarification about the repo's context.

## Self-Assessment
Rate each finding before presenting:
- Evidence quality (1-10): Is this backed by script output or inference?
- Severity accuracy (1-10): Is this actually a problem, or could it be intentional?
- Actionability (1-10): Can someone act on this recommendation today?

If any finding scores below 6 on evidence quality, drop it or flag as "needs investigation."
Show the scores for each finding so the reader can see your reasoning.

## Audience Detection
Determine the audience from the user's request and adapt the final output in Phase 3:
- **Developer** — Roast mode. Be blunt, specific, actionable. Name files and line counts. Suggest concrete fixes.
- **Engineering manager** — Assessment mode. Quantify impact. Frame findings as business cost (coordination overhead, onboarding friction, incident risk). Build the case for prioritization.
- **New teammate** — Orientation mode. Explain the landscape. Flag areas to be careful around. Be welcoming, not alarming.
If unclear, default to developer mode. If the user says "for my manager" or "for onboarding," switch.

## Scoring Guide
- 9-10: No significant findings. Well-maintained.
- 7-8: Minor issues. Healthy with some debt.
- 5-6: Several meaningful issues. Needs attention.
- 3-4: Systemic problems across multiple dimensions. Active risk.
- 1-2: Critical issues. Immediate action needed.

## Structure
1. One-line health verdict (with overall score out of 10)
2. Top findings (max 10), each with: issue, evidence, severity, fix, and confidence scores
3. Confidence summary (how many findings were high-confidence vs flagged)
4. One thing the repo does well
5. Suggested next action (the single highest-leverage fix)

**Example finding (developer mode):**
**Issue:** God file concentrating too many responsibilities
**Evidence:** `src/bin.ts` — 2,314 lines, modified 18 times in 6 months by 4 contributors
**Severity:** High
**Confidence:** Evidence 9/10, Severity 8/10, Actionability 8/10
**Fix:** Extract the CLI argument parsing (lines 1-200) and command routing (lines 800-1400) into separate modules. Start with command routing — it has the most churn and will reduce merge conflicts.

**Same finding adapted for engineering manager:**
**Issue:** CLI entrypoint is a coordination bottleneck
**Evidence:** `src/bin.ts` — 2,314 lines, touched 18 times in 6 months by 4 contributors. At this size and churn rate, most changes to the CLI risk merge conflicts and require understanding the full file.
**Severity:** High
**Impact:** Onboarding friction (new contributors must understand 2,300 lines before making changes), merge conflict overhead (4 people editing one file), and incident risk (a bad change anywhere in the file affects all CLI commands).
**Recommendation:** Prioritize splitting this file in the next sprint. Estimated effort: 1-2 days. Reduces merge conflicts and unblocks parallel work on CLI features.
