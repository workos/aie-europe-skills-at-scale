# Skills at Scale — Speaker & Rehearsal Review

A rehearsal-focused review of `workshop.md` after the curriculum revisions. This is not a curriculum redesign doc — it assumes the workshop structure is now solid and focuses on live delivery risks, timing, audience clarity, and presenter choreography.

## Executive Summary

The workshop now has a strong narrative spine:

1. Bad skill
2. Better skill
3. Smarter skill
4. Scaled skill

That is exactly the right shape for an 80-minute hands-on session.

The main live risks are no longer conceptual. They are performance risks:

- timing drift
- unclear transitions
- live-demo friction
- too much presenter explanation during build time
- not enough explicit room choreography

### Bottom line

This workshop should work live **if**:
- Act 1 is tightly choreographed
- demos are pre-baked
- example outputs are strong
- presenters optimize for first success over full explanation
- Act 3 stays disciplined

---

## Core Rehearsal Principle

> Get attendees to a successful first roast as fast as possible.

That is the make-or-break moment.

If the room gets to a successful first run quickly, the workshop gains momentum. If Act 1 bogs down in explanation or setup friction, the rest of the workshop gets compressed.

---

## Biggest Live Risks

## 1. Act 1 is the danger zone

This is the tightest part of the workshop by far.

In ~20 minutes, attendees need to:
- understand what a skill is
- understand why the bad skill is bad
- understand description/triggering
- open the starter file
- customize description
- customize constraints
- understand the scripts at a practical level
- run the skill once
- see the difference

### Rehearsal implication
Rehearse Act 1 down to the minute.

If Act 1 slips by even 5 minutes, the rest of the workshop compresses badly.

### Delivery recommendation
Treat Act 1 as having only **three required audience actions**:
1. Edit description
2. Edit 1–2 constraints / tone
3. Run the first prompt

Everything else is optional.

### Presenter mantra
Do not over-explain before first success.
Get them to the first run fast. Then explain what changed.

---

## 2. Explain mode can overwhelm build mode

The workshop has a lot of sharp ideas:
- constraints
- scripts
- portability
- evals
- production systems
- WorkOS CLI
- agent behavior

That is a strength, but also a delivery risk.

Every extra explanation steals from:
- typing time
- debugging time
- processing time

### Rehearsal principle
For each build act, ask:

> What is the minimum attendees need to hear before they can do the next thing?

Not:

> What is the full ideal explanation?

---

## 3. Description matters — but keep it short

This is a valuable teaching beat and should stay.

### Risk
It can turn into a mini-lecture on routing semantics and tool differences.

### Rehearsal target
Keep the whole beat to **2–3 minutes max**, including:
- why description matters
- negative triggers
- the “ask Claude when it would use the skill” debugging move

### Strong framing line
> Descriptions are routing rules, not marketing copy.

---

## 4. Script explanation can become accidental shell workshop

The `!` script mechanic is central to the workshop, but attendees are here to learn skills, not shell portability.

### Risk
If you go too deep into:
- `grep`
- `git log`
- `xargs`
- platform quirks

…the room will derail into command debugging.

### Delivery recommendation
Teach scripts at the level of:
- “this pulls real evidence into the skill”
- “without this, the model guesses”
- “you can swap these later”

Do not turn Act 1 into shell literacy.

---

## Where Audience Confusion Is Most Likely

## 1. “What exactly am I editing right now?”

This is the most likely hands-on confusion point.

Attendees need repeated explicit guidance:
- which file they are opening
- which section they edit first
- what is required vs optional
- what prompt they type after saving

### Delivery pattern
Use clear checkpoint language:
- “Everyone should now be in the starter skill file.”
- “Only change these three things.”
- “Do not add new scripts yet unless you’re ahead.”
- “When you’re done, type exactly: ‘Roast this repo.’”

---

## 2. “Is this Claude-specific or portable?”

This question will arise implicitly even if no one asks it directly.

