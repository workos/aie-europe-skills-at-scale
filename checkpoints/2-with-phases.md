---
name: repo-roast
description: Analyzes repository health by running git and file-system scripts to find stale TODOs, churn hotspots, large files, and documentation gaps. Use when the user asks for a repo assessment, health check, code quality review, or tech debt audit. Do NOT use for simple file lookups, git history questions, or code review of specific changes.
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
Phase 1: Run all context scripts. Summarize raw findings. Present counts and hotspots. Stop.
Phase 2: Categorize findings by type (complexity, coverage, dependencies, documentation, churn). Score severity. Run self-assessment. Present structured report. Stop.
Phase 3: Based on feedback, build prioritized recommendations. Run constraints checklist. Present final assessment.
Do not skip phases. Each phase requires confirmation before proceeding.

## Self-Assessment
Rate each finding before presenting:
- Evidence quality (1-10): Is this backed by script output or inference?
- Severity accuracy (1-10): Is this actually a problem, or could it be intentional?
- Actionability (1-10): Can someone act on this recommendation today?

If any finding scores below 6 on evidence quality, drop it or flag as "needs investigation."
Show the scores for each finding so the reader can see your reasoning.

## Structure
1. One-line health verdict (with overall score out of 10)
2. Top findings (max 10), each with: issue, evidence, severity, fix
3. Confidence summary (how many findings were high-confidence vs flagged)
4. One thing the repo does well
