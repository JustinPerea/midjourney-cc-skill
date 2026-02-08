---
title: "Gap Analysis & Iteration Framework"
impact: "critical"
tags: ["gap-analysis", "vary", "prompt-edit", "aspect-first"]
---

# Gap Analysis & Iteration Framework

How to analyze gaps between intent and output, decide which action to take next, manage iteration limits, and use the aspect-first approach for complex subjects.

## Gap Analysis Framework

When a generation doesn't match intent, analyze:

1. **What was missing?** - Elements from the intent that don't appear in output
2. **What was wrong?** - Elements that appeared but incorrectly
3. **What was unexpected?** - Elements that appeared but weren't intended
4. **Hypothesis** - Why the gap exists and what change might fix it

Common causes:
- Keyword interpreted differently than intended
- Keyword conflict (two descriptors pulling in opposite directions)
- Parameter mismatch (stylize too high/low for the desired look)
- Missing specificity (vague descriptor produced generic result)
- MJ version behavior change

### Extended Gap Analysis JSON Structure

For iteration 2+, the `gap_analysis` column should include delta tracking and decision reasoning. This is where the most valuable learning data emerges — understanding what change caused what effect.

```json
{
  "core": {
    "missing": ["warm rim light from right"],
    "wrong": ["lighting is single-source cool instead of dual-tone"],
    "unexpected": ["geometric shapes in background"],
    "hypothesis": "dual-tone keyword was overridden by 'studio lighting'"
  },
  "delta": {
    "from_iteration": 1,
    "keywords_added": ["floating on pure black void"],
    "keywords_removed": ["punk zine aesthetic"],
    "keywords_modified": [],
    "parameters_changed": {"--s": "50 → 75"},
    "structural_changes": "removed layout-triggering descriptor, added isolation language",
    "effect_observed": {
      "improved": ["spatial_relationships", "composition"],
      "degraded": [],
      "unchanged": ["color", "mood"],
      "score_delta": "+0.13 batch avg"
    }
  },
  "action_decision": {
    "chosen": "prompt_edit",
    "reason": "All 4 images showed same layout problem — structural prompt issue, not MJ variance",
    "alternatives_considered": ["vary_strong on img-4"],
    "why_not_alternatives": "Vary wouldn't fix the collage trigger keyword"
  }
}
```

## Iteration Management

Use these decision trees to guide the refinement process.

**After first generation:**
- If one image in the grid is close → Upscale it, note what's off, refine prompt for next round
- If all 4 are off in the same way → Structural prompt issue, major revision needed
- If all 4 are off in different ways → Prompt is ambiguous, simplify and be more specific
- If none are close → Step back, try a fundamentally different approach

**After variations (V1-V4):**
- If variations improve → Continue exploring this direction
- If variations are all similar → The prompt is maxed out in this direction, change keywords
- If variations regress → The original was better, upscale original and try parameter tweaks

**Iteration limits:**
- **Soft limit: 3 iterations** — If not converging after 3, review approach with user
- **Pivot at 5** — If still not working, try completely different prompt structure or vocabulary
- **Change approach at 7+** — Consider `--sref`, different aspect ratio, or breaking into simpler sub-problems

**Between iterations, always:**
1. Log the current iteration via `/log-iteration` or inline
2. Check `knowledge/failure-modes.md` for matching diagnostic patterns
3. Consult `knowledge/translation-tables.md` if struggling to find the right keywords
4. Apply the gap analysis framework to identify the specific fix

## Iteration Action Decision Framework

After each iteration, the agent must decide the next action. This decision is tracked per iteration (`action_type` and `parent_image` fields) so the system can learn which actions work best for which gap types.

### Action Types

| Action | DB Value | When to Use |
|--------|----------|-------------|
| Initial generation | `initial` | First prompt in a session |
| Prompt edit | `prompt_edit` | Rewrite or modify the prompt text and regenerate |
| Vary Subtle | `vary_subtle` | Small refinements to a specific image |
| Vary Strong | `vary_strong` | Bigger changes while keeping the direction |
| Rerun | `rerun` | Same prompt, new seed — test consistency |
| Upscale Subtle | `upscale_subtle` | Image is good, increase resolution faithfully |
| Upscale Creative | `upscale_creative` | Image is good, increase resolution with enhancement |

### Decision Heuristic (Starting Point)

