---
name: repo-roast
description: Analyzes repository health.
---

# Repo Roast

## Context
Stale TODOs: !`grep -rn "TODO\|FIXME" . --include="*.*" --exclude-dir=node_modules --exclude-dir=.git | head -20`

## Constraints
- Never be vague — cite specific files and counts as evidence

## Structure
1. One-line health verdict (with overall score out of 10)
2. Top findings, each with: issue, evidence, severity, fix
3. One thing the repo does well
