# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Workshop repository for **"Skills at Scale"** — an 80-minute hands-on workshop at AIE Europe 2026 by Nick Nisi & Zack Proser. Teaches developers how to write portable AI skills (markdown files) that work across Claude Code, Cursor, Codex, and custom agents.

## Project Structure

- `README.md` — **Repo landing page.** Quick start for attendees, sharing/review instructions for presenters, worker deployment docs.
- `GUIDE.md` — **Attendee step-by-step guide.** Setup instructions, numbered steps for each section, catch-up checkpoints. Self-contained — works for live attendees and YouTube viewers.
- `workshop.md` — **Presenter notes only.** Workshop arc, timing, presenter stories, exercise structure, side quest topics, dead air mitigations. Not for attendees — for Nick and Zack.
- `handbook.md` — **Reference/handout for attendees.** Full technique library (12 techniques with sources and first-person stories), skill categories taxonomy (9 from Anthropic), skill pattern archetypes (5), success criteria framework, reference systems, blog post links. Not the live agenda — the take-home companion.
- `domain-decision.md` — Domain analysis and decision. Locked on **"Repo Roast"** (repo health assessment with scripts). Contains the canonical bad/good skill examples, script sets, constraint templates, and phase/confidence designs.
- `rehearsal-checklist.md` — Timing checkpoints, per-block checklists, trim/never-trim guidance, fallback plans.
- `outline.md` — **Superseded by `slides/slides.md`.** Historical reference for original block structure and discussion topic planning.
- `checkpoints/` — Skill progression snapshots (0-bad, 1-starter, 2-with-phases, 3-complete). Attendees use `./setup.sh --checkpoint N` to catch up.
- `.claude/skills/repo-roast/` — The starter skill file attendees edit during the workshop. Auto-discovered by Claude Code.
- `slides/` — Slidev presentation. Light theme, presenter notes on every slide, v-click animations.
- `setup.sh` — Symlinks the skill for Claude Code / Codex; also handles `--checkpoint N` to load progression snapshots.
- `share.sh` / `review.sh` — Attendee skill sharing and presenter review scripts (backed by Cloudflare Worker in `worker/`).
- `worker/` — Cloudflare Worker + KV for the skill-sharing system.

## Slides Development

```bash
cd slides && pnpm dev      # Dev server at http://localhost:3030
cd slides && pnpm build    # Build static SPA
cd slides && pnpm export   # Export to PDF (needs playwright-chromium)
```

Slides are a single `slides.md` file using Slidev markdown syntax. `---` separates slides. HTML comments (`<!-- -->`) are presenter notes.

## Workshop Design Decisions

- **Technique-first, domain-second.** We teach transferable patterns, not a specific skill domain. The "Repo Roast" is a vehicle for learning.
- **One skill, three blocks.** Attendees build one skill progressively: Build the Foundation (constraints + scripts), Make It Smarter (phases + confidence), Skills Beyond the Editor (advanced scripts + portability + measurement).
- **Scripts are foundational.** The `!` backtick syntax (inline shell execution in skills) is taught in Build the Foundation, not as an add-on. Universal git-only core scripts that work in any repo.
- **Five techniques hands-on, rest as reference.** Constraints, source of truth, structure, progressive disclosure, confidence scoring are built live. Eval, composition, portability, and audience adaptation are presenter-led proof.
- **The technique library lives in `handbook.md`**, not in the live curriculum. `workshop.md` references it but stays focused on what happens in the room.

## Reference Directories

These are added as working directories via `.claude/settings.local.json` for cross-referencing:

- `../cli/main` — WorkOS CLI (15-framework agent-powered installer, Claude Agent SDK, validation retry loops). **Primary demo roast target** — real history, real churn, enough complexity for interesting findings. Also the Act 3 composition proof.
- `../skills` — WorkOS skills plugin (40+ reference files, eval framework, router/dispatcher pattern)
- `../case` — Case harness (multi-agent orchestration, rubric-based gating, retrospective self-improvement). Backup roast target.

## Workshop Repo Plan

- **This repo** is the workshop home: starter skill, slides, handbook. Attendees clone it.
- **WorkOS CLI (`../cli/main`)** is the demo roast target. Pre-baked outputs are generated from it. It appears twice: once as a roast target in Build the Foundation, once as the production composition proof in Skills in the Wild.

## Research & Notes

- **Live curriculum changes** go in `workshop.md` — timing, acts, presenter stories, exercise flow.
- **Reference material** (technique deep dives, taxonomies, external research findings) goes in `handbook.md`.
- When in doubt: if it happens in the room, it's `workshop.md`. If attendees read it later, it's `handbook.md`.

## Core Promise (repeat throughout)

> "You're leaving with one reusable skill for a real task you do every week."