These rules are the starting heuristic. As iterations accumulate, reflection should extract evidence-based patterns that override or refine these rules.

| Gap Type | Recommended Action | Rationale |
|----------|-------------------|-----------|
| **Conceptual miss** — MJ didn't understand the intent | Prompt edit (major) | Words need changing, not the image |
| **Single element wrong** — one detail (position, color, count) off but rest is good | Vary Subtle on best candidate | Most things are right; small nudge fixes the rest |
| **Right concept, wrong execution** — the idea is there but rendering/style is off | Vary Strong on best candidate | Keep the direction, remix the details |
| **Multiple elements wrong** — 2+ things need fixing simultaneously | Prompt edit | Too many things to fix through variation alone |
| **Mostly right, want polish** — image is 85%+ match, minor refinements needed | Vary Subtle | Preserve what works, nudge what doesn't |
| **Inconsistency across batch** — some images nail it, others don't, same prompt | Vary Subtle on best | The prompt works; just need the right seed |
| **Everything wrong** — fundamental mismatch with intent | Prompt edit (major rewrite) | Start fresh with different approach |

### When to Vary vs. Prompt Edit

**Prefer Vary (Subtle or Strong)** when:
- Best image scores > 0.80 overall
- The gap is about execution, not concept
- You want to preserve specific qualities (exact color, composition, mood)
- Only 1-2 dimensions need improvement

**Prefer Prompt Edit** when:
- Best image scores < 0.70 overall
- The gap is conceptual (MJ interpreted the prompt differently than intended)
- The same element is wrong across all 4 images (batch-level failure = prompt problem)
- You need to add or remove a major element

### Logging Actions

Every iteration must record:
- `action_type`: One of the values from the table above
- `parent_image`: Which image number (1-4) from the previous iteration this was derived from. NULL for `prompt_edit`, `rerun`, and `initial`.

## Aspect-First Iterative Approach

An alternative to the standard "full prompt" approach where all visual qualities are specified at once. Instead of balancing many competing concepts in a single prompt, this method isolates and perfects one visual aspect at a time, then builds outward using Vary Strong/Subtle to preserve what works.

### Why This Works

- **Reduces prompt complexity.** Fewer competing concepts means MJ can focus on getting one thing right. Keywords don't fight each other.
- **Cleaner learning signal.** When a minimal prompt produces the intended effect, you know exactly which keywords caused it. Better data for keyword effectiveness tracking.
- **Avoids the fragility problem.** Complex prompts are fragile equilibria — fixing one element often breaks another.
- **Leverages Vary effectively.** Once you have a strong base image with the key aspect nailed, Vary Strong can introduce additional elements while the base quality carries through.

### Workflow

1. **Identify the hardest visual element** — the thing MJ is most likely to misinterpret or that requires the most precise keyword control. This becomes the Phase 1 target.
2. **Phase 1: Minimal prompt** — Strip everything except the target element. Use low `--s` and `--style raw` for maximum prompt adherence. Generate batches until the target element is correct.
3. **Phase 2: Vary Strong + expanded prompt** — Take the best Phase 1 image and use Vary Strong with an expanded prompt that adds the next layer (e.g., body, hair, color). The Phase 1 quality "anchors" through the variation.
4. **Phase 3: Vary Subtle for polish** — Refine texture, atmosphere, and fine details on the best Phase 2 result.

### When to Use This Approach

- The subject has **contrasting rendering modes** in different parts (e.g., 2D face + 3D body)
- The prompt requires **unusual or counterintuitive combinations** that MJ tends to resolve by ignoring one element
- Previous attempts show a pattern of **fixing one thing breaks another**
- The reference has a **single defining quality** that everything else builds around

### When NOT to Use This Approach

- The subject is straightforward and MJ handles it well in one prompt
- Time is limited — this approach uses more iterations
- The visual qualities are deeply interconnected and can't be separated (e.g., a specific lighting-color-material interaction)

### Logging

Tag iterations with their phase in the `gap_analysis` field:
```json
{"approach": "aspect-first", "phase": 1, "target_aspect": "void face with pink neon eyes"}
```

## Related Rules

- `core-assessment-scoring` — Produces the scores that drive action decisions
- `core-prompt-construction` — Handles the actual prompt rewriting
- `learn-data-model` — Stores iteration data including action_type and parent_image