### Best speaker strategy
Label tool-specific vs portable concepts in real time:
- “This trigger/debugging move is Claude-specific.”
- “This structural idea is portable.”
- “This execution mechanic depends on the tool.”

That reduces skepticism and keeps the portability story honest.

---

## 3. “What part is the skill versus what part is the tool?”

Attendees may blur together:
- the skill file
- the AI tool / agent runtime
- shell execution
- memory / activation behavior

### Use a recurring 3-part distinction
- **Skill** = the reusable artifact you author
- **Tool** = the environment that loads and runs it
- **Scripts** = how the skill gathers evidence from the environment

Say this early and repeat it.

---

## 4. Audience adaptation may be mistaken for “just tone”

The Act 3 dev / manager / new teammate demo is strong, but some people may initially interpret it as simple rewriting.

### Framing line to land the point
> Scale is not just more tools. It’s more audiences. The same evidence becomes useful differently depending on who needs it.

That helps Act 3 feel like context-aware value delivery, not just copy editing.

---

## Where Timing Is Most Likely To Slip

Ranked by risk:

1. **Act 1 setup + first run**
2. **Act 2 explanation before attendees edit phases**
3. **Closing share/install logistics**
4. **WorkOS CLI proof section drifting into deep detail**

---

## Recommended Presenter Choreography

Two presenters is a huge advantage if roles are clear.

## Driver / Narrator split
At any given moment, one presenter should be:
- driving the artifact / typing / demo

and the other should be:
- narrating what matters
- watching time
- scanning the room for confusion
- handling fallback instructions

If both presenters explain at once, the session feels noisy.
If neither manages the room, it feels loose.

---

## Suggested Roles By Section

### Open
- **Presenter A:** thesis + why skills matter
- **Presenter B:** reacts, sharpens, asks audience-facing framing question

Goal: conversational energy, not monologue.

### Act 1
- **Driver:** edits the live starter skill
- **Support:** translates that into explicit room instructions

Examples:
- “Everyone edit only the description right now.”
- “If you’re done, stop there — constraints are next.”
- “Don’t freestyle ahead yet.”

### Act 2
- One presents the phase pattern
- The other anchors the practical takeaway

Suggested line:
> This is how you stop one-shot chaos.

### Act 3
- One handles story and examples
- The other compresses the takeaway

Suggested line:
> If you remember one thing from this section, it’s this…

### Close
- One drives share/install next steps
- The other reiterates the pattern and points to the handbook

---

## What Should Be On Slides vs Spoken

Too much text on slides will slow the room down.

## Put on slides
- Core promise
- 80-minute arc / timeline
- Bad skill vs good skill
- Starter skill structure (Context / Constraints / Structure / Workflow / Self-Assessment)
- Act 2 workflow phases
- Confidence dimensions (evidence / severity / actionability)
- Act 3 audience adaptation (developer / manager / new teammate)
- End-of-workshop progression summary

## Keep spoken or demo-only
- Long origin stories
- WorkOS CLI deep technical detail
- Eval nuance beyond one clear story / chart
- Routing/debugging nuance across tools

---

## Outputs That Must Be Pre-Baked

These are essential workshop assets.

## 1. Bad Repo Roast output
It should be:
- short
- generic
- obviously weak

## 2. Good Act 1 roast output
It should be:
- concrete
- funny
- evidence-based
- immediately better

This is one of the workshop’s biggest audience reaction moments.

## 3. Good Act 2 phased output
Prepare examples of:
- Phase 1 raw findings
- Phase 2 categorized findings
- Phase 3 prioritized recommendations

Without these, the Act 2 improvement may feel abstract.

## 4. Act 3 multi-audience output
Prewrite the same findings reframed for:
- developer
- engineering manager
- new teammate

The contrast should be instantly legible.

---

## Demo Repo Guidance

The demo repo is one of the most important workshop assets.

It needs to be:
- safe to show publicly
- rich enough to produce good findings
- messy in interesting ways
- not so broken that it becomes depressing
- not so clean that the roast fizzles

