---
name: repo-roast
description: Analyzes repository health by running git and file-system scripts to find stale TODOs, churn hotspots, large files, and documentation gaps. Use when the user asks for a repo assessment, health check, code quality review, or tech debt audit. Do NOT use for simple file lookups, git history questions, or code review of specific changes.
---

# Repo Roast

## Context
Stale TODOs: !`grep -rn "TODO\|FIXME\|HACK\|WORKAROUND" . --include="*.*" --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=.git | head -20`
Hotspot files: !`git log --pretty=format: --name-only --since="6 months ago" | grep -v '^$' | sort | uniq -c | sort -rn | head -10`
Largest files: !`git ls-files | xargs wc -l 2>/dev/null | sort -rn | head -10`
README freshness: !`git log -1 --format="%ar" -- README.md`
Recent contributors: !`git log --format="%an" --since="3 months ago" | sort | uniq -c | sort -rn | head -5`

## Constraints
- Never be vague — cite specific files and counts as evidence
- Every finding must include: what's wrong, evidence, severity, recommendation
- Never recommend "rewrite from scratch"
- Maximum 10 findings, ordered by severity
- Prefer script output over assumptions. If evidence from the repo conflicts with prior knowledge, trust the repo.
- Only make findings backed by observed repo evidence

## Structure
1. One-line health verdict (with overall score out of 10)
2. Top findings (max 10), each with: issue, evidence, severity, fix
3. One thing the repo does well
