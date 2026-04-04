# Skills at Scale Workshop

## References

- [Slack discussion](https://work-os.slack.com/archives/D087UBR1VK5/p1773176258391629)
- [Granola notes with Zack](https://notes.granola.ai/t/6c345af4-94af-4fbc-b123-5f8deefa1f6e-008umkv4)
- [Feedback Loopable](https://ampcode.com/notes/feedback-loopable)
- [Case Statement: Building a Harness](https://nicknisi.com/posts/case-statement/)
- [Writing my first evals](https://nicknisi.com/posts/writing-my-first-evals/)
- [Ideation: Because planning needs more than a mode](https://nicknisi.com/posts/ideation/)

Skills at Scale

Write once, run in Claude, Codex, Cursor, and your own agents

Every developer using AI tools has the same problem: they prompt the same way, for the same tasks, over and over. Skills fix this. A skill is a portable unit of agent behavior that teaches any AI tool how to do a specific job. Write one, drop it into your editor, and it just works. Across tools. Across teams.

Most people don't know this primitive exists. In this hands-on workshop, you'll write real skills, test them live, and see how one file can power Claude.ai, Claude Code, Cursor, and Codex without changing a line.

Then we'll go deeper. You'll see how the WorkOS CLI uses this same pattern to power 15 framework
integrations — each one a skill composed with others, wired into an agent that installs and configures
AuthKit in under 60 seconds. That's not a demo. That's production code, shipping today.

What you'll do:

Write 2+ skills for tasks you actually do at work
Install and test them across AI tools in real time
Learn the craft of good skill writing — specificity, constraints, composability
See how skills compose and scale inside a real CLI powered by the Claude Agent SDK


What you'll leave with:

Working skills installed in your AI tools, ready to use Monday morning
A repeatable pattern for turning any recurring task into a portable skill
The mental model for when a skill is enough and when you need a full agent


No repos to clone. No dependencies to install. Bring a laptop with Claude Code or Claude.ai and something you're tired of doing manually.

---

## Workshop Arc (80 minutes)

### Core Promise

**You're leaving with one reusable skill for a real task you do every week.**

Technique-first workshop. Each act layers techniques onto a single skill. The domain is the attendee's choice — we teach the guitar, not the song.

| Block | Time | Mode | What happens |
|-------|------|------|-------------|
| **Open: The problem** | 5 min | Watch | You prompt the same way, for the same tasks, over and over. Show the pain. |
| **Act 1: Build the foundation** | 20 min | **Build** | Bad skill vs good skill. Attendees pick a domain, write a constrained skill with script calls and their style baked in. |
| **Act 2: Make it smarter** | 25 min | **Build** + Demo | Add phased workflow + confidence scoring (hands-on). Then transcript reflection demo from stage. |
| **Act 3: Why this scales** | 20 min | Watch | Eval (skill-reviewer live on an audience skill), composition (WorkOS CLI), portability, Claude Desktop. |
| **Close: Share & install** | 10 min | **Build** | Install across tools. Push to repo. Pull a friend's. Leave with an artifact. |

### What's taught vs what's referenced

Not everything is live curriculum. The technique library (below) is the full reference — a handout, a blog post, a companion doc. Live, we teach a subset:

| Delivery | Techniques |
|----------|-----------|
| **Hands-on (attendees build)** | Constraints > instructions, source of truth, structure, scripts (inline `!` calls), progressive disclosure, confidence scoring |
| **Stage demo (attendees watch)** | Transcript reflection / memory |
| **Proof / scale-up (presenter-led)** | Context detection, eval-driven improvement, composition, cross-tool portability, Claude Desktop / Cowork, self-improving systems |

### Dead Air Strategy

The workshop will be recorded for YouTube. Dead air kills recordings. Mitigations:

1. **Pre-baked fallbacks for every live demo.** Record each demo beforehand. If something hangs or breaks, cut to the recording and narrate over it. The audience sees the same result; the video stays clean.
2. **Narrate the wait.** When the agent is working, don't just watch — talk through what it's doing, why it's making those choices, what the audience should watch for. This is where the teaching happens.
3. **Parallel activity during agent runs.** While one demo runs, switch to slides or the attendee exercise. "While this runs, here's what I want you to try." The agent finishes in the background.
4. **Short loops, not long runs.** Structure demos as quick iterations (10-30 seconds each) rather than one long 3-minute agent run. Each loop teaches one thing.
5. **Planted questions / co-presenter banter.** Zack and Nick can volley during any wait. Pre-plan 2-3 talking points per demo to fill gaps naturally.
6. **Timer discipline.** If a demo hasn't completed in 60 seconds, cut to the fallback. Don't hope it finishes.

---

## Technique Library (Reference / Handout)

Companion reference for attendees. This is NOT the live agenda — it's the full curriculum source. Publish as a handout, blog post, or repo README. Live, we teach a subset (see "What's taught vs what's referenced" above).

Transferable patterns extracted from production systems (WorkOS CLI, skills, case).
Ordered from most accessible to most advanced.

### Tier 1: Fundamentals

#### 1. Constraints > Instructions (Degrees of Freedom)
Instead of "write good code," say "never check role slugs directly — always check permissions."
Negative constraints close specific failure modes. Positive instructions leave them open.

**Mental model — degrees of freedom:** Think of every skill instruction as setting a degree of freedom. High freedom (text-based heuristics) when many approaches are valid. Medium freedom (pseudocode, scripts with parameters) when a preferred pattern exists. Low freedom (exact scripts, no parameters) when operations are fragile and consistency is critical. Anthropic's analogy: a narrow bridge with cliffs on both sides (low freedom — one safe path) vs an open field (high freedom — many paths to success). Most skill authors default to high freedom when they should be tighter. The constraint technique is how you dial freedom down where it matters.

**Source:** The skills repo encodes 3-7 gotchas per topic, all sourced from real eval failures. Example from RBAC: "Role slug checks break in multi-org with custom roles." Each gotcha is a constraint that prevents a specific class of mistake.

**First-person:** "Instructions decay, enforcement persists." Building Case taught this — early agents forgot prose instructions as context compressed, but structural constraints survived. The same is true for skills: a constraint like "never nitpick formatting" endures where "be a thoughtful reviewer" doesn't. (See: [Case Statement](https://nicknisi.com/posts/case-statement/))

**Why it works:** Models are better at avoiding known-bad patterns than discovering ideal patterns from scratch. A constraint like "never use absolute positioning" is more enforceable than "use responsive layout."

**The railroading trap:** Constraints are powerful, but over-constraining is a different failure mode. Anthropic internally warns against "railroading Claude" — being so specific that the skill can't adapt to situations you didn't anticipate. The sweet spot: tight constraints on fragile/destructive operations, loose guidance on creative/analytical work. A code review skill needs room to adapt; a database migration skill needs exact steps. If every instruction is a constraint, you've built a script, not a skill.

**Quotable:** "The specificity is the skill." (@rubenhassid) — "I write reports" is useless. "I write weekly reports that start with the headline metric, 3 sections max, next steps as bullets" is a skill. The constraint IS the value. This lands well as a one-liner during the bad-vs-good skill comparison.

**Workshop moment:** Show a bloated skill (100+ lines of instructions) vs a tight skill (20 lines of constraints). Run the same task with both. The constraint-based skill wins. Note: most publicly shared skills (viral threads with millions of views) are shallow — names and one-liners, no constraints, no scripts, no phases. That's the gap this workshop fills.

#### 2. Source of Truth Discipline
Every skill starts with `WebFetch: [official docs URL]` and includes: "If this file conflicts with fetched docs, follow the docs."

**Source:** The skills repo uses this pattern across all 40+ reference files. The skill wraps documentation — it doesn't replace it.

**Why it works:** SDK docs change between versions. Training data goes stale. By fetching the real docs at runtime, you eliminate an entire category of hallucination. The skill becomes a guide for *how to read* the docs, not a copy of them.

**Workshop moment:** Show a skill that hardcodes API details (breaks when the API changes) vs one that fetches docs first (always current).

#### 3. Decision Trees over Keyword Matching
Priority-ordered routing: "SSO with MFA" → SSO (not MFA) because SSO is more specific in the tree.

**Source:** The `workos` skill uses an 8-step decision tree. The CLI uses a similar pattern for framework detection — check for `mix.exs` before `package.json` because Elixir is more specific than JavaScript.

**Why it works:** Without explicit priority, the model guesses based on token proximity. With a decision tree, it follows a deterministic path. This matters most when there are multiple valid interpretations of a request.

**Workshop moment:** Show a skill that handles "set up auth" ambiguously vs one with a decision tree that asks the right clarifying question.

#### 4. Scripts — Grounding Skills in Reality
Skills aren't just prompt templates. They can call scripts to gather real data, validate output, and interact with the system. This is what turns a skill from "smart text" into an actual tool.

**Inline script calls (Claude):** Skills can embed shell commands that run inline and inject their output directly into the skill's context:

```markdown
## Context
PR diff: !`git diff origin/main`
Current branch: !`git branch --show-current`
Lint output: !`npm run lint 2>&1 | tail -20`
Test results: !`npm test 2>&1 | tail -30`
```

The `!` backtick syntax runs the command and replaces it with the output. The skill now has real data — not LLM guesses about what the code looks like, but actual diff output, actual lint errors, actual test results.

**Why this matters:** Without scripts, a skill can only reason about what the model already knows or what the user pastes in. With scripts, the skill gathers its own context. A code review skill that reads the actual diff is fundamentally different from one that asks "what did you change?"

**Two patterns:**
1. **Context gathering** — run scripts at the start to collect data the skill reasons over (git diff, lint output, test results, dependency tree)
2. **Output validation** — run scripts after the skill acts to verify its work (typecheck, build, test). This is the feedback loop pattern made concrete.

**Workshop moment:** Show a skill with and without script calls on the same task. Without: the model guesses about the code. With: it has the actual diff, actual errors, actual test output. The quality difference is immediate.

### Tier 2: Intermediate

#### 5. Progressive Disclosure
Don't dump 10 steps at once. Phase-gate with blocking dependencies: Phase 2 doesn't start until Phase 1 is confirmed done.

**Source:** The skills use numbered phases (detect → install → configure → verify). The CLI's `FrameworkConfig` enforces the same — each step produces output the next step needs.

**First-person:** The Ideation plugin is built entirely on this pattern: ramble → confidence gate → codebase exploration → contract → spec → execute. Each phase produces an artifact the next phase needs. You can't skip to the spec without passing the confidence gate. The WorkOS CLI retry loop — a production feature — was born from this pipeline. (See: [Ideation](https://nicknisi.com/posts/ideation/))

**Why it works:** Models lose track of multi-step instructions. By gating each phase, you get verification at each checkpoint and prevent the model from skipping ahead or conflating steps.

**Anti-pattern — deeply nested references:** When splitting content across files, keep references one level deep from SKILL.md. Claude may partially read files referenced from other referenced files (using `head -100` instead of reading completely). SKILL.md → reference file is fine. SKILL.md → file → another file loses information. All reference files should link directly from SKILL.md.

#### 6. Ambiguity Handling
"Explore before asking. Ask only when ambiguity remains after checking manifests and route/auth entrypoints."

**Source:** Skills `detection.md` — multi-tier detection (dependency manifests → framework entrypoints → auth patterns → styling → package manager). The CLI does the same for language detection.

**Why it works:** Over-asking annoys users. Over-guessing causes errors. The sweet spot: try to infer from environment first, then ask one focused question if genuinely ambiguous.

#### 7. Context Detection
Your skill should adapt to what it finds, not assume a fixed environment.

**Source:** The CLI detects 15 frameworks by scanning for manifest files. Skills detect Next.js version, router type, `src/app/` vs `app/` directory structure. All before writing a single line of code.

**Why it works:** A skill that assumes Next.js 15 will break on Next.js 16. A skill that checks first works everywhere. This is what makes skills *portable* — they adapt to context rather than hardcoding assumptions.

### Tier 3: Advanced

#### 8. Feedback Loops (Making Work "Feedback Loopable")
After the agent acts, validate the result. If it fails, format the error into an agent-readable prompt and send it back.

**Source:** The CLI runs `tsc --noEmit` after the agent writes code. If typecheck fails, it formats errors with file locations and sends them back as a retry prompt. Up to N retries with structured feedback.

**Reference:** [Feedback Loopable](https://ampcode.com/notes/feedback-loopable) — "It's not about controlling the data it sees. It's about setting up the environment and getting out of the way." The key is converting problems into formats where agents can self-validate: CLI tools, text-based output, reproducible test cases.

**Why it works:** Without feedback, the agent is flying blind. With a validation loop, it catches its own mistakes. The environment does the grading, not the human.

**Workshop moment:** Show a skill that asks the model to grade its own output (confidence score) and retry if below threshold. Simple to add, dramatic improvement in reliability.

#### 9. Transcript Reflection & Memory
The conversation itself is data. Agent transcripts contain decisions made, mistakes corrected, dead ends abandoned, and patterns that worked. A skill can mine this.

**How it works:** After completing a task with an agent, the transcript reveals *how* the work was actually done — not just the output, but the process. A skill can read past transcripts to:
- Extract anecdotes and decision points for storytelling (e.g., writing a blog post about work you did with an agent — the transcript has the real story)
- Identify recurring mistakes to add as constraints ("I keep hitting this same error — add it as a gotcha")
- Summarize sessions for handoff or reflection
- Feed learnings back into the skill itself

**Claude Code's auto-memory:** Claude Code already does a version of this. It observes patterns in conversation and persists learnings to memory files (`~/.claude/projects/*/memory/`). These memories carry across sessions — the tool gets smarter about *you* over time. This is the self-improving system pattern at the individual level: every session teaches the next session something.

**Why it's novel:** Most people treat every AI session as stateless. They close the tab and the context is gone. The unlock is realizing that transcripts and memory are a flywheel: work → reflect → extract → apply → better work. The skill doesn't just do the task — it learns from doing the task.

**Workshop moment:** Show a real example — an agent transcript from a coding session, then a skill that reads it and extracts the key decisions and mistakes. "The conversation you just had is the most honest record of how the work actually went."

#### 10. Success Criteria — What to Measure

Before you can eval, you need to know what "better" means. Anthropic's recommended metrics:

**Quantitative:** Does the skill trigger on 90%+ of relevant queries? Does it complete the workflow in fewer tool calls than without? Zero failed API/script calls per run?

**Qualitative:** Can a user complete the task without correcting Claude? Are results consistent across 3-5 runs of the same request? Does Claude need fewer clarifying questions?

**How to test triggering:** Run 10-20 test queries that should trigger the skill, plus 5-10 that shouldn't. Track hit/miss rates. The debugging question ("When would you use this skill?") is the fast version. A systematic trigger test suite is the production version.

These are aspirational benchmarks, not precise thresholds. Even rough measurement beats pure intuition.

#### 11. Eval-Driven Improvement
Run each test case WITH and WITHOUT the skill. Measure the delta. Hard gates: no negative delta, hallucination reduction ≥ 50%.

**Source:** The skills eval framework runs 42 cases, compares outputs, measures improvement. Human labels can override. Calibration gate ensures scorer agrees with human judgment ≥ 80%.

**First-person:** "I thought my skills were helping. They looked helpful. They contained accurate information. But the eval showed the LLM consistently scored lower when these skills were in the system prompt." One skill produced -12% to -20% deltas on directory sync and SSO cases. The skill taught correct information but omitted critical context, misleading the model away from complete solutions. I only discovered this by measuring. Also discovered 13 apparent regressions that were actually scorer bugs — even the eval itself can fail and needs calibration. (See: [Writing My First Evals](https://nicknisi.com/posts/writing-my-first-evals/))

**Why it works:** "This skill feels better" isn't evidence. A measured delta is. This is how you move from vibes to engineering — and how you know when a skill change actually helps vs just feels different.

#### 11. Self-Improving Systems
Every run (success or failure) feeds back into the system. Failures become constraints. The system gets smarter with each use.

**Source:** The case harness runs a retrospective after every task. It reads the full progress log, identifies failure patterns, and proposes amendments to principles and playbooks. Eval failures in skills become new gotchas.

**First-person:** Case's retrospective agent noticed the verifier repeatedly failed to confirm that example apps actually used new code paths. It proposed an amendment to the verifier's prompt. After review, the next run caught a false positive that would have shipped. The feedback loop: agent fails → fix the system → next agent succeeds. When the same issue appears 3+ times in a repo's learnings, the retrospective escalates. (See: [Case Statement](https://nicknisi.com/posts/case-statement/))

**Why it works:** This is the "making your system smarter" narrative. A skill is a point-in-time snapshot. A self-improving system is a flywheel. Each failure makes the next run better.

### Skill Pattern Archetypes (Reference)

Anthropic identifies five recurring structural patterns. Naming them helps attendees recognize what they're building and choose the right architecture:

| Pattern | When to use | Example |
|---------|------------|---------|
| **Sequential workflow** | Multi-step processes in a specific order | Onboard customer: create account → setup payment → create subscription → send welcome email |
| **Multi-source coordination** | Workflows spanning multiple tools/services | Design handoff: export from Figma → upload to Drive → create tasks in Linear → notify Slack |
| **Iterative refinement** | Output quality improves with iteration | Generate report → validate with script → fix issues → re-validate → finalize |
| **Context-aware tool selection** | Same outcome, different approach depending on context | File storage: large files → cloud, collaborative docs → Notion, code → GitHub |
| **Domain-specific intelligence** | Skill adds specialized knowledge beyond tool access | Payment processing with compliance checks, sanctions screening, audit trails |

Our workshop primarily builds patterns 1 (sequential workflow via phases) and 3 (iterative refinement via confidence scoring). The others are "where this goes next" material.

---

## The Exercise: Technique-First, Domain-Second

We teach the guitar, not the song. Each act teaches transferable techniques. Attendees apply them to whatever domain fits their work. The skill is a vehicle for learning — the techniques are what they take home.

### Why Rails Still Matter

- **80 minutes is brutal.** We provide the skeleton and starter domains to prevent decision paralysis.
- **Debugging from stage requires a shared structure.** Everyone's skill has the same sections (constraints, workflow, self-assessment) even if the domain differs.
- **The recording needs a through-line.** The YouTube arc is: naive skill → constrained → self-aware → part of a system. That story works regardless of domain.

### Skill Categories (Reference for Domain Selection)

Anthropic internally catalogs skills into nine recurring categories. Sharing this helps attendees recognize what type of skill they're building and pick a domain faster:

| Category | What it does | Example |
|----------|-------------|---------|
| **Library & API Reference** | How to correctly use a library/CLI/SDK. Gotchas, snippets, edge cases. | `billing-lib`, `frontend-design` |
| **Product Verification** | Test/verify code works. Paired with playwright, tmux, assertions. | `signup-flow-driver`, `checkout-verifier` |
| **Data Fetching & Analysis** | Connect to data/monitoring stacks. Credentials, dashboard IDs, query patterns. | `funnel-query`, `grafana` |
| **Business Process Automation** | Automate repetitive workflows into one command. | `standup-post`, `weekly-recap` |
| **Code Scaffolding & Templates** | Generate framework boilerplate for your codebase. | `new-migration`, `create-app` |
| **Code Quality & Review** | Enforce code quality. May run via hooks or CI. | `adversarial-review`, `testing-practices` |
| **CI/CD & Deployment** | Fetch, push, deploy. Monitor PRs, rollbacks, cherry-picks. | `babysit-pr`, `deploy-service` |
| **Runbooks** | Symptom → investigation → structured report. | `oncall-runner`, `log-correlator` |
| **Infrastructure Operations** | Routine maintenance with guardrails for destructive actions. | `dependency-management`, `cost-investigation` |

The best skills fit cleanly into one category. The more confusing ones straddle several. Use this as a lens, not a cage.

### Starter Domains (Pick One)

We provide 3-4 starter skeletons. Each has the same structure (constraints, workflow, self-assessment) with domain-specific defaults. Attendees pick one and customize, or bring their own domain using the same skeleton.

| Domain | Why it works | Scripts it would use | Personalization surface |
|--------|-------------|---------------------|----------------------|
| **PR preflight** | Technical, everyone ships code. Scripts are essential. | `git diff`, `npm run lint`, `npm test`, `git log` | What to flag vs ignore, severity thresholds, ship/no-ship criteria |
| **Code review** | Everyone does it. Constraints and confidence scoring are natural. | `git diff origin/main`, `git log --oneline -10` | Review style (terse vs pedagogical), what to flag, severity priorities |
| **PR descriptions** | Everyone hates writing these. Fast to demo. Clear before/after. | `git diff --stat`, `git log --oneline origin/main..HEAD` | Level of detail, what context to include, tone |
| **Task breakdown** | Given a ticket, produce implementable subtasks. High value. | `find src/ -name "*.ts"`, `cat package.json` | How granular, what metadata, framework preferences |
| **Bring your own** | Same skeleton, any domain. | Whatever fits | Everything |

The stage demo uses ONE domain throughout (TBD — whatever demos fastest and clearest). Attendees follow along in their chosen domain.

### Act 1: Build the Foundation — Constraints & Structure

**Technique focus:** Constraints > instructions, source of truth discipline, structure.

**The story that opens this act:**

> "Instructions decay, enforcement persists."

From building Case — a multi-agent harness for 20+ repos — I learned this the hard way. Early versions gave agents prose instructions for how to behave. Context windows compressed, agents forgot, and they started skipping phases and creating fake evidence. The fix wasn't better instructions. It was mechanical constraints — things agents *can't* ignore because they're structural, not advisory.

That's the same principle behind a good skill. Don't tell the model what to do. Tell it what it must never do, and point it at the real source of truth. (See: [Case Statement](https://nicknisi.com/posts/case-statement/))

**Before they write anything — the description matters:** The skill's name and description are the only things loaded at startup. Claude uses the description to decide whether to activate a skill from potentially 100+ available. A vague description ("helps with repos") means the skill never fires. A good description includes what it does AND when to use it: "Analyzes repository health by running git and file-system scripts. Use when the user asks for a repo assessment, health check, or code quality review." You can also add negative triggers to prevent over-firing: "Do NOT use for simple file lookups or general git questions." Teach this as a 2-minute beat before they start writing.

**Debug it by asking Claude.** After writing the description, have attendees ask Claude: "When would you use the [skill name] skill?" Claude quotes the description back and explains its reasoning. If it can't articulate when to use the skill, the description needs work. If it fires on things it shouldn't, add negative triggers. This is a 30-second exercise that turns description-writing from abstract to testable. When in doubt about whether your skill works, just ask the model — they're surprisingly good at debugging themselves.

**What they start with:** A bad skill — vague, positive instructions, no guardrails.

**What they build:** A constrained skill with their style and priorities baked in.

**The skeleton every domain shares:**

```markdown
# [Skill Name]

## Context (gathered via scripts)
[What real data does this skill need before it can act?]
Current branch: !`git branch --show-current`
Recent changes: !`git diff --stat origin/main`
[Add domain-specific scripts: lint output, test results, file listings, etc.]

## Style
[How should the output sound/feel? What's your approach to this task?]

## Constraints
[What should it NEVER do? What are the known failure modes?]
- Never...
- Never...
- Always...

## Source of Truth
[What should it read/fetch before acting? Where does ground truth live?]
Read the following before starting: [URL or file reference]
If this file conflicts with fetched sources, follow the sources.

## Structure
[What's the output format? What sections, in what order?]
```

**Key teaching moment — scripts:** The `!` backtick syntax runs a shell command inline and injects its output into the skill. This is what makes skills more than prompt templates. The skill now gathers its own context from the real environment — it doesn't guess, it checks.

**What they see change:** Run the same prompt with the bad skill and the constrained skill. The difference is immediate — generic noise vs focused output grounded in real data from their actual project.

**Where they make it theirs:**
- Their scripts — what context does the skill need to gather? (`git log`, `npm test`, `ls src/`, custom commands)
- Their constraints — what do they never want to see?
- Their style — terse or detailed? Formal or casual?
- Their source of truth — what docs, repos, or examples should it always reference?

### Act 2: Make It Smarter — Phases + Confidence + Reflection Demo

**Hands-on techniques:** Progressive disclosure, confidence scoring.
**Stage demo:** Transcript reflection / memory.

**The story that opens this act:**

> "LLMs are good at reasoning about code. They're bad at being state machines."

Another lesson from Case. Early pipeline versions let agents decide their own next steps. They skipped phases, retried excessively, made up their own workflows. The fix: deterministic flow control outside the model, structured self-assessment inside. That's what we're adding now — phases the model follows, and a self-check it runs before presenting. (See: [Case Statement](https://nicknisi.com/posts/case-statement/))

Attendees add two capabilities to the same skill, then watch a demo of a third.

#### Hands-On: Progressive Disclosure
Instead of one-shotting output, the skill works in phases:

```markdown
## Workflow
Phase 1: [Quick assessment / triage / outline]. Stop and present.
Phase 2: [Full output based on approved Phase 1]. Stop and present.
Phase 3: [Revise based on feedback. Run constraints checklist]. Present final.
Do not skip phases. Each phase requires confirmation before proceeding.
```

**What they see change:** Output becomes collaborative. They steer after Phase 1 instead of accepting whatever comes out.

#### Hands-On: Confidence Scoring

**The real-world design:** The Ideation plugin scores confidence across 5 specific dimensions (problem clarity, goal definition, success criteria, scope boundaries, internal consistency), each 0-20, requiring 95 total points before advancing. When scores fall short, it asks targeted clarifying questions — not open-ended "what do you mean?" but concrete options. (See: [Ideation](https://nicknisi.com/posts/ideation/))

For the workshop, we simplify this into a pattern they can adapt to any domain:

```markdown
## Self-Assessment
After completing your output, rate across these dimensions:
- Constraint compliance (1-10): Did you violate any constraint?
- Completeness (1-10): Did you address everything asked for?
- Confidence (1-10): How sure are you this is correct/good?

If any score is below 7, revise before presenting. Show scores to the user.
If total is below 21, ask one targeted clarifying question before revising.
```

**What they see change:** The model catches its own drift. Weak output gets revised automatically. This is the simplest possible feedback loop — zero infrastructure, dramatic improvement in reliability. And they can make it more sophisticated later: add domain-specific dimensions, raise the threshold, require specific evidence for each score.

#### Stage Demo: Transcript Reflection

This one is shown from stage, not built. It's the "oh wow" moment.

**The real story:** When writing the blog post about building evals, I had Claude review the transcripts from the sessions where I actually built them. The transcripts surfaced anecdotes I'd forgotten — dead ends, surprising failures, moments where the approach changed. Those became the most compelling parts of the post. The conversation was the most honest record of how the work actually went. (See: [Writing My First Evals](https://nicknisi.com/posts/writing-my-first-evals/))

Show this live: an agent transcript from a previous session, then a skill that reads it and extracts decisions, mistakes, and patterns.

Then show Claude Code's auto-memory: every session already teaches the next session something. The tool persists learnings to memory files (`~/.claude/projects/*/memory/`) across sessions — the self-improving system pattern at the individual level. You don't even need a skill for this. It's already happening.

**Skills can persist their own state too.** Beyond Claude Code's auto-memory, skills themselves can store data — append-only log files, JSON, even SQLite. Anthropic's internal `standup-post` skill keeps a `standups.log` so the next run knows what changed since yesterday. Config files in the skill directory (`config.json`) can store setup info like which Slack channel to post to. Use `${CLAUDE_PLUGIN_DATA}` for stable storage that survives skill upgrades.

**Why demo, not hands-on:** This technique requires having a past transcript to reflect on. The attendees just started — they don't have one yet. But after running their skill a few times post-workshop, they will. Plant the seed now; they'll harvest it later.

The message: most people treat every AI session as stateless. The unlock is realizing transcripts and memory are a flywheel — work → reflect → extract → apply → better work.

### Act 3: Why This Scales — Presenter-Led Payoff

You built the primitive. Here's why it matters beyond today.

**The story that opens this act:**

> "Trust isn't a feeling. It's a number."

This act is fast-paced, presenter-led. No new hands-on work. The goal: show that the techniques they just learned are the same ones powering production systems. Frame as "here's where this goes," not "here are five more concepts." (See: [Writing My First Evals](https://nicknisi.com/posts/writing-my-first-evals/))

#### Live: Eval on an Audience Skill

Pull up someone's skill from the room. Run the skill-reviewer on it live. Get structured feedback, show where it's strong and weak.

**Then tell the negative-scoring skill story.** This is the moment that makes the room go quiet:

> "I built a skill for directory sync and SSO. It looked helpful. It contained accurate information. I was proud of it. Then I ran the eval — same test cases, with and without the skill. The skill made the output *worse*. Consistently. -12% to -20% delta. The skill was teaching correct information but omitting critical context, and the model was scoring lower because of it."

> "If the LLM already knows the answer, your skill is dead weight. If your skill adds noise, it's actively harmful. You can't know which one it is without measuring."

Show the production eval framework briefly: 42 test cases, with/without comparison, composite scoring across 7 dimensions, hard gates on regression. Then the scorer bug story — 13 apparent regressions that were actually scorer bugs. Even the eval can be wrong. That's why you calibrate against human judgment.

The message: start with the skill-reviewer today. Graduate to eval when skills become load-bearing. Anthropic themselves acknowledge that "there will be an element of vibes-based assessment" — measurement is the direction, not an absolute. But even lightweight measurement beats pure intuition. A before/after comparison on three test cases is better than "it feels right."

#### Show: Context Detection

Quick demo of context detection as a technique they can add later. The skill adapts to what it finds — different input types, different environments, different audiences — without being rewritten.

Show the WorkOS CLI doing this at scale: 15 frameworks detected automatically, the right skill activated for each one. Same pattern, production grade.

#### Show: Composition — Skills as Building Blocks

Their skill solves one problem. Skills composed together are a system.

**The full-circle story:** The WorkOS CLI's validation-driven retry loop — where the agent gets typecheck errors fed back to it and self-corrects — was born from an Ideation session. Rambling input → confidence gate → codebase exploration → contract → three-phase spec → implementation. The same techniques from today's workshop (progressive disclosure, confidence scoring, phased workflow) produced the production system we're now showing as proof. (See: [Ideation](https://nicknisi.com/posts/ideation/))

- The WorkOS CLI: framework detection routes to the right installation skill, which uses validation-driven retry loops to self-correct.
- 15 framework integrations, each a skill composed with others, wired into an agent via the Claude Agent SDK.
- That's production code, shipping today.

#### Note: Skills Are Folders, Not Just Files

In the workshop, attendees build a single SKILL.md. But production skills are folders — scripts, reference files, config, assets. Anthropic's internal skills include helper libraries Claude composes at runtime, template files in `assets/`, and reference docs split by domain. On-demand hooks are another power feature: a skill can register session-scoped hooks that only activate when invoked. Examples: `/careful` blocks `rm -rf`, `DROP TABLE`, and force-push via a PreToolUse matcher. `/freeze` blocks edits outside a specific directory. These are too opinionated to run always, but invaluable when you need them. The single-file skill they build today is the seed. The folder pattern is where it grows.

#### Note: Model-Dependent Behavior

A skill that works perfectly on Opus might need more guardrails on Haiku. Stronger models can work with high-freedom instructions; smaller models need tighter constraints. If attendees plan to share skills across teams using different models (or across tools with different underlying models), they should test with all target models. This is a quick awareness note, not a hands-on beat — just plant the idea that "works for me" isn't the same as "works everywhere."

#### Show: Cross-Tool Portability

Cross-tool portability is the proven engagement hook — a viral thread listing 20 shallow skills for "Claude, ChatGPT & Gemini" hit 3.2M views. The "write once, run everywhere" promise is what the audience cares about most. Our version is deeper: not just "same file works everywhere" but "same *well-crafted* file works everywhere."

Three layers of scale — the payoff of the title:

1. **Personal scale:** Same skill file running in Claude Code → Cursor → Codex. No changes.
2. **Team scale:** Push to a repo, teammate pulls it. Works in their tool.
3. **Production scale:** Skills composed inside agents. Installed via `workos skills install` across all detected agents automatically.

#### Show: Claude Desktop / Cowork — Skills for Everyone

Not everyone on a team writes code.

- Open Claude Desktop. The same skill is there. It works.
- A non-technical teammate uses a skill without touching a terminal or GitHub.
- Claude Cowork extends this — skills in a collaborative context, not just solo.

Same skill, from terminal to desktop to team to production.

### Progression Summary

| Act | Mode | Techniques | What visibly changes |
|-----|------|-----------|---------------------|
| **1: Build the foundation** | Build | Constraints, source of truth, structure, scripts | Generic noise → focused output grounded in real project data |
| **2: Make it smarter** | Build + Demo | Phases, confidence scoring, transcript reflection (demo) | One-shot → collaborative, self-correcting. Seeds the memory flywheel. |
| **3: Why this scales** | Watch | Context detection, eval, composition, portability, Desktop | Single skill → measured, composed, portable, accessible system |

### The Through-Line (repeat at each transition)

> "You're leaving with one reusable skill for a real task you do every week."

Say this:
- At the **open**, when framing the promise
- At the **start of Act 2**, when they already have a working skill and are about to make it better
- At the **start of Act 3**, reminding them the skill they built IS the thing we're now showing at scale
- At the **close**, when they install it and share it

### Post-Workshop Accelerator: skill-creator

Mention in the closing: Claude's built-in `skill-creator` skill can generate skills from natural language descriptions. It interviews you, produces a SKILL.md with frontmatter, and runs an evaluation before you install. It's not a replacement for understanding the techniques (constraints, scripts, phases, confidence) — it's an accelerator for applying them faster. "Now that you know what makes a good skill, skill-creator can scaffold the next one in minutes."

---

## Reference Systems

### WorkOS CLI (`../cli/main`)
Agent-powered AuthKit installer. 15 framework integrations via registry pattern. Claude Agent SDK with validation-driven retry loops. Demonstrates: framework detection, progressive disclosure, feedback loops, safe tool permissions.

### Skills (`../skills`)
Production skill system with router/dispatcher pattern, 40+ reference files, eval framework. Demonstrates: constraints/gotchas, source of truth discipline, decision trees, ambiguity handling, eval-driven improvement.

### Case (`../case`)
Multi-agent orchestration harness. Rubric-based gating, revision loops, retrospective self-improvement, evidence markers. Demonstrates: confidence via rubrics, feedback loops, self-improving systems.

### Blog Posts (first-person stories for each technique)

These posts are the source material for the presenter stories woven throughout each act. They can also be shared as companion reading for attendees who want to go deeper.

| Post | Techniques it illustrates | Key anecdote for stage |
|------|--------------------------|----------------------|
| [Case Statement](https://nicknisi.com/posts/case-statement/) | Constraints > instructions, progressive disclosure, feedback loops, self-improving systems | "Instructions decay, enforcement persists." Early agents forgot prose, skipped phases, faked evidence. Mechanical constraints fixed it. |
| [Writing My First Evals](https://nicknisi.com/posts/writing-my-first-evals/) | Eval-driven improvement, transcript reflection | The negative-scoring skill: looked helpful, measured harmful. "Trust isn't a feeling. It's a number." |
| [Ideation](https://nicknisi.com/posts/ideation/) | Confidence scoring, progressive disclosure, feedback loops | 5-dimension confidence gate (95 points to advance). The CLI retry loop was born from an Ideation session. |
| [Feedback Loopable](https://ampcode.com/notes/feedback-loopable) | Feedback loops | "It's not about controlling the data. It's about setting up the environment and getting out of the way." |
