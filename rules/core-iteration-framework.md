---
title: "Gap Analysis & Iteration Framework"
impact: "critical"
tags: ["gap-analysis", "vary", "prompt-edit", "ref-gap-closure", "aspect-first"]
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
| Ref-Assisted Gap Closure | `ref_gap_closure` | Introduce a quality-specific `--sref` to break a dimension ceiling |
| Editor Edit | `editor_edit` | Use MJ's built-in editor to selectively mask and regenerate specific image areas |
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
| **Dimension ceiling** — batch avg > 0.75 but one dimension stuck (±0.03) across 2+ prompt edits | Ref-Assisted Gap Closure | Prompt-level keywords have hit their limit for this quality; a visual reference can push past it |
| **Mostly right, want polish** — image is 85%+ match, minor refinements needed | Vary Subtle | Preserve what works, nudge what doesn't |
| **Inconsistency across batch** — some images nail it, others don't, same prompt | Vary Subtle on best | The prompt works; just need the right seed |
| **Everything wrong** — fundamental mismatch with intent | Prompt edit (major rewrite) | Start fresh with different approach |
| **Regional quality split** — some areas are excellent but others have persistent issues | Editor Edit on best candidate | Preserves good areas while regenerating only the problem regions |

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

### Reference-Assisted Gap Closure

When prompt edits can't move a specific scoring dimension, a targeted `--sref` reference can break the ceiling. This is the escalation step between "keep editing the prompt" and "abandon this direction."

**Trigger conditions (all must be true):**
- Batch avg > 0.75 (the prompt is working overall)
- One dimension has been the lowest scorer for 2+ consecutive iterations
- Different prompt strategies (different keywords, parameters, or approaches) moved that dimension by ±0.03 or less

**Procedure:**
1. **Flag the dimension** as a "prompt ceiling" in the gap analysis:
   ```json
   {"prompt_ceiling": {"dimension": "texture", "stuck_score": 0.65, "iterations_stuck": 3}}
   ```
2. **Find a reference image** where the stuck quality is the dominant visual characteristic. For example: a heavily grainy film scan for texture, a backlit silhouette for lighting, a brutalist concrete surface for material.
3. **Blend as secondary sref** with lower weight so it influences the stuck dimension without overriding the primary style:
   ```
   --sref <primary>::2 <quality-ref>::1
   ```
   If no primary sref exists, use the quality reference alone at `--sw 100–150`. See `core-prompt-construction.md` for `--sref` weighting syntax and `--sw` sweet spots.
4. **Log the iteration** with `action_type: ref_gap_closure` and note which dimension the reference targets.

**Why this works:** MJ's `--sref` system reads visual qualities (grain, sharpness, material texture) from the reference image more reliably than prompt keywords can specify them. A reference that embodies the stuck quality provides a direct visual signal for something words couldn't adequately describe.

**When NOT to use this:**
- The stuck dimension is spatial/compositional — sref influences style, not layout
- Batch avg < 0.75 — the prompt has bigger problems than one dimension ceiling
- The dimension moved significantly between iterations but regressed — that's a fragile equilibrium problem, not a ceiling

### Editor Edit (Selective Inpainting)

When specific regions of an image are strong but others have persistent issues, MJ's built-in editor can selectively mask and regenerate only the problem areas. This preserves proven qualities (grain texture, subject rendering, composition) while fixing isolated deficiencies.

**Trigger conditions:**
- Best image has at least one region/element scoring > 0.85 AND another region consistently < 0.80
- The quality split is regional (e.g., great subject but bad background) rather than global (e.g., wrong color palette everywhere)
- Prompt edits have failed to fix the weak region without degrading the strong one (the "tradeoff ceiling" problem)

**Procedure:**
1. Navigate to the best image's detail page and click **Edit**
2. Use **Smart Select** to segment the region to regenerate (clicks on the region to build a selection mask)
3. Click **Erase Selection** to convert the selection into an inpainting mask (checkerboard = erased)
4. Update the prompt to emphasize the desired qualities for the regenerated area
5. Optionally modify parameters — removing `--raw` or `--sref` that may have caused the regional issue
6. Click **Submit Edit** — MJ regenerates only the masked area

See `auto-core-workflows.md` section 6 for the browser automation sequence.

**Known limitations:**
- **Environmental intrusion:** When regenerating backgrounds, MJ tends to introduce walls, corners, and surfaces instead of flat/seamless backdrops — the preserved figure implies a physical space
- **Texture mismatch:** The regenerated area may have a different grain/texture character than the preserved area, creating a visible quality split at the boundary
- **Smart Select reliability:** The segmentation API can fail; fall back to manual Erase tool painting if it does
- **Single image output:** Editor edits generate a new 4-image batch, but all share the same preserved regions — less variance than full generations

**When NOT to use this:**
- The issue is global (color, mood, overall style) — editor can't fix what's in the preserved pixels
- The boundary between good and bad regions is fuzzy or overlapping
- The quality split is between foreground elements (hard to segment cleanly)

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
