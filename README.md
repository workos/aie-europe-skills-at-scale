# Skills at Scale

> Write once, run in Claude, Codex, Cursor, and your own agents

An 80-minute hands-on workshop at **AIE Europe 2026** by Nick Nisi & Zack Proser.

## What You'll Do

Build one reusable skill — a **Repo Roast** (repo health assessment) — progressively layering techniques across three acts:

1. **Build the foundation** — constraints, scripts (`!` backtick inline execution), structure
2. **Make it smarter** — phased workflow, confidence scoring
3. **Skills beyond the editor** — advanced scripts, portability, eval, composition

## Quick Start (Attendees)

```bash
git clone https://github.com/workos/aie-europe-skills-at-scale.git
cd aie-europe-skills-at-scale
./setup.sh        # installs the starter skill
claude             # or codex, or cursor
```

Then ask your agent: `Roast this repo`

## Prerequisites

Bring a laptop with **Claude Code**, **Codex**, or **Cursor**.

## Sharing Your Skill (Live Workshop)

During the workshop, you can share your skill with the presenter to have it run live on stage:

```bash
./share.sh --name "Your Name"
```

This reads your skill from `.claude/skills/repo-roast/SKILL.md` and sends it to the workshop server. No accounts, no setup — just run the command.

## Running the Slides

```bash
cd slides
pnpm install
pnpm dev
```

Opens at `http://localhost:3030`. Press `P` for presenter mode.

## Presenter: Reviewing Shared Skills

```bash
./review.sh            # list all submitted skills
./review.sh 3          # load skill #3 (backs up your current SKILL.md)
./review.sh --restore  # restore your original skill from backup
./review.sh --clear    # clear all submissions (requires secret)
```

### Clearing Submissions

**From the script** (uses the API):
```bash
./review.sh --clear    # prompts for secret (default: roast-2026)
```

**Directly via curl** (e.g. from any machine):
```bash
curl -X DELETE https://skill-share.YOURSUBDOMAIN.workers.dev/skills \
  -H "X-Clear-Secret: roast-2026"
```

**Nuclear option — wipe the entire KV store** (if the API isn't cooperating):
```bash
cd worker
npx wrangler kv key list --binding SKILLS | npx wrangler kv bulk delete --binding SKILLS
```

The clear secret is configured in `worker/wrangler.toml` under `[vars].CLEAR_SECRET`.

### Deploying the Sharing Server

The sharing system uses a Cloudflare Worker with KV storage.

```bash
cd worker
npm install
npx wrangler kv namespace create SKILLS   # copy the ID into wrangler.toml
npx wrangler deploy                        # copy the deployed URL into .share-config
```

Update `.share-config` in the repo root with the deployed Worker URL. This file is checked into git so attendees get it on clone.

The clear secret is set in `worker/wrangler.toml` under `[vars]`.

## Workshop Resources

| Resource | Description |
|----------|-------------|
| [GUIDE.md](GUIDE.md) | Attendee step-by-step guide |
| [handbook.md](handbook.md) | Reference/handout with full technique library |
| [workshop.md](workshop.md) | Presenter notes — timing, stories, exercise structure |
| [domain-decision.md](domain-decision.md) | Why "Repo Roast" and the domain analysis |
| [slides/](slides/) | Slidev presentation |
| [checkpoints/](checkpoints/) | Skill progression snapshots for catching up |

### Companion Reading

- [Case Statement: Building a Harness](https://nicknisi.com/posts/case-statement/)
- [Writing My First Evals](https://nicknisi.com/posts/writing-my-first-evals/)
- [Ideation: Because Planning Needs More Than a Mode](https://nicknisi.com/posts/ideation/)
- [Feedback Loopable](https://ampcode.com/notes/feedback-loopable)
