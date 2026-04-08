# Notes

This document contains notes I'm taking while I go through the workshop. These are things I want to `add:`, `fix:`, `change:`, or `discuss:`. I'll provide the slide number at the time of going through it too for notes I make about specific slides.

## Sync agenda with Zack

### 1. Overall narrative arc
- The whole thing feels disjointed — not telling a complete story yet
- slide 3 jumps right into "You've done this before" — is that the best open?
- The three audiences framing feels contrived. Cut it or rework?

### 2. Workshop content questions
- slide 14 — is the advice really "tell the model what NOT to do"? Confirm this is correct.
- "Let's talk about" section lists — who wrote these? Need to improve relevance.
- slide 22 — phase-gating: LLMs can just ignore phases. How do we address this honestly?

### 3. "Why this scales" section (Act 3)
- Says 20 minutes but only 3 slides. What fills the time?
- **Proposal:** This is where the Agent SDK demo lives — show skills composing into programmatic agents via the WorkOS CLI target. Natural fit for the time.
- Also demo where to find skills (plugin registries, GitHub, `../skills` as reference)

### 4. Audience interaction
- Can't hook up their machines or share skills back to us... or can we?
- Idea: a script attendees run that sends their current skill to us for a quick live run
- Worth the prep effort? Could be a highlight moment.

### 5. New discussion topics
- **Agent SDK + skills** — fits Act 3 proof of scale, connects to WorkOS CLI demo
- **Skill customizations in pi** — (clarify: what is "pi"? spell out for the agenda)
- **Where to find skills** — practical closer, audience will want this

### Done

- ~~fix: on slide 1, remove the subtitle~~ ✅
- ~~add: WorkOS slide after intros~~ ✅
- ~~fix: slide 4, better skill introduction~~ ✅
- ~~fix: slides 5-6, show good skill code not just output~~ ✅
- ~~fix: slide 8, correct repo URL + cover setup.sh~~ ✅
- ~~fix: slide 9, harness-agnostic skill loading~~ ✅
- ~~fix: quote section intros~~ ✅ Converted all 4 to story/lesson slides
- ~~fix: slide 12, Slidev long output truncation~~ ✅ Condensed from 34 to 26 lines
- ~~add: early introduction of the skill we're building + customization emphasis~~ ✅

## New Notes

- Give examples of how attendees might customize this skill - they could stress importance of specific tests, specific. The script could do things like check that you're following specific testing formats, doing specific review guidelines or README formats. Workflows are granular or set up in a certain way 
  reviews, etc. - let's brainstorm
- combine talk topics and workshop tasks on the same slide. Make sure the slide also has an allotted time displayed so
  we know how long to pause for.
- Slide 16 - The phases don't make sense. How would you progressively disclose different pieces of the steps? It should
be instead: "If you need to do this, then load this file. If you need to do this other thing, load this other file."
Let's codify that into a realistic example in this slide
- In some slides we talk about using the `cp` command directly to copy checkpoint files and in others we talk about setting that up and being able to do that. Can we consolidate onto a single way of doing that? 
- We don't really mention in the slides about doing the share scripts. I think that should be highlighted. Should be on all of the phases or just the second and third one? Upon further review I see that we're doing it at the end and maybe that's a better solution anyway. We should mention that we're going to do that in the beginning and people should prepare. That way we build excitement and encourage participation 
- We also need to combine slides 19 and 20 
- The last slide talks about remembering the show of hands. Did we have them show hands at some point? That should be more clearly called out if so or we should remove it from the last slide 
