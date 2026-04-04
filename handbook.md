# Skills at Scale — Handbook

Companion reference for attendees. This is NOT the live agenda — it's the full technique library, taxonomies, and reference material. Publish as a handout, blog post, or repo companion. For the live curriculum, see [workshop.md](workshop.md).

Transferable patterns extracted from production systems (WorkOS CLI, skills, case).
Ordered from most accessible to most advanced.

---

## Technique Library

### Tier 1: Fundamentals

#### 1. Constraints > Instructions (Degrees of Freedom)
Instead of "write good code," say "never check role slugs directly — always check permissions."
Negative constraints close specific failure modes. Positive instructions leave them open.

**Mental model — degrees of freedom:** Think of every skill instruction as setting a degree of freedom. High freedom (text-based heuristics) when many approaches are valid. Medium freedom (pseudocode, scripts with parameters) when a preferred pattern exists. Low freedom (exact scripts, no parameters) when operations are fragile and consistency is critical. Anthropic's analogy: a narrow bridge with cliffs on both sides (low freedom — one safe path) vs an open field (high freedom — many paths to success). Most skill authors default to high freedom when they should be tighter. The constraint technique is how you dial freedom down where it matters.

**Source:** The skills repo encodes 3-7 gotchas per topic, all sourced from real eval failures. Example from RBAC: "Role slug checks break in multi-org with custom roles." Each gotcha is a constraint that prevents a specific class of mistake.

**First-person:** "Instructions decay, enforcement persists." Building Case taught this — early agents forgot prose instructions as context compressed, but structural constraints survived. The same is true for skills: a constraint like "never nitpick formatting" endures where "be a thoughtful reviewer" doesn't. (See: [Case Statement](https://nicknisi.com/posts/case-statement/))

**Why it works:** Models are better at avoiding known-bad patterns than discovering ideal patterns from scratch. A constraint like "never use absolute positioning" is more enforceable than "use responsive layout."

**The railroading trap:** Constraints are powerful, but over-constraining is a different failure mode. Anthropic internally warns against "railroading Claude" — being so specific that the skill can't adapt to situations you didn't anticipate. The sweet spot: tight constraints on fragile/destructive operations, loose guidance on creative/analytical work. A code review skill needs room to adapt; a database migration skill needs exact steps. If every instruction is a constraint, you've built a script, not a skill.

**Quotable:** "The specificity is the skill." (@rubenhassid) — "I write reports" is useless. "I write weekly reports that start with the headline metric, 3 sections max, next steps as bullets" is a skill. The constraint IS the value.

#### 2. Source of Truth Discipline
Every skill starts with `WebFetch: [official docs URL]` and includes: "If this file conflicts with fetched docs, follow the docs."

**Source:** The skills repo uses this pattern across all 40+ reference files. The skill wraps documentation — it doesn't replace it.

**Why it works:** SDK docs change between versions. Training data goes stale. By fetching the real docs at runtime, you eliminate an entire category of hallucination. The skill becomes a guide for *how to read* the docs, not a copy of them.

#### 3. Decision Trees over Keyword Matching
Priority-ordered routing: "SSO with MFA" → SSO (not MFA) because SSO is more specific in the tree.

**Source:** The `workos` skill uses an 8-step decision tree. The CLI uses a similar pattern for framework detection — check for `mix.exs` before `package.json` because Elixir is more specific than JavaScript.

**Why it works:** Without explicit priority, the model guesses based on token proximity. With a decision tree, it follows a deterministic path. This matters most when there are multiple valid interpretations of a request.

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

#### 9. Transcript Reflection & Memory
The conversation itself is data. Agent transcripts contain decisions made, mistakes corrected, dead ends abandoned, and patterns that worked. A skill can mine this.

**How it works:** After completing a task with an agent, the transcript reveals *how* the work was actually done — not just the output, but the process. A skill can read past transcripts to:
- Extract anecdotes and decision points for storytelling (e.g., writing a blog post about work you did with an agent — the transcript has the real story)
- Identify recurring mistakes to add as constraints ("I keep hitting this same error — add it as a gotcha")
- Summarize sessions for handoff or reflection
- Feed learnings back into the skill itself

**Claude Code's auto-memory:** Claude Code already does a version of this. It observes patterns in conversation and persists learnings to memory files (`~/.claude/projects/*/memory/`). These memories carry across sessions — the tool gets smarter about *you* over time. This is the self-improving system pattern at the individual level: every session teaches the next session something.