### Ideal ingredients
- one conspicuously large file
- several TODO/FIXME/HACK comments
- churn concentration in a few areas
- outdated README or setup instructions
- evidence of multiple contributors
- at least one healthy thing worth praising

That last one matters because the skill includes “one thing the repo does well.”
The output should model fairness, not just dunking.

---

## Rehearsal Checklist By Section

## Open — rehearse for punch
Goal: people immediately understand the problem and the promise.

Must land quickly:
- what a skill is
- why repeated prompting is the pain
- why portability matters
- what they’re leaving with

If this starts wandering into too much nuance too early, trim it.

---

## Act 1 — rehearse as instruction choreography
This section should be dry-run exactly.

Rehearse:
- how attendees get the starter file
- exact edit order
- exact first prompt
- how long they get before regrouping
- what to say if half the room is behind
- what to say if some finish early

Script the checkpoints.

---

## Act 2 — rehearse for visible delta
The key question:

> Is the improvement from Act 1 to Act 2 obvious?

If not, Act 2 will feel abstract.

Need a clear before/after between:
- one-shot roast
- phased roast with evidence filtering and better recommendations

If the delta is subtle, tighten the example outputs.

---

## Act 3 — rehearse for compression
This section should feel fast, confident, and energizing.

Rules:
- no rabbit holes
- no architecture tangents
- no overexplaining eval methodology

Each proof point should resolve in roughly 5–6 minutes.

---

## Close — rehearse for energy, not housekeeping
The close should feel like:
- you built a real thing
- compare it
- keep it
- adapt it next week

If install/share becomes fiddly, emphasize artifact pride over mechanics.

---

## Room Management Notes

## For slower attendees
Use a line like:
> If you’re still editing, that’s okay — stop where you are and use the starter content for the rest. The goal is to get a successful run.

This keeps slower attendees from silently dropping off.

## For faster attendees
Offer only **one** extension path:
> If you’re ahead, add one extra script or tune your tone for a specific audience.

Do not open multiple extension paths.

## For opt-in sharing
Keep saying:
> Roast the repo, not the people.

This matters for psychological safety.

---

## Strongest Recommendation For Rehearsal

Do one full timed run with:
- one person acting as a confused attendee
- one person acting as a fast finisher
- one intentionally sparse repo
- one slightly messy real repo

This rehearsal will expose:
- unclear instructions
- bad timing assumptions
- weak example outputs
- script fragility
- dead-air transitions

You will learn more from this than from another curriculum review.

---

## Internal Timing Targets (Presenter-Only)

These do not need to appear in the workshop docs, but they should exist for rehearsal.

Suggested targets:
- **Open:** 4:30 hard stop
- **Act 1 setup talk before attendees type:** 6 min max
- **Act 1 hands-on + first run:** ~14 min
- **Act 2 explanation before editing:** 4 min max
- **Act 2 hands-on + rerun:** ~21 min
- **Act 3 proof points:** 6 / 6 / 5 min
- **Close:** 8 min + 2 min buffer

---

## Fallback Lines To Prepare

Have exact phrases ready for common workshop friction.

### If a script fails
> If your script failed, leave it as-is and keep going. The skill should skip missing signals instead of guessing.

### If someone only has Claude.ai / Desktop
> Follow along with the demo output — the hands-on path assumes a local coding tool with shell access.

### If some attendees are ahead
> If you’re ahead, don’t branch out yet — add one extra script or tune the tone, then wait for the next checkpoint.

### If attendees are behind
> Stop where you are and use the starter content for the rest. The goal is a successful run, not perfect customization.

### If a live demo hangs
> We’ve got a pre-recorded fallback for this — let’s switch so you can still see the outcome cleanly.

---

## Final Speaker Verdict

The workshop is now in good shape structurally.

It should work well live if the presenters:
- tightly choreograph Act 1
- keep explanation subordinate to progress
- pre-bake all important outputs
- treat the demo repo as a first-class artifact
- rehearse transitions and fallback language

### Final mantra
> First success beats full explanation.

Once attendees get to a successful first roast, the rest of the workshop has momentum.
