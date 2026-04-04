# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Workshop repository for **"Skills at Scale"** — an 80-minute hands-on workshop at AIE Europe 2026 by Nick Nisi & Zack Proser. Teaches developers how to write portable AI skills (markdown files) that work across Claude Code, Cursor, Codex, and custom agents.

## Project Structure

- `workshop.md` — Full curriculum: arc, technique library (11 techniques), exercise structure, presenter stories, reference systems
- `domain-decision.md` — Domain analysis and decision. Locked on **"Repo Roast"** (repo health assessment with scripts). Contains the canonical bad/good skill examples, script sets, constraint templates, and phase/confidence designs
- `slides/` — Slidev presentation. Dark theme, presenter notes on every slide, magic-move animations

## Slides Development

```bash
cd slides && pnpm dev      # Dev server at http://localhost:3030
cd slides && pnpm build    # Build static SPA
cd slides && pnpm export   # Export to PDF (needs playwright-chromium)
```

Slides are a single `slides.md` file using Slidev markdown syntax. `---` separates slides. HTML comments (`<!-- -->`) are presenter notes.

## Workshop Design Decisions

- **Technique-first, domain-second.** We teach transferable patterns, not a specific skill domain. The "Repo Roast" is a vehicle for learning.
- **One skill, three acts.** Attendees build one skill progressively: Act 1 (constraints + scripts), Act 2 (phases + confidence), Act 3 (presenter-led proof of scale).
- **Scripts are foundational.** The `!` backtick syntax (inline shell execution in skills) is taught in Act 1, not as an add-on. Universal git-only core scripts that work in any repo.
- **Five techniques hands-on, rest as reference.** Constraints, source of truth, structure, progressive disclosure, confidence scoring are built live. Transcript reflection is demoed from stage. Everything else (eval, composition, portability, Desktop) is presenter-led proof.
- **The technique library in workshop.md is a handout/reference**, not the live agenda.

## Reference Directories

These are added as working directories via `.claude/settings.local.json` for cross-referencing:

- `../cli/main` — WorkOS CLI (15-framework agent-powered installer, Claude Agent SDK, validation retry loops)
- `../skills` — WorkOS skills plugin (40+ reference files, eval framework, router/dispatcher pattern)
- `../case` — Case harness (multi-agent orchestration, rubric-based gating, retrospective self-improvement)

## Research & Notes

All research findings, brainstorming, and workshop refinements should be added to `workshop.md`. It is the single source of truth for workshop content and curriculum decisions.

## Core Promise (repeat throughout)

> "You're leaving with one reusable skill for a real task you do every week."