**Why it's novel:** Most people treat every AI session as stateless. They close the tab and the context is gone. The unlock is realizing that transcripts and memory are a flywheel: work → reflect → extract → apply → better work. The skill doesn't just do the task — it learns from doing the task.

**Skills can persist their own state too.** Beyond Claude Code's auto-memory, skills themselves can store data — append-only log files, JSON, even SQLite. Anthropic's internal `standup-post` skill keeps a `standups.log` so the next run knows what changed since yesterday. Config files in the skill directory (`config.json`) can store setup info like which Slack channel to post to. Use `${CLAUDE_PLUGIN_DATA}` for stable storage that survives skill upgrades.

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

#### 12. Self-Improving Systems
Every run (success or failure) feeds back into the system. Failures become constraints. The system gets smarter with each use.

**Source:** The case harness runs a retrospective after every task. It reads the full progress log, identifies failure patterns, and proposes amendments to principles and playbooks. Eval failures in skills become new gotchas.

**First-person:** Case's retrospective agent noticed the verifier repeatedly failed to confirm that example apps actually used new code paths. It proposed an amendment to the verifier's prompt. After review, the next run caught a false positive that would have shipped. The feedback loop: agent fails → fix the system → next agent succeeds. When the same issue appears 3+ times in a repo's learnings, the retrospective escalates. (See: [Case Statement](https://nicknisi.com/posts/case-statement/))

**Why it works:** This is the "making your system smarter" narrative. A skill is a point-in-time snapshot. A self-improving system is a flywheel. Each failure makes the next run better.

---

## Skill Categories (Anthropic's Taxonomy)

Anthropic internally catalogs skills into nine recurring categories. Use this to recognize what type of skill you're building and pick a domain:

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

---

## Skill Pattern Archetypes

Anthropic identifies five recurring structural patterns. Naming them helps you recognize what you're building and choose the right architecture:

| Pattern | When to use | Example |
|---------|------------|---------|
| **Sequential workflow** | Multi-step processes in a specific order | Onboard customer: create account → setup payment → create subscription → send welcome email |
| **Multi-source coordination** | Workflows spanning multiple tools/services | Design handoff: export from Figma → upload to Drive → create tasks in Linear → notify Slack |
| **Iterative refinement** | Output quality improves with iteration | Generate report → validate with script → fix issues → re-validate → finalize |
| **Context-aware tool selection** | Same outcome, different approach depending on context | File storage: large files → cloud, collaborative docs → Notion, code → GitHub |
| **Domain-specific intelligence** | Skill adds specialized knowledge beyond tool access | Payment processing with compliance checks, sanctions screening, audit trails |

The workshop primarily builds patterns 1 (sequential workflow via phases) and 3 (iterative refinement via confidence scoring). The others are "where this goes next" material.

---

## Reference Systems

### WorkOS CLI (`../cli/main`)
Agent-powered AuthKit installer. 15 framework integrations via registry pattern. Claude Agent SDK with validation-driven retry loops. Demonstrates: framework detection, progressive disclosure, feedback loops, safe tool permissions.

### Skills (`../skills`)
Production skill system with router/dispatcher pattern, 40+ reference files, eval framework. Demonstrates: constraints/gotchas, source of truth discipline, decision trees, ambiguity handling, eval-driven improvement.

### Case (`../case`)
Multi-agent orchestration harness. Rubric-based gating, revision loops, retrospective self-improvement, evidence markers. Demonstrates: confidence via rubrics, feedback loops, self-improving systems.

---

## Blog Posts (First-Person Stories for Each Technique)

These posts are the source material for the presenter stories woven throughout each act. They can also be shared as companion reading for attendees who want to go deeper.

| Post | Techniques it illustrates | Key anecdote for stage |
|------|--------------------------|----------------------|
| [Case Statement](https://nicknisi.com/posts/case-statement/) | Constraints > instructions, progressive disclosure, feedback loops, self-improving systems | "Instructions decay, enforcement persists." Early agents forgot prose, skipped phases, faked evidence. Mechanical constraints fixed it. |
| [Writing My First Evals](https://nicknisi.com/posts/writing-my-first-evals/) | Eval-driven improvement, transcript reflection | The negative-scoring skill: looked helpful, measured harmful. "Trust isn't a feeling. It's a number." |
| [Ideation](https://nicknisi.com/posts/ideation/) | Confidence scoring, progressive disclosure, feedback loops | 5-dimension confidence gate (95 points to advance). The CLI retry loop was born from an Ideation session. |
| [Feedback Loopable](https://ampcode.com/notes/feedback-loopable) | Feedback loops | "It's not about controlling the data. It's about setting up the environment and getting out of the way." |
