# Skills at Scale — Workshop Outline

> **Status:** Draft for Nick & Zack review
> **Duration:** 80 minutes (7 + 5 + 20 + 25 + 15 + 8 = 80)
> **Core message:** Skills are how you make AI reliable. Here's how to write good ones.
> **Narrative framework:** The Spiral — the same concept (a skill) revisited at increasing depth across blocks. Each pass adds a layer: output → constraints/scripts → phases/confidence → portability. The close returns to the opening.

This outline is the canonical source of truth for the workshop story arc. Slides get generated from this — not the other way around. Each block describes: the point we're making, what's on screen, what the audience does, and Nick/Zack discussion topics for the recording.

---

## Block 1: The Problem + What Skills Are (7 min)

**Point:** AI is powerful but flaky, you keep re-teaching it, and skills fix this. Define what a skill is by showing the output difference.

### Opening (2 min)

**Opening line (Nick):**
> "Raise your hand if you've used an AI coding tool in the last week."
> [hands go up]
> "Keep it up if the first thing you did was re-explain your tech stack."
> [groans]
> "Yeah. We're going to fix that."

Quick intros: "I'm Nick, this is Zack, we're DX engineers at WorkOS." Then credibility — but honest:
- We built two skills that progressively disclose 40+ topics
- The WorkOS CLI — Agent SDK under the hood, brains are entirely skills-based
- A RAG agentic pipeline, an agentic harness for DX engineering — all skills-based
- "Skills aren't a side project for us — they're how we build everything."
- "The weird part? The first versions made things worse."

### The two pains (1 min)

Quick, don't dwell:
- AI is impressive but you can't *depend* on it — hallucinations, ignored instructions, generic output
- You keep re-explaining context — your stack, your conventions, your preferences. Every. Single. Time.

Land the answer: "Skills fix this. A skill is a markdown file that encodes what you know — your context, your constraints, your judgment — so the AI is reliable every time."

### Show, don't explain (3 min)

**On screen:** Bad output vs. good output — same repo, same task. Output-first: don't show skill code yet.

1. Bad output: "Your code looks pretty good overall." Vague, generic, hallucinated.
2. Good output: specific findings, file names, severity, evidence, actionable fixes.
3. "Which of these would you actually trust?"
4. Reveal: "The difference is ~30 lines of markdown."
5. Quick: when to write a skill vs. when not to (decision framework)

### Introduce the domain (1 min)

"Today you're building one. Repo Roast — a repo health assessment. The domain is the vehicle. The patterns are what you're taking home."

**Transition:** "So what does that markdown file actually look like? Let's get set up and you'll see."

---

## Block 2: Setup (5 min)

**Point:** Get everyone running.

**On screen:** Clone command, QR code, setup.sh, verification command.

