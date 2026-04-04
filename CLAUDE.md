# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Workshop repository for **"Skills at Scale"** — an 80-minute hands-on workshop at AIE Europe 2026 by Nick Nisi & Zack Proser. Teaches developers how to write portable AI skills (markdown files) that work across Claude Code, Cursor, Codex, and custom agents.

## Project Structure

- `workshop.md` — **Live curriculum only.** Workshop arc, timing, acts, presenter stories, exercise structure, starter domains, skeletons. Everything that happens in the room minute by minute.
- `handbook.md` — **Reference/handout for attendees.** Full technique library (12 techniques with sources and first-person stories), skill categories taxonomy (9 from Anthropic), skill pattern archetypes (5), success criteria framework, reference systems, blog post links. Not the live agenda — the take-home companion.
- `domain-decision.md` — Domain analysis and decision. Locked on **"Repo Roast"** (repo health assessment with scripts). Contains the canonical bad/good skill examples, script sets, constraint templates, and phase/confidence designs.
- `rehearsal-review.md` — Speaker/rehearsal review from Codex. Delivery risks, timing targets, presenter choreography, fallback lines, pre-bake requirements. Not curriculum — performance guidance.
- `slides/` — Slidev presentation. Will be reworked from workshop.md. Dark theme, presenter notes on every slide, magic-move animations.

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
- **The technique library lives in `handbook.md`**, not in the live curriculum. `workshop.md` references it but stays focused on what happens in the room.

## Reference Directories

These are added as working directories via `.claude/settings.local.json` for cross-referencing:

- `../cli/main` — WorkOS CLI (15-framework agent-powered installer, Claude Agent SDK, validation retry loops)
- `../skills` — WorkOS skills plugin (40+ reference files, eval framework, router/dispatcher pattern)
- `../case` — Case harness (multi-agent orchestration, rubric-based gating, retrospective self-improvement)

## Research & Notes

- **Live curriculum changes** go in `workshop.md` — timing, acts, presenter stories, exercise flow.
- **Reference material** (technique deep dives, taxonomies, external research findings) goes in `handbook.md`.
- When in doubt: if it happens in the room, it's `workshop.md`. If attendees read it later, it's `handbook.md`.

## Core Promise (repeat throughout)

> "You're leaving with one reusable skill for a real task you do every week."