**Beats:**
1. Clone the repo
2. Run setup.sh
3. Verify skill loads (tool-specific: Claude Code / Codex / Cursor paths)
4. Pick a target repo to roast (their own, or the demo repo if they don't have one handy)

**Note:** This is logistical. Keep it tight. Checkpoint 0 available for stragglers. Nick and Zack can split — one talks through setup, the other helps people who hit issues.

**Transition to next block:** "OK, let's build."

---

## Block 3: Build the Foundation (20 min)

**Point:** Constraints and scripts are how you add determinism and context to AI.

### Teach (5 min)

Three concepts, taught fast:

1. **Constraints > instructions.** Don't tell the AI what to do — close off what it shouldn't do. Degrees of freedom framework: every unconstrained dimension is a dimension where the AI will drift. Negative constraints ("never suggest rewrites", "only report findings backed by evidence") are more enforceable than positive instructions ("be thorough").

2. **Scripts as context injection.** The `!` backtick syntax runs shell commands and injects the output into the skill's context. This gives the AI *evidence* instead of guesses. Without scripts, the AI speculates about your repo. With scripts, it has `git log`, file counts, TODO grep results — real data.

3. **Description as routing.** The skill description isn't marketing copy — it's how the AI decides *when* to use your skill. Test: ask "when would you use this skill?" and see if the answer matches your intent.

### Build (10 min)

Attendees open the starter skill and customize:
- Write a description that routes correctly
- Add 1-2 constraints that reflect their judgment
- Set the tone (roast? professional audit? something else?)
- Optionally add or modify a script (examples: count test files vs source files, check for CI config, find the most-changed files in the last month, detect which package manager is used)

Then run it. See the output change from generic to specific.

**Catch-up:** `cp checkpoints/1-starter.md` path for anyone behind.

### Nick/Zack Discussion (~5 min, during hands-on)

These are real conversations on stage, not lecture bullets. For the YouTube recording.


**Topic 1: "When a skill makes the AI dumber."**
Nick's Next.js installer skill for AuthKit — over-prescribed the steps so heavily that Claude got *worse* at Next.js integration than it was without the skill. The lesson: constraints close failure modes, but over-prescribing closes the AI's actual strengths too. Where's the line?

**Topic 2: "Scripts as the turning point."**
Zack's RAG agentic pipeline — what it produced when the skill was guessing vs. when scripts injected real evidence. Why scripts are the single biggest upgrade to any skill.

**Topic 3: "Zack's blog-writing skill."**
Zack built a skill that generates blog posts consistent with the WorkOS blog style. Good riff: how do you encode *voice* and *style* as constraints? What's the difference between "write like our blog" (vague) and actual constraints that capture the style? When does the skill help vs. when does it produce on-brand slop?

**Transition to next block:** Quick check — "Did your output get more specific? If it did, you just proved that constraints and evidence work. Now let's make it smarter."

---

## Block 4: Make It Smarter (25 min)
**Point:** Progressive disclosure and confidence scoring add self-regulation to skills.

### Teach (5-7 min)

Two techniques + one meta-lesson:

1. **Progressive disclosure — phases that load context conditionally.**
   The idea: break the skill's work into phases. Phase 1 gathers data. Phase 2 categorizes. Phase 3 recommends. Each phase can reference external files, load different scripts, or adjust behavior based on what previous phases found.

   **Slide visual needed:** Show the folder structure and document structure side by side. Something like:
   ```
   my-skill/
   ├── SKILL.md          ← entry point, phase routing
   ├── phases/
   │   ├── gather.md     ← loaded in phase 1
   │   ├── categorize.md ← loaded in phase 2
   │   └── recommend.md  ← loaded in phase 3
   └── scripts/
       ├── quick-scan.sh
       └── deep-analysis.sh
   ```
   Keep it simple — the visual should make progressive disclosure feel *obvious*, not complex.

   **Be honest here:** if all phases live in one file, the model sees everything at once. Phases only *truly* gate context when they reference external files loaded conditionally. In-file phases are still useful as *structural guidance* — they tell the model "do this before that" — but they're a suggestion, not enforcement. This is a real limitation worth naming.

2. **Confidence scoring — the skill rates its own work.**
   Add self-assessment dimensions: evidence quality, severity accuracy, actionability. Score each 1-10. Drop findings below a threshold. This gives the skill *self-awareness* — it knows when it's guessing and says so, instead of presenting everything with equal confidence.

   **Showcase: Nick's ideation skill.** This is a great concrete example — the skill uses confidence scoring to ensure alignment between what Nick actually wants and what Claude actually knows how to do. It doesn't just generate ideas; it self-assesses whether it has enough context to be useful, and surfaces gaps instead of guessing through them.

3. **Meta-lesson: The iteration loop is the real technique.**
   The point to make here isn't a specific story — it's that skills improve by *using them and being honest about the output*. Build, run, look at what it actually produced, adjust. The attendees are about to do exactly this: they'll add phases and confidence, re-run, and compare. That before/after comparison *is* the lesson. Frame it as: "Every skill you've seen us reference went through dozens of iterations. The first version is never the good version."

### Build (12-15 min)

Attendees enhance their skill:
- Add a `## Workflow` section with 2-3 phases
- Add a `## Self-Assessment` section with confidence dimensions
- Re-run on the same repo
- Compare: did phases create a conversation instead of a dump? Did confidence scoring drop the noise?

**Catch-up:** `cp checkpoints/2-with-phases.md` for anyone behind.

### Nick/Zack Discussion (~5 min, during hands-on)

**Topic 1: "Phase-gating honesty."**
LLMs can just... skip phases. Tell the real story: which skill did this happen with? What did the output look like when phases were ignored? What fix actually worked — external file references? Explicit stop points? What *doesn't* work? ("Do not proceed" in a single file is a suggestion, not a gate.) Be specific about the failure and the fix. The audience is adding phases right now — they need to know where the limits are.

**Topic 2: "When confidence scoring saved us."**
Nick's ideation skill is the concrete example here. Tell the story: what happened when the skill generated ideas without self-assessment? What did it look like when it confidently recommended something it didn't have context for? How did adding confidence dimensions change the output — did it surface gaps instead of guessing through them? When is self-assessment real vs. theater?


**Transition to next block:** "Your skill works here. Does it work *everywhere*?"

---

## Block 5: Skills Beyond the Editor (15 min)

**Point:** The same skills you just built work outside your editor — in CI pipelines, in agents, in products. That's what "at scale" actually means.

> **Reframe:** "Why This Scales" was vague. The real insight is *portability across contexts* — the same skill that runs in Claude Code also powers the WorkOS CLI, also runs in a CI pipeline, also feeds an agent. One skill, many runtimes. That's the scale story.

> **Energy note:** They've been building for 45 minutes. Open with hands-on to keep momentum, THEN talk while they're still buzzing from new output.

### Part 1: Scripts deep dive + mini-exercise (~7 min)

Open with energy. One more hands-on moment before the portability talk.

**Mini-exercise (3-5 min):** "Add one new script to your skill. Pick one that sounds fun."

Present these as a menu on screen — attendees pick whichever one they want:

**Bus factor** — find files only one person has ever touched (knowledge silos):
```
!`git ls-files | while read f; do n=$(git log --format="%an" -- "$f" | sort -u | wc -l); [ "$n" -eq 1 ] && echo "$f — $(git log -1 --format='%an' -- "$f")"; done | head -15`
```

**Commit message crimes** — find the laziest commit messages (fix, wip, temp, asdf):
```
!`git log --oneline --since="6 months ago" | grep -iE '^[a-f0-9]+ (fix|wip|temp|update|changes|stuff|asdf|test|\.+|.{1,8})$' | head -15`
```

**Zombie branches** — remote branches nobody's touched in months:
```
!`git for-each-ref --sort=committerdate --format='%(committerdate:relative) %(refname:short)' refs/remotes/ | head -15`
```

**The 3am commits** — code written between midnight and 6am:
```
!`git log --format="%H %ad %s" --date=format:"%H" --since="6 months ago" | awk '$2 >= 0 && $2 < 6' | head -10`
```

**README vs Reality** — check if commands mentioned in README actually exist:
```
!`grep -oE '(npm|yarn|pnpm|make|go|cargo|pip) [a-z-]+' README.md 2>/dev/null | sort -u`
```

Each one is copy-pasteable. Add it to your `## Context` section, re-run, see how the new signal changes the roast.

Nick/Zack riff while people work: what makes a good script, why these are all git-only (portability), which ones they'd actually keep in a production skill.

### Part 2: Same skill, everywhere (~5 min)

Now that they have a richer skill, show them where else it works. The same markdown file runs in:
- **Claude Code, Codex, Cursor** — the editor tools you're building in today
- **Claude Desktop, Claude for Web** — paste context in, the skill reasons over it (no scripts, but the constraints and structure still work)
- **Claude Agent SDK** — skills as the brains of programmatic agents (the WorkOS CLI is built this way)
- **[Pi](https://pi.dev)** — skills working inside Pi's interface
- **CI pipelines** — automatic tool calls loading specific skills on every push

The point: skills are the *portable unit of knowledge*. The runtime is interchangeable. You're not learning a Claude Code trick — you're learning how to encode expertise that works across the whole ecosystem.

Brief live comparison: show the same skill file loaded in 2-3 different contexts. The file doesn't change. The execution context does.

### Part 3: Measurement — quick hit (~3 min)

Keep this tight. One story, one takeaway.

- The negative-scoring skill story: correct information, wrong recommendation, -12% to -20% delta when measured
- Takeaway: "If you're going to rely on a skill, measure it. Even lightweight."
- Point to eval framework and skill-reviewer in the handbook for anyone who wants to go deeper

**Transition to close:** Go straight into sharing. No recap sentence — the energy should flow directly into Block 7's "let's see what everyone built."
---

## Block 6: Close (8 min)

**Point:** You built something real. Take it home.

**Beats:**

1. **Share your roasts (3 min).** Run `share.sh` — pull 2-3 to the projector. Pair up, show each other. What's different? What surprised you? This is the payoff moment. (Endpoint + `.share-config` need to be set up pre-workshop.)

2. **Install your skill (2 min).** Global installation paths for Claude Code, Codex, Cursor. "You can use this tomorrow morning."

3. **What comes next (2 min).** Where to find skills (plugin registries, GitHub, the WorkOS skills plugin). Skill-creator, transcript reflection, eval, the handbook. One slide, quick hits.

4. **Close — callback to the opening (1 min).**
   > "Remember the show of hands? The re-explaining your stack, every conversation? That's what the skill replaces. Tomorrow morning you won't re-explain. The skill already knows."
   >
   > "You learned the patterns — constraints, scripts, phases, confidence, portability. Now go build skills for the tasks *you* repeat. That's how AI stops being a toy and starts being a tool."

---

## Things We Cut or Changed

Documenting decisions so we can revisit if needed:

| Original | Decision | Why |
|----------|----------|-----|
| "You've done this before" opening | Replaced with show-of-hands + vulnerability opener | Interactive, establishes pain viscerally, earns trust through honesty |
| Blocks 1+2 as separate blocks (10 min) | Merged into single Block 1 (7 min) | 15 min of talk before code is too long for a workshop. Saves 3 min. |
| "We built 40+ skills" credibility claim | Corrected to real story | Two skills disclosing 40+ topics, plus CLI/RAG/Case — more impressive and accurate |
| Three audiences (dev/manager/new hire) | Cut | Contrived framing — real context detection is about repo/environment adaptation |
| Demo-first opening | Cut (for now) | Risk of anchoring on domain instead of patterns |
| "Why This Scales" framing | Reframed as "Skills Beyond the Editor" | "Scales" was vague — the real point is same skills, different runtimes (editor → CLI → CI → agents) |
| Block 5 portability-first ordering | Reordered: script exercise first, then portability talk | Keep energy high after 45 min of building; talk while they're buzzing from new output |
| "We didn't follow our own process" story | Replaced with generic iteration lesson | Story was incoherent — we didn't write the repo roast. The iteration loop stands on its own. |
| "Viral 4-line skills" discussion topic | Replaced with over-prescribing story | No real examples of 4-line skills; the Next.js AuthKit story is real and more useful |
| Progressive disclosure as in-file phases | Reframed with folder structure visual | In-file phases are suggestions, not enforcement — external files are what actually gate context |
| Block 6 close (10 min) | Trimmed to 8 min with opening callback | Saves 2 min; close now circles back to the show-of-hands opening (Spiral Return) |
| Generic transitions | Replaced with specific, energy-aware transitions | "Your skill works here. Does it work *everywhere*?" beats "Let's talk about why these patterns matter" |

---

## Open Questions Summary

1. ~~Show skill code or just output?~~ Resolved — output-first in Block 1. Code comes in Block 3.
2. ~~Webflow skill topic?~~ Resolved — Zack's blog-writing skill for WorkOS blog style.
3. **Block 4:** What's the best way to show the ideation skill's confidence scoring on stage? Live demo? Screenshot?
4. ~~Script deep dive examples?~~ Resolved — menu of 5 options.
5. ~~Build `share.sh`?~~ Resolved — yes, already built. Keep it.
6. ~~What is "pi"?~~ Resolved — [pi.dev](https://pi.dev).
7. **Pre-workshop prep:** Set up share.sh endpoint + `.share-config` before the event.
8. ~~Opening line?~~ Resolved — show-of-hands + vulnerability opener. See Block 1.
9. **Block 4 discussion:** Nick and Zack need to prep the specific stories for phase-gating failure and confidence scoring. The topics are defined but the details need to come from real experience, not placeholders.
10. **Block 5 portability demo:** What does "show the same skill in 2-3 contexts" actually look like on screen? Screenshots? Live tool switch? Pre-recorded clips? Needs visual design decision.
