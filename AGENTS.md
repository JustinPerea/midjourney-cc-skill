# Midjourney Prompt Learning System — Complete Reference

> Auto-generated from rules/ directory. Do not edit directly.
> Regenerate with: ./scripts/build.sh

---

# Core Prompt Engineering


# Assessment Scoring Guide

How to score Midjourney outputs on 7 standard dimensions, handle agent confidence levels, and work around known limitations.

## Score Scale

| Score | Meaning |
|-------|---------|
| 0.0-0.2 | Completely wrong / not present |
| 0.3-0.4 | Vaguely there but wrong execution |
| 0.5-0.6 | Partially correct, needs significant work |
| 0.7-0.8 | Close, needs refinement |
| 0.9-1.0 | Nailed it |

## Standard Scoring Dimensions (Always Use All 7)

**Every iteration must be scored on all 7 dimensions.** This ensures batch averages are comparable across iterations and sessions. If a dimension isn't relevant to the intent (e.g., spatial_relationships for a flat graphic), score it 1.0 with a note "not applicable — no spatial element in intent."

| Dimension | Key | What to Assess |
|-----------|-----|----------------|
| Subject | `subject` | Does the main subject/form match intent? |
| Lighting | `lighting` | Is the lighting setup correct? (direction, color, intensity, atmosphere) |
| Color | `color` | Are the colors, palette, temperature, saturation correct? |
| Mood | `mood` | Does the overall feeling/emotion match? |
| Composition | `composition` | Is the framing, layout, subject position, depth correct? |
| Material | `material` | Are materials, textures, surface qualities correct? |
| Spatial Relationships | `spatial` | Are grounding, floating, scale, contact points, physics correct? |

**Score JSON format** (use this exact structure for every image):
```json
{
  "subject": 0.85, "lighting": 0.90, "color": 0.88,
  "mood": 0.90, "composition": 0.80, "material": 0.92,
  "spatial": 0.75, "avg": 0.86,
  "notes": "Concrete observations for each dimension"
}
```

## Agent Confidence Flags

For each dimension, the agent should self-assess confidence. Flag dimensions where confidence is low so the user knows where to focus validation:

| Confidence | When | Action |
|------------|------|--------|
| **High** | Clear, unambiguous visual evidence | Present score normally |
| **Medium** | Some ambiguity but reasonable assessment | Note "moderate confidence" |
| **Low** | Known limitation area or ambiguous visual | Flag explicitly, ask user to validate before logging |

**Known low-confidence dimensions:** spatial_relationships (see Known Agent Limitations below). Others may emerge — update this list when they do.

## Image-Based Assessment (Preferred)

When the user shares the MJ output image or images are captured via browser automation (see `rules/auto-core-workflows.md`), perform the assessment yourself:

1. **Load reference image(s)** (if available) for direct visual comparison:
   ```sql
   SELECT reference_image_path, reference_analysis FROM sessions WHERE id = ?
   ```
   - Parse `reference_image_path` as a JSON array. If it's a bare string (legacy), treat it as `["<path>"]`.
   - Load **all** reference images that exist on disk and compare against the output.
   - If multiple references exist, score against the **composite `reference_analysis`**: shared defining qualities are scored strictly, variable qualities are scored against session intent (see `rules/core-reference-analysis.md`).
   - If no reference images are on disk, fall back to the text-based `reference_analysis` JSON and session intent.
   - **Flag which method was used** — "scored against reference image", "scored against composite reference (N images)", or "scored against text description."
2. **Look at the output image** against the reference (image or text).
3. **Score all 7 standard dimensions** based on what you actually see.
4. **Write concrete observations** for each dimension, not just scores. Example:
   - lighting: 0.4 — "Single cool light source from above. The intended warm orange rim light from right is absent. No dual-tone effect."
   - subject: 0.8 — "Organic form is present and flowing. Slightly more geometric than intended, but close."
   - spatial: 0.75 — "**[LOW CONFIDENCE]** Cube appears to be on the surface but there may be a subtle gap. User should confirm."
5. **Identify the top 2-3 gaps** that matter most for the next iteration.
6. **Present scores as PRELIMINARY.** Explicitly ask the user to confirm or correct before logging:
   - "Here's my preliminary assessment. Dimensions flagged with [LOW CONFIDENCE] need your input. Do these scores look right, or should any be adjusted?"
   - Wait for user response before inserting into the database.
   - Record in the iteration whether scores were validated: `scores_validated = 1` if user confirmed/corrected, `0` if agent-only.

## Known Agent Limitations

Track known limitations of the agent's analysis capabilities. These inform where human validation is most critical and where system improvements should be explored.

### Spatial Relationship Assessment

**Limitation:** The agent can struggle to perceive subtle spatial gaps between objects and surfaces, particularly:
- Small levitation/floating gaps between an object and the ground
- Subtle differences between "sitting on surface" and "hovering just above surface"
- Atmospheric haze or shadow that blurs the boundary between contact and gap

**Mitigation:** When scoring the `spatial_relationships` dimension (especially grounding/floating/levitation), always present the assessment to the user and explicitly ask for their validation before finalizing scores. Flag spatial assessments as "needs user confirmation" in the analysis.

## Related Rules

- `core-reference-analysis` — Produces the reference to score against
- `core-iteration-framework` — Uses scores to decide next action
- `learn-data-model` — Stores scores in the iterations table

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

---

# Prompt Construction Best Practices

V7 prompt structure, keyword selection, and the knowledge application checklist to run before building any prompt.

## Baseline Rules

These are starting-point rules. Learned patterns override these when evidence supports it.

**Key V7 insight from MJ docs:** "Short, simple prompts work best." V7 has much better natural language understanding than previous versions. Don't over-complicate.

**V7 Prompt Structure (most to least important):**
```
[Subject] → [Environment] → [Style/Mood] → [Lighting] → [Composition] → [Parameters]
```

V7 weights the beginning of the prompt more heavily. Front-load what matters most.

**Seven key prompt areas** (from MJ documentation):
1. **Subject** - The main focus
2. **Medium** - Art style/technique (oil painting, photograph, 3D render)
3. **Environment** - Where the scene takes place
4. **Lighting** - How the scene is lit
5. **Color** - Color palette and mood
6. **Mood** - Emotional tone
7. **Composition** - How elements are arranged

**Ten construction rules:**

1. **Front-load the subject** - Put the most important element first (V7 amplifies this)
2. **Simpler is better in V7** - V7 doesn't need the complexity V6 required
3. **Be specific about lighting** - Don't rely on MJ to interpret "good lighting"; use `knowledge/translation-tables.md` for keyword mapping
4. **Use concrete descriptors** - "matte ceramic" not just "smooth"
5. **Specify what you DON'T want** - Use `--no` for common unwanted elements
6. **Match stylize to intent** - Lower `--s` for prompt adherence, higher for MJ creativity; see `knowledge/v7-parameters.md` for ranges
7. **One style reference** - Multiple render engine names cause confusion
8. **Separate concerns** - Subject, then environment, then lighting, then style, then parameters
9. **Check templates** - Before building from scratch, check `knowledge/prompt-templates/` for a relevant starting point
10. **Use `--draft` for exploration** - 10x faster, half cost; switch to full quality once direction is confirmed

## Knowledge Application Check

Before constructing any prompt, run this mental checklist (queries are in `rules/learn-data-model.md`):

1. What categories does this request touch? (lighting, material, form, color, mood, style, composition, parameters)
2. For each category, are there active patterns with medium+ confidence?
3. **Score each pattern for relevance to this specific task**, not just category match. Consider:
   - Does the pattern's problem description match the current situation?
   - Does the pattern have conditional notes (from contrastive refinement) — and does the current task match the success conditions or failure conditions?
   - Is the pattern's specificity level appropriate? (universal always applies; specific only when exact context matches)
   - When was the pattern last validated, and for which MJ version?
4. Are there any failure modes to avoid? Pay extra attention to failure modes whose trigger conditions overlap with the current task.
5. Are there keyword effectiveness ratings relevant to the descriptors I'm considering?
6. Has a similar reference been translated before? (check `reference-translations/`)

Present applied patterns in relevance tiers: **strong match**, **likely relevant**, **worth trying**, and **anti-patterns to avoid**. This gives the user clarity about which recommendations are battle-tested for their specific case versus extrapolated from adjacent experience.

## Style Codes (`--sref` Numeric Codes)

MJ maintains an internal style library accessible via numeric codes. These are distinct from `--sref <image_URL>` (which transfers style from a specific image) — numeric codes reference predefined aesthetics curated by MJ and the community.

### Syntax

```
--sref 2417366470                         # Apply a single style code
--sref 45668 2987633446                   # Blend two styles (equal weight)
--sref 404370912::3 3712786097::1         # Weighted blend (3:1 ratio)
--sref <image_URL> 1225796221             # Combine image reference with style code
--sref random                             # Apply a random style (reveals the code used)
```

### Key Parameters

| Parameter | Purpose | Range | Default |
|-----------|---------|-------|---------|
| `--sref <code>` | Apply style code(s) | Any numeric code | — |
| `--sw` | Style weight (how strongly style influences output) | 0–1000 | 100 |
| `--sv 4` | Use old V7 model for backward compat with pre-V7 style codes | — | current model |

**`--sw` sweet spot:** 65–175 for most uses. Below 100 dilutes the style; above 100 amplifies it. At 200+ structural features from the style also transfer (not just aesthetic).

### Discovery Methods

1. **Style Explorer** — Browse `midjourney.com/explore?tab=styles_top_month` to discover trending community styles. Search by keyword (e.g., "photographic", "anime"). Save favorites for later.
2. **`--sref random`** — Generates with a random style and reveals the code in the job metadata. Good for serendipitous discovery.
3. **Style Creator** — MJ's tool for creating your own style codes from images or prompts.
4. **Community libraries** — Sites like midlibrary.io catalog thousands of codes with visual previews.

### When to Use Style Codes vs Other Approaches

| Scenario | Best Approach |
|----------|--------------|
| Want a specific curated aesthetic without a reference image | `--sref <code>` |
| Want to match an existing image's style | `--sref <image_URL>` |
| Want to blend multiple aesthetics with control | `--sref code1::weight code2::weight` |
| Exploring — don't know what style you want | `--sref random` (iterate from discoveries) |
| Learning what keywords produce specific effects | Prompt-only (no --sref) |
| Need reproducible style across many prompts | Style codes (more stable than image URLs) |

### V7 Notes

- V7's style reference system was rebuilt — old style codes from V6 may produce different results. Use `--sv 4` to access the old model's interpretation.
- V7 is "much smarter at understanding the style of an image" and better at isolating style from subject (less "subject leakage").
- Style codes are reproducible across sessions — same code always produces the same aesthetic. This makes them excellent for iterative refinement: once you find a code that works, it's stable.

### Integration with Iterative Workflow

During a session, style codes can be introduced at any iteration:
- **Initial exploration:** Start with `--sref random` to discover aesthetics, note codes that work
- **Refinement:** Lock in a code and iterate on prompt language while keeping the style constant
- **Blending:** Combine a discovered code with an image reference for hybrid styles
- **A/B testing:** Compare the same prompt with different style codes to isolate aesthetic effects

Log the style code(s) used in each iteration's parameters field for pattern extraction during reflection.

## Related Rules

- `core-reference-analysis` — Produces the analysis that feeds prompt construction
- `core-research-phase` — Fills knowledge gaps before constructing the prompt
- `learn-data-model` — Contains the SQL queries for pattern and keyword lookups

## Official Documentation

When uncertain about V7 behavior, check the authoritative source. See `knowledge/official-docs.md` for the full index. Key pages for prompt construction:

- [Style Reference](https://docs.midjourney.com/hc/en-us/articles/32180011136653) — `--sref`, `--sw`, style codes, Style Explorer
- [Art of Prompting](https://docs.midjourney.com/hc/en-us/articles/32835253061645) — Official prompt technique guide
- [Prompt Basics](https://docs.midjourney.com/hc/en-us/articles/32023408776205) — Core prompting principles
- [Raw Mode](https://docs.midjourney.com/hc/en-us/articles/32634113811853) — `--style raw` behavior
- [Parameter List](https://docs.midjourney.com/hc/en-us/articles/32859204029709) — Complete parameter reference

---

# Reference Analysis & Visual Framework

How to analyze reference images and text descriptions, translate visual observations into effective MJ prompt vocabulary, and build a comprehensive understanding of the target aesthetic.

## Reference Analysis Template

When the user provides a reference — whether as an image, a text description, or both — produce this analysis. If they share an image, your visual analysis is the starting point and they correct or confirm. If they describe it in text, extract what you can and ask about gaps. If they provide both, combine them — the image shows what words may not capture, and the description reveals intent the image alone doesn't convey.

```json
{
  "subject": "What is the main subject/form?",
  "lighting": {
    "type": "flat / single-source / dual-tone / dramatic / ambient / etc.",
    "key_light": "Direction and color of main light",
    "fill_light": "Direction and color of fill",
    "rim_light": "Direction and color of rim/edge light",
    "atmosphere": "Volumetric / haze / clean / etc."
  },
  "colors": {
    "palette": ["list", "of", "dominant", "colors"],
    "temperature": "warm / cool / mixed",
    "saturation": "vivid / muted / desaturated"
  },
  "material": "What material/texture dominates?",
  "composition": {
    "framing": "close-up / medium / wide / etc.",
    "subject_position": "centered / rule of thirds / etc.",
    "depth": "shallow DOF / deep focus / etc.",
    "negative_space": "minimal / moderate / lots"
  },
  "spatial_relationships": {
    "grounding": "sitting on surface / floating / levitating / embedded / suspended / anchored",
    "gravity": "normal / defied / zero-g / impossible physics",
    "scale": "How do objects relate in size? Any scale distortion?",
    "contact_points": "Where/how do objects touch surfaces or each other? Gaps, shadows, reflections at base?",
    "surreal_elements": "Any physically impossible arrangements? (floating objects, impossible geometry, gravity-defying poses)"
  },
  "mood": "Overall feeling/emotion",
  "style": "Photography / 3D render / illustration / etc.",
  "render_quality": "What rendering engine or technique does this look like?"
}
```

### How to Analyze a Reference Image

When you look at a reference image, go beyond surface description. Think about it from a prompt-engineering perspective:

1. **What makes this image look the way it does?** Identify the specific technical choices — not just "it's moody" but "low-key lighting with a single warm source from upper left, deep shadows, desaturated palette except for orange accents."
2. **What would be hardest to reproduce in MJ?** Flag the elements that are most likely to require specific keyword choices or parameter settings.
3. **What could MJ misinterpret?** If the reference has subtle qualities (e.g., a specific glass refraction pattern, a particular paper texture), note that these will need explicit prompting.
4. **Map visual qualities to prompt language.** For each notable quality, suggest the keywords and descriptors that would produce it — drawing from the keyword effectiveness database.
5. **Check spatial relationships and physics.** Does the subject sit on, float above, or embed into surfaces? Are there gaps, shadows beneath floating objects, or impossible physical arrangements? These details are easy to overlook but critical for surreal/conceptual images — MJ defaults to grounded objects unless explicitly told otherwise.

## Visual Analysis Framework (7 Elements)

Before prompting, systematically analyze any reference image using these seven formal art elements. This framework is based on art criticism methodology and ensures comprehensive visual description.

**Sources:** [Student Art Guide](https://www.studentartguide.com/articles/how-to-analyze-an-artwork), [Getty Education](https://www.getty.edu/education/teachers/building_lessons/formal_analysis.html), [Kennedy Center](https://www.kennedy-center.org/education/resources-for-educators/classroom-resources/articles-and-how-tos/articles/educators/visual-arts/formal-visual-analysis-the-elements-and-principles-of-compositoin/)

| Element | Questions to Ask | Prompt-Relevant Observations |
|---------|-----------------|------------------------------|
| **1. LINE** | What is the character of the lines? Thick/thin, soft/bold, mechanical/organic, continuous/broken? What direction — horizontal, vertical, diagonal, curved, implied? How dense — sparse, accumulated, layered? What edge treatment — hard, soft, dissolved, feathered? | "fine ink lines", "bold brushstrokes", "hair-thin strokes", "nervous scratchy marks", "flowing continuous lines", "broken interrupted lines" |
| **2. SHAPE/FORM** | Geometric or organic? Hard-edged or soft? How does positive space relate to negative space? What are the dominant silhouettes? | "organic flowing forms", "geometric angular shapes", "soft dissolved edges", "hard graphic silhouettes" |
| **3. VALUE/TONE** | What is the tonal range — high contrast or low contrast? High key (light) or low key (dark)? Where is the light source? How do values create depth or flatness? | "high contrast", "low key dark", "dramatic chiaroscuro", "subtle tonal gradations", "flat graphic values" |
| **4. COLOR** | What is the palette — warm, cool, monochromatic, complementary? Saturation level — vivid, muted, desaturated? Temperature relationships? Transparency/opacity? | "muted teal and slate", "vivid saturated", "desaturated earth tones", "cool monochromatic", "warm golden accents" |
| **5. TEXTURE/SURFACE** | What is the physical quality — smooth, rough, matte, glossy? What marks made this — brush, pen, spray, digital? What substrate — canvas, paper, metal? | "visible brushwork texture", "smooth digital render", "rough impasto", "matte finish", "glossy reflective surface" |
| **6. SPACE** | Is the depth flat, shallow, or deep? How dense are the elements? What is the figure/ground relationship? | "flat graphic space", "deep atmospheric perspective", "shallow depth of field", "dense accumulated elements", "isolated on void" |
| **7. TECHNIQUE/MEDIUM** | What tool made these marks? What process — layered, wet-on-wet, impasto, glazing? What does the surface suggest about how it was made? | "ballpoint pen linework", "acrylic washes", "oil glazes", "watercolor bleeds", "digital painting", "screen print" |

**How to use this framework:**

1. **Go through all 7 elements systematically** — don't skip any, even if they seem less important
2. **Be specific, not vague** — "fine accumulated ink lines on dark wash ground" not "nice lines"
3. **Note relationships** — how do elements interact? (e.g., "high contrast between fine light lines and dark negative space")
4. **Identify the defining characteristics** — what 2-3 elements most define this image's look?
5. **Translate to prompt language** — use the prompt-relevant observations column as a starting point

## Vocabulary Translation Layer

**The core problem:** Visual analysis vocabulary ≠ effective prompt vocabulary. Art-critical terms describe what you *see*, but MJ needs terms that trigger the right *training data associations*.

**Example of the translation gap:**
- You observe: "Fine parallel lines building density into organic forms"
- Bad prompt vocabulary: "topographic contours", "hatching", "line-cluster shapes"
- MJ interprets: Geological maps, technical drawings, rocks
- Good prompt vocabulary: "sumi-e brushwork", "calligraphic flow", "sweeping brush lines"
- MJ interprets: Flowing ink art, organic motion, gestural marks

**After completing the 7-element analysis, do a second pass with these translation questions:**

1. **What art-historical style/movement does this evoke?** (impressionist, ukiyo-e, art nouveau, sumi-e, etc.)
2. **What medium keywords would produce this mark-making?** (brush pen, ink wash, oil impasto, digital painting, etc.)
3. **What mood/feeling words capture the energy?** (dynamic, serene, gestural, precise, expressive, etc.)
4. **What vocabulary should we AVOID?** (words that trigger wrong associations)

**Common Translation Mappings:**

| Visual Observation | Avoid These (Wrong Associations) | Use These Instead |
|--------------------|----------------------------------|-------------------|
| Fine parallel flowing lines | topographic, hatching, contour, technical | sumi-e, calligraphic, brush lines, fluid strokes |
| Lines building density | clusters, groups, accumulated | layered brushwork, building strokes, gestural marks |
| Organic curved forms | isolated shapes, blobs | flowing forms, undulating, sweeping curves |
| Hand-drawn quality | ballpoint pen, handmade | expressive linework, gestural, brush pen drawing |
| Soft dissolved edges | blurry, unfocused | sfumato, soft gradients, feathered edges |
| High contrast light/dark | black and white | chiaroscuro, dramatic lighting, tenebrism |
| Visible individual marks | textured, rough | impasto, visible brushstrokes, painterly |
| Water/fluid motion | liquid, wet | dynamic flow, rhythmic curves, current-like |

**The key insight:** MJ's training data associates certain words with certain visual patterns. "Topographic" triggers maps and geology. "Sumi-e" triggers flowing ink art. The same visual quality needs different vocabulary depending on what training data you want to activate.

**Using the Describe Tool for Vocabulary Discovery:**

Midjourney's **Describe** tool is invaluable for translation. Upload any reference image and MJ generates 4 creative prompt suggestions that could recreate it. This reveals:
- Keywords MJ associates with visual qualities you want
- Vocabulary you wouldn't have thought of
- How MJ interprets specific visual elements

**Workflow:** Before building a prompt for a reference, run Describe on it and note which keywords appear. These are vocabulary the model already associates with your target aesthetic.

**Building your vocabulary:**

1. When a keyword works well, note it in `keyword_effectiveness` with the visual quality it produced
2. When a keyword fails, note what it produced instead — this reveals MJ's associations
3. Use Describe on successful reference images to discover effective vocabulary
4. Over time, build a personal translation dictionary from visual observations to MJ-effective vocabulary

## Composite Reference Analysis (Multiple Images)

When the user provides **multiple reference images** as style exemplars (same aesthetic, possibly different subjects), produce a composite analysis that captures what they share.

### Workflow

1. **Analyze each image individually** using the full 7-element framework above. Produce a separate reference analysis JSON for each.

2. **Identify shared vs variable qualities** across all images:
   - **Shared qualities** appear in all (or most) reference images — these define the target aesthetic.
   - **Variable qualities** differ across images — these are subject-dependent, not style-defining.

3. **Build a composite `reference_analysis` JSON** that replaces the single-image analysis:

```json
{
  "source_count": 3,
  "shared_defining_qualities": {
    "lighting": { "type": "soft ambient", "atmosphere": "hazy" },
    "colors": { "palette": ["teal", "coral", "cream"], "temperature": "warm", "saturation": "muted" },
    "material": "smooth gradient transitions",
    "mood": "dreamy, ethereal",
    "style": "digital illustration with airbrush quality",
    "render_quality": "soft-focus, painterly"
  },
  "variable_qualities": {
    "subject": "differs across references — one portrait, one landscape, one abstract",
    "composition": { "framing": "varies", "depth": "consistently shallow" }
  },
  "per_image_notes": [
    "Image 1: Portrait with teal-to-coral gradient, centered subject",
    "Image 2: Landscape with same palette, wide framing",
    "Image 3: Abstract forms, same color temperature and soft rendering"
  ]
}
```

4. **Present the composite** to the user. Highlight what you identified as shared vs variable, and let them correct the classification.

### Scoring Implications

- **Shared defining qualities** are scored strictly — the output must match these.
- **Variable qualities** are scored against the session intent, not the references. The user's stated subject/composition goals take priority over any single reference image.

## Related Rules

- `core-prompt-construction` — Uses analysis output to build prompts
- `core-assessment-scoring` — Scores outputs against the reference analysis (composite when multiple images)

---

# Research Phase

When the internal knowledge base has low coverage for a new type of generation request, the system can research community techniques to inform the first attempt. This avoids wasting iterations rediscovering techniques the community already knows.

**Status:** Phase: Testing

## Coverage Assessment

After applying knowledge (step 5 in `/new-session`), compute a coverage score:

| Signal | Weight | Calculation |
|--------|--------|-------------|
| Pattern matches | 0.40 | `min(1.0, (strong_matches * 3 + likely_relevant * 2 + worth_trying) / 6)` |
| Keyword data | 0.30 | `descriptors_with_good_data / total_key_descriptors` |
| Similar sessions | 0.30 | `min(1.0, similar_successful_sessions / 2)` |

**Auto-trigger threshold:** coverage < 0.3

Always present the coverage summary to the user regardless of score.

## Research Workflow

**Budget:** Max 3 WebSearch queries + 2 WebFetch page extractions (~30s wall time)

**Query templates** (pick 3-5 most relevant to the intent):
1. Core technique: `"midjourney v7" "{primary_concept}" prompt`
2. Reddit community: `site:reddit.com/r/midjourney "{concept}" tips`
3. Failure-specific: `"midjourney" "{hard_aspect}" how to`
4. Parameter-specific: `"midjourney v7" --style raw "{concept}"`
5. Prompt examples: `"midjourney prompt" "{concept}" example`

**Extraction prompt for WebFetch:**
> Extract Midjourney prompt techniques for [CONCEPT]. For each: specific keywords, parameters, source context, caveats. Focus on actionable V7 techniques, ignore general advice.

## Presentation Rules

Internal knowledge and research findings must always be presented separately:
- **Internal knowledge** = "battle-tested" (has logged evidence from real iterations)
- **Research findings** = "community techniques (unvalidated)" (no local evidence yet)

In prompt construction, internal knowledge forms the backbone. Research findings are layered as experimental additions. Each element should be annotated with its source so the user and reflection system can track what came from where.

## Session Tagging

Research-assisted sessions are tagged for reflection tracking:
```sql
UPDATE sessions SET tags = json_insert(COALESCE(tags, '[]'), '$[#]', 'research-assisted') WHERE id = ?
```

## Related Rules

- `core-prompt-construction` — Uses research findings to supplement prompt construction
- `learn-reflection` — Evaluates research-assisted sessions during reflection

---

# Learning & Reflection


# Data Model & Session Structure

Database schema overview, core data workflows, session directory conventions, and ID generation. For full schema details, see `schema.sql`.

## System Components

### Database (SQLite via MCP)

The database at `mydatabase.db` contains:

- **sessions**: Each prompt engineering session (intent, reference analysis, status, final prompt)
- **iterations**: Each attempt within a session (prompt, parameters, assessment, feedback, gap analysis)
- **patterns**: Extracted knowledge (problem/solution pairs with evidence and confidence)
- **pattern_evidence**: Links patterns to the sessions/iterations that support or contradict them
- **keyword_effectiveness**: Tracks which keywords reliably produce specific effects
- **session_patterns_applied**: Tracks which patterns were applied in each session (for validation)

### Knowledge Base (Markdown files)

Human-readable files in `knowledge/`:

- `learned-patterns.md` - All active patterns organized by category
- `keyword-effectiveness.md` - Keyword effectiveness ratings
- `failure-modes.md` - Diagnostic framework, common problems, quick fixes, and session-learned failure modes
- `v7-parameters.md` - Complete Midjourney V7 parameter reference
- `translation-tables.md` - Visual quality to prompt keyword mappings
- `prompt-templates/` - Ready-to-use prompt templates by category
- `reference-translations/` - Specific visual concept to prompt mappings from sessions

## Core Data Workflows

### Prompt Construction Queries

When constructing a prompt (see `rules/core-prompt-construction.md` for the full workflow):

1. **Query relevant patterns**:
   ```sql
   SELECT * FROM patterns WHERE is_active = 1 AND category IN (...relevant categories...) ORDER BY confidence DESC, success_rate DESC
   ```
2. **Check keyword effectiveness**:
   ```sql
   SELECT * FROM keyword_effectiveness WHERE intended_effect LIKE '%...%' ORDER BY effectiveness
   ```
3. **Check failure modes**: Read `knowledge/failure-modes.md` for known pitfalls
4. **Log which patterns were applied**:
   ```sql
   INSERT INTO session_patterns_applied (session_id, pattern_id) VALUES (...)
   ```

### Iteration Logging

After each generation attempt, log the iteration:

1. Create a session if one doesn't exist:
   ```sql
   INSERT INTO sessions (id, intent, reference_description, reference_analysis, status)
   VALUES (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(6))), ?, ?, ?, 'active')
   ```

2. Log each iteration:
   ```sql
   INSERT INTO iterations (session_id, iteration_number, prompt, parameters, mj_version, result_assessment, user_feedback, gap_analysis, success, what_worked, what_failed)
   VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
   ```

3. Update session iteration count:
   ```sql
   UPDATE sessions SET total_iterations = total_iterations + 1 WHERE id = ?
   ```

4. On success, update the session:
   ```sql
   UPDATE sessions SET status = 'success', final_successful_prompt = ? WHERE id = ?
   ```

## Session ID Generation

Generate session IDs using:
```sql
lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(6)))
```

## Session Directory Structure

All session images are stored under `sessions/` using the first 8 characters of the session UUID:

```
sessions/
  {session_id_8char}/
    reference-1.png            # First reference image
    reference-2.png            # Second reference image (if multiple)
    iter-01/
      img-1.png ... img-4.png  # Individual images from the 4-image grid
    iter-02/
      img-1.png ... img-4.png
    ...
```

### Conventions

| Item | Format | Example |
|------|--------|---------|
| Session folder | First 8 chars of UUID | `sessions/a1b2c3d4/` |
| Iteration folder | `iter-{NN}` (zero-padded, matches DB `iteration_number`) | `iter-04/` |
| Individual images | `img-{N}.png` (1-indexed) | `img-1.png` |
| Reference images | `reference-{N}.png` in session root (1-indexed) | `sessions/a1b2c3d4/reference-1.png` |

### Reference Image Persistence

The `sessions.reference_image_path` column stores reference image paths as a **JSON array**:
```json
["sessions/a1b2c3d4/reference-1.png", "sessions/a1b2c3d4/reference-2.png"]
```

**Backward compatibility:** Legacy sessions may store a bare string (e.g., `"sessions/a1b2c3d4/reference.png"`). At read time, treat a bare string as a single-element array: `["sessions/a1b2c3d4/reference.png"]`.

When scoring iterations:
- Parse `reference_image_path` as JSON array (bare string → single-element array)
- If any files exist on disk → load them all for direct visual comparison (preferred)
- If none available → fall back to text-based `reference_analysis` JSON
- For multiple references, the `reference_analysis` contains a composite analysis (see `rules/core-reference-analysis.md`)
- Flag which method was used in every assessment

## Related Rules

- `core-prompt-construction` — Uses queries from this rule to apply knowledge
- `core-assessment-scoring` — Stores scores in the iterations table
- `learn-reflection` — Reads iteration data for pattern extraction

---

# Pattern Lifecycle & Knowledge Generation

How patterns are created, how confidence graduates with evidence, how decay works, scope rules, and how the knowledge base markdown files are regenerated.

## Pattern Lifecycle

```
Observed in 1 session → logged as pattern (confidence: low)
                              ↓
Confirmed in 2-3 more sessions → confidence: medium
                              ↓
Confirmed in 5+ sessions with >80% success → confidence: high
                              ↓
Contradicted by new evidence → flagged for review
                              ↓
Not validated in 60+ days → confidence decays one level
                              ↓
Explicitly invalidated → is_active = 0
```

## Confidence Thresholds

| Level | Criteria |
|-------|----------|
| low | 0-2 tests |
| medium | 3-5 tests with >70% success |
| high | 6+ tests with >80% success |
| decay | Not validated in 60+ days → drop one level |

## Auto-Graduation Queries

After inserting new patterns and updating evidence, run confidence graduation on ALL active patterns:

```sql
-- Graduate to medium: 3+ tests with >70% success
UPDATE patterns SET confidence = 'medium'
WHERE is_active = 1 AND confidence = 'low'
  AND times_tested >= 3 AND success_rate > 0.7;

-- Graduate to high: 6+ tests with >80% success
UPDATE patterns SET confidence = 'high'
WHERE is_active = 1 AND confidence = 'medium'
  AND times_tested >= 6 AND success_rate > 0.8;

-- Decay: not validated in 60+ days
UPDATE patterns SET confidence = 'medium'
WHERE is_active = 1 AND confidence = 'high'
  AND last_validated < datetime('now', '-60 days');
UPDATE patterns SET confidence = 'low'
WHERE is_active = 1 AND confidence = 'medium'
  AND last_validated < datetime('now', '-60 days');
```

## Knowledge Scope

All patterns are Midjourney V7-specific. The `specificity` field uses these values:

- `universal` — Applies across all MJ V7 prompts (e.g., prompt structure rules, parameter defaults)
- `general` — Applies when the category matches (e.g., lighting techniques for any lit scene)
- `specific` — Only applies in exact context (e.g., "subsurface scattering for organic translucent subjects")
- `user-preference` — Personal style preferences, not transferable

"This feels universal" is a hypothesis until tested across diverse sessions. Store patterns with evidence, not assumptions.

If other tools are added later, they get separate knowledge bases starting from zero. Cross-tool patterns require independent evidence from each tool before any shared knowledge base is created.

## Knowledge Base Generation

After every reflection (automatic or manual), regenerate all three files from current DB state:

a. **`knowledge/learned-patterns.md`** — Query all active patterns, group by category, sort by confidence:
   ```sql
   SELECT * FROM patterns WHERE is_active = 1 ORDER BY category, confidence DESC, success_rate DESC
   ```

b. **`knowledge/keyword-effectiveness.md`** — Query all keyword data:
   ```sql
   SELECT * FROM keyword_effectiveness ORDER BY intended_effect, effectiveness DESC
   ```

c. **`knowledge/failure-modes.md`** — Preserve the static diagnostic sections at the top of the file, then replace the "Session-Learned Failure Modes" section with current DB data:
   ```sql
   SELECT id, problem, solution, example_bad, example_good, confidence, success_rate, times_tested
   FROM patterns WHERE is_active = 1 AND category = 'failure-mode'
   ORDER BY confidence DESC, times_tested DESC
   ```
   Write each pattern under the `## Session-Learned Failure Modes` heading using this format:
   ```
   ### {problem} ({id})
   **Fix:** {solution}
   **Bad:** `{example_bad}` → **Good:** `{example_good}`
   **Confidence:** {confidence} ({times_tested} tests, {success_rate}% success)
   ```

Write each file with current timestamp. This ensures the human-readable knowledge layer always matches the database.

## Related Rules

- `learn-data-model` — Defines the database tables patterns are stored in
- `learn-reflection` — The process that creates and updates patterns

---

# Reflection & Session Lifecycle

How sessions are closed, how automatic reflection extracts patterns, the reflection subagent, and the role of the `/reflect` command for deeper cross-session analysis.

## Session Lifecycle & Automatic Reflection

### Session Close Detection

When the user signals session completion, the agent should:
1. Update the session status
2. Trigger automatic reflection (inline or via subagent)
3. Confirm to the user that patterns were captured

**Recognition signals — the agent should detect these naturally:**

| User Signal | Session Status | Action |
|-------------|---------------|--------|
| "Perfect", "That works", "I'm happy with this" | `success` | Mark success + trigger reflection |
| "Good enough", "Let's move on" | `success` | Mark success + trigger reflection |
| "This isn't working", "Let's try something else" | `abandoned` | Mark abandoned + trigger reflection |
| "Start fresh", "New session" | Close current as `abandoned` | Trigger reflection + start new |
| Starting `/new-session` with active session | Depends on user response | Ask, then trigger reflection |

### Automatic Reflection Flow

When a session is closed (success or abandoned), run this extraction:

1. **Query all iterations for the session:**
   ```sql
   SELECT * FROM iterations WHERE session_id = ? ORDER BY iteration_number
   ```

2. **Identify successes and failures:**
   - Successes: iterations where `success = 1` OR `result_assessment` average > 0.75
   - Failures: iterations where `success = 0` AND average < 0.65

3. **Extract keyword patterns:**
   - Parse prompts from all iterations
   - For each keyword, record: context, success/failure, score
   - Upsert into `keyword_effectiveness` (increment `times_used`, `times_effective`)

4. **Extract technique patterns:**
   - Parse `what_worked` and `what_failed` JSON arrays from all iterations
   - Count frequency of each technique
   - If a technique appears 2+ times in `what_worked`: create candidate pattern (use category matching the technique type: `keyword`, `technique`, `parameters`, etc.)
   - If a technique appears 2+ times in `what_failed`: create candidate pattern with `category = 'failure-mode'`. This exact category value is required for failure-modes.md generation.

4.5. **Extract action decision patterns:**
   - For each iteration with `action_type` set, compare its scores to the previous iteration
   - Record whether the action improved, maintained, or degraded the result
   - If a pattern emerges (e.g., "vary_strong improved scores when batch_avg > 0.8"), create a `workflow` category candidate pattern

5. **Write patterns with low confidence, auto-extracted:**
   ```sql
   INSERT INTO patterns (id, category, problem, solution, confidence, auto_extracted, is_reviewed, is_active, discovered_at)
   VALUES (?, ?, ?, ?, 'low', 1, 1, 1, datetime('now'))
   ```
   No manual review gate — patterns are active and reviewed on insertion. Confidence graduates automatically based on `times_tested` and `success_rate`.

6. **Check for duplicates** against existing active patterns before inserting. Skip if the same problem/solution already exists.

7. **Auto-graduate pattern confidence.** After inserting new patterns and updating evidence, run confidence graduation on ALL active patterns (see `rules/learn-pattern-lifecycle.md`).

8. **Mark session as reflected:**
   ```sql
   UPDATE sessions SET reflected = 1 WHERE id = ?
   ```

9. **Regenerate knowledge base markdown files** (see `rules/learn-pattern-lifecycle.md`).

## Reflection Subagent

For background processing, spawn a general-purpose subagent:

```
Task(
  subagent_type="general-purpose",
  run_in_background=true,
  prompt="You are the reflection subagent for the Midjourney learning system.
    Database: mydatabase.db (via sqlite-simple MCP)
    Session ID: {session_id}

    1. Query all iterations for this session
    2. Extract patterns from what_worked/what_failed
    3. Insert new patterns with confidence='low', auto_extracted=1, is_reviewed=1
    4. Update keyword_effectiveness for keywords used
    5. Auto-graduate pattern confidence (see thresholds in rules/learn-pattern-lifecycle.md)
    6. Mark session reflected=1
    7. Regenerate knowledge base markdown files (learned-patterns.md, keyword-effectiveness.md, failure-modes.md)

    No manual review needed. Extract, write, regenerate."
)
```

**Important:** If MCP tools aren't available to subagents, fall back to inline reflection (the main agent runs steps 1-9 directly). Test MCP access first.

## Reflection Techniques

The reflection process incorporates three research-informed techniques:

- **Contrastive refinement** (from MACLA): Compare successes against failures to produce conditional patterns ("works when X, fails when Y") instead of unconditional rules.
- **Integration pass** (from BREW): Deduplicate, merge, and resolve contradictions before adding new patterns. Prevents knowledge base bloat and conflicting advice.
- **Relevance context** (from BREW/MACLA): Patterns should carry enough context to determine when they apply, not just what they recommend.

## `/reflect` Command (Updated Role)

`/reflect` is no longer the primary pattern extraction mechanism. Its new role:
- **Run contrastive analysis:** The deeper analysis (success vs failure comparison) that auto-extraction skips
- **Handle cross-session patterns:** Compare patterns across multiple sessions
- **Resolve contradictions:** When patterns conflict, do contrastive refinement to produce conditional rules
- **Force full regeneration:** Re-run markdown generation if needed

## Related Rules

- `learn-data-model` — Database schema and query patterns
- `learn-pattern-lifecycle` — Confidence graduation and knowledge generation
- `core-assessment-scoring` — Produces the scores reflection analyzes

---

# Browser Automation


# Browser Automation Workflows

Playwright-based browser control for midjourney.com. This closes the loop: construct prompt → submit via browser → wait for generation → capture result screenshot → analyze → refine → repeat.

## Authentication

Midjourney requires login. On first use:
1. Navigate to `https://www.midjourney.com/imagine`
2. The user logs in manually (Google/Discord OAuth)
3. Cookies persist for subsequent sessions
4. If session expires, prompt the user to re-authenticate

## Core Automation Sequences

**1. Navigate to Midjourney**
```
browser_navigate({ url: "https://www.midjourney.com/imagine" })
browser_snapshot()  -- verify we're on the imagine page
```

**1.5. Disable Personalization**

V7 has personalization ON by default, which silently biases all generations toward the user's aesthetic profile. For reproducible prompt engineering, disable it before submitting prompts.

```
-- After navigating to the imagine page, take a snapshot
browser_snapshot()
-- Look for the personalization toggle near the Imagine bar
-- It may appear as a toggle button, a "--p" indicator, or a profile icon
-- If personalization is active/enabled, click to toggle it OFF
browser_click({ ref: [personalization_toggle_ref], element: "Personalization toggle" })
-- Verify it's now off
browser_snapshot()
```

**Why this matters:** Patterns extracted with personalization on reflect a blend of prompt + user aesthetic. Disabling it isolates prompt effects, making patterns more universal and reproducible. The toggle persists across the session, so this only needs to be done once per browser session.

**Exception:** If the user explicitly wants personalization on (e.g., testing their profile's effect), skip this step and log `personalization=on` in the session's `approach_rationale`.

**2. Submit a Prompt**
```
-- Take snapshot to find the prompt input
browser_snapshot()
-- Type the prompt into the input field
browser_type({ ref: [prompt_input_ref], text: "[full prompt with parameters]" })
-- Submit
browser_press_key({ key: "Enter" })
```

**3. Wait for Generation (Multi-Signal Adaptive Polling)**

Use `browser_run_code` for efficient polling instead of manual wait/snapshot cycles.
This avoids consuming context with repeated DOM snapshots during the wait.

The polling uses multiple independent signals to detect completion, making it resilient to UI changes:
- **Action buttons** (Vary, Upscale, Rerun, Strong, Subtle) — most reliable positive signal
- **CDN images** — 4+ loaded `cdn.midjourney.com` images indicate a finished grid
- **Progress indicators** — percentage text or "Running"/"Queued" status means still generating
- **Diagnostic dump on timeout** — captures visible buttons and image count so you can debug selector drift

```javascript
browser_run_code({
  code: `async (page) => {
    // Skip first 15s — no generation finishes faster
    await page.waitForTimeout(15000);

    // Poll every 5s for up to 3 minutes total
    for (let i = 0; i < 33; i++) {
      await page.waitForTimeout(5000);
      const elapsed = 15 + ((i + 1) * 5);

      // --- Positive signals (any = done) ---
      // Check for action buttons (Vary, Upscale, Rerun, etc.)
      const actionBtns = await page.$$([
        'button:has-text("Vary")',
        'button:has-text("Upscale")',
        'button:has-text("Rerun")',
        'button:has-text("Strong")',
        'button:has-text("Subtle")',
        'button:has-text("Creative Upscale")',
        'button[aria-label*="Vary"]',
        'button[aria-label*="Upscale"]'
      ].join(', '));

      if (actionBtns.length >= 2) {
        return 'DONE: ' + actionBtns.length + ' action buttons found (' + elapsed + 's)';
      }

      // --- Negative signals (presence = still generating) ---
      const progressText = await page.evaluate(() => {
        const body = document.body.innerText;
        const pctMatch = body.match(/(\\d{1,3})%/);
        const running = body.includes('Running') || body.includes('Queued');
        return { pct: pctMatch ? pctMatch[1] : null, running };
      });

      // If we see progress, we know it's actively generating — keep waiting
      if (progressText.pct || progressText.running) continue;

      // No progress AND no action buttons — might be in a transition state
      // Check for loaded images as secondary signal
      const images = await page.$$('img[src*="cdn.midjourney.com"]');
      if (images.length >= 4) {
        return 'DONE: ' + images.length + ' CDN images loaded (' + elapsed + 's)';
      }
    }

    // Timeout — collect diagnostic info
    const diag = await page.evaluate(() => {
      const buttons = [...document.querySelectorAll('button')].map(b => b.textContent.trim()).filter(t => t.length > 0 && t.length < 30);
      const hasProgress = document.body.innerText.match(/(\\d{1,3})%/);
      const imgCount = document.querySelectorAll('img').length;
      return { buttons: buttons.slice(0, 15), progress: hasProgress ? hasProgress[1] + '%' : 'none', imgCount };
    });
    return 'TIMEOUT 180s. Diag: ' + JSON.stringify(diag);
  }`
})
```

**Interpreting results:**
- `DONE: N action buttons found (Xs)` — normal completion, proceed to snapshot
- `DONE: N CDN images loaded (Xs)` — completed but action buttons may have different selectors; proceed but note this for future selector updates
- `TIMEOUT 180s. Diag: {...}` — check the diagnostic JSON: `buttons` shows what's actually in the DOM (use these labels to update selectors), `progress` indicates if generation is still running, `imgCount` shows total images on page

After completion, take a snapshot to identify the job URL and action buttons:
```
browser_snapshot()
```

**4. Capture Results (Batch Image Capture)**

Use `browser_run_code` to capture all 4 images in a single tool call.
This replaces 12+ individual navigate/wait/screenshot calls with one script,
reducing context usage by ~40-50% per iteration.

```javascript
browser_run_code({
  code: `async (page) => {
    const jobId = '[JOB_ID from URL]';
    const dir = 'sessions/[SESSION_ID_8]/iter-[NN]';

    for (let i = 0; i < 4; i++) {
      await page.goto('https://www.midjourney.com/jobs/' + jobId + '?index=' + i);
      // Wait for lightbox to load
      await page.waitForTimeout(3000);
      await page.screenshot({ path: dir + '/img-' + (i + 1) + '.png' });
    }
    return 'All 4 images captured to ' + dir;
  }`
})
```

Then load all 4 images for analysis:
```
Read({ file_path: "sessions/[ID]/iter-[NN]/img-1.png" })
Read({ file_path: "sessions/[ID]/iter-[NN]/img-2.png" })
Read({ file_path: "sessions/[ID]/iter-[NN]/img-3.png" })
Read({ file_path: "sessions/[ID]/iter-[NN]/img-4.png" })
```

**Why `browser_run_code` over individual calls:** Each `browser_navigate` or
`browser_snapshot` call returns the full page DOM as YAML (~200-500 lines),
most of which is irrelevant sidebar/navigation content. A single `browser_run_code`
call executes all steps server-side and returns only the result string. For a
4-image capture, this saves ~2000+ lines of context per iteration.

**5. Perform Actions (Upscale/Variation)**
```
-- From the snapshot, identify U1-U4 (upscale) or V1-V4 (variation) buttons
browser_click({ ref: [button_ref], element: "U1 upscale button" })
-- Wait for upscale/variation to complete
browser_wait_for({ time: 15 })
browser_take_screenshot({ type: "png", filename: "midjourney_upscale_[timestamp].png" })
```

**6. Editor Edit (Selective Inpainting)**

Use MJ's built-in editor to mask specific areas for regeneration while preserving the rest. This is the automation path for `action_type: editor_edit` in the iteration framework.

```
-- Navigate to the image detail page
browser_navigate({ url: "https://www.midjourney.com/jobs/[JOB_ID]?index=[IMAGE_INDEX]" })
browser_snapshot()
-- Click the Edit button
browser_click({ ref: [edit_button_ref], element: "Edit button" })
browser_snapshot()  -- verify editor opened
```

**Masking with Smart Select (preferred):**
```
-- Click Smart Select tool
browser_click({ ref: [smart_select_ref], element: "Smart Select tool" })
-- Click on the region to segment (e.g., background area)
browser_click({ ref: [canvas_ref], element: "Canvas - select background region" })
-- Wait for segmentation API response
browser_wait_for({ time: 3 })
browser_take_screenshot()  -- verify green selection mask
-- Convert selection to erase mask
browser_click({ ref: [erase_selection_ref], element: "Erase Selection button" })
-- Verify: erased area shows checkerboard transparency pattern
browser_take_screenshot()
```

**Fallback: Manual Erase tool painting:**
If Smart Select fails (segmentation API error), use the manual Erase tool:
```
-- Click Erase tool (use exact ref, not name — "Erase" matches multiple buttons)
browser_click({ ref: [erase_tool_ref], element: "Erase tool button" })
-- Paint mask strokes on the canvas using browser_run_code for coordinate control
browser_run_code({
  code: `async (page) => {
    const canvas = page.locator('canvas').first();
    const box = await canvas.boundingBox();
    // Paint horizontal strokes across the target area
    for (let y = box.y + 20; y < box.y + box.height - 20; y += 15) {
      await page.mouse.move(box.x + 20, y);
      await page.mouse.down();
      await page.mouse.move(box.x + box.width - 20, y, { steps: 10 });
      await page.mouse.up();
      await page.waitForTimeout(50);
    }
    return 'Erase mask painted';
  }`
})
```

**Update prompt and submit:**
```
-- Clear and update the prompt text
browser_run_code({
  code: `async (page) => {
    const textbox = page.getByRole('textbox', { name: 'What will you imagine?' });
    await textbox.press('ControlOrMeta+a');
    await textbox.fill('[new prompt emphasizing desired qualities for regenerated area]');
    return 'Prompt updated';
  }`
})
-- Submit the edit
browser_click({ ref: [submit_edit_ref], element: "Submit Edit button" })
```

Then use the standard polling (step 3) and capture (step 4) sequences. The new job URL will appear in the page snapshot after submission.

**Key notes:**
- The Erase tool button has strict mode issues — `getByRole('button', { name: 'Erase' })` matches "Erase", "Erase Selection", and "Erase Background". Always use the exact element `ref` from the snapshot.
- Smart Select may need multiple clicks on different parts of the region to build a complete mask.
- Consider removing `--sref` or `--raw` from the edit prompt if those parameters caused the regional issue being fixed.
- Editor edits produce 4-image batches like normal generations — capture and score all 4.

## Related Rules

- `auto-reference-patterns` — Selector strategy and error handling for these workflows
- `core-iteration-framework` — Decides which actions (upscale/vary) to perform, including editor_edit
- `learn-data-model` — Session directory structure for image storage

---

# Selector Strategy & Reference Patterns

How to find UI elements reliably, handle errors, manage timing, analyze 4-image grids, and evaluate reference image usage approaches.

## Selector Strategy

Midjourney's UI may change. Use this priority order for finding elements:
1. **data-testid attributes** (most stable)
2. **ARIA labels** (accessibility attributes)
3. **Text content** (button labels, placeholders)
4. **Semantic HTML elements** (input, button, textarea)
5. **CSS classes** (least stable, last resort)

Always use `browser_snapshot()` to get the current page state before interacting. The snapshot returns accessible element references you can use with `browser_click()`, `browser_type()`, etc.

## Error Handling

| Error | Recovery |
|-------|----------|
| Element not found | Take fresh snapshot, re-identify elements |
| Page not loading | Wait and retry, check network |
| Generation timeout (>120s) | Take screenshot of current state, report to user |
| Session expired | Prompt user to log in again |
| Rate limited | Wait the indicated time, then retry |

## 4-Image Grid Analysis

Midjourney generates a 2x2 grid of 4 images. When analyzing results:

1. **Take a screenshot** of the full grid
2. **Analyze all 4 images** — they represent different interpretations of the same prompt
3. **Identify the best candidate** based on the session intent
4. **Note differences between the 4** — these reveal which prompt elements MJ interprets consistently vs. variably
5. **Recommend action**: Upscale (U1-U4) the best one, or use Variation (V1-V4) for more options from a promising direction

## Timing Guidelines

| Action | Expected Time |
|--------|---------------|
| Image generation | 30-90 seconds |
| Upscale | 15-30 seconds |
| Variation | 30-60 seconds |
| Page navigation | 3-5 seconds |
| Batch 4-image capture | 12-15 seconds (single `browser_run_code` call) |
| Smart generation poll | Auto-detects completion, polls every 5s |

## Image Analysis Workflow

When a user shares an image (reference or MJ output), analyze it directly:

1. **Look at the image.** Extract the same dimensions you'd log in a reference analysis or result assessment.
2. **For reference images:** Produce the full reference analysis (subject, lighting, colors, material, composition, mood, style, render quality) from what you see. Present your analysis and let the user correct or confirm. The user may also provide a text description alongside the image or instead of it — both paths are valid, and combining them produces the richest analysis.
3. **For MJ output images:** Score each assessment dimension by comparing what you see against the session intent. Identify specific gaps — not vague impressions but concrete observations ("the rim light is missing on the right side", "the form is angular where organic was intended").
4. **For side-by-side comparison (reference + output):** Produce a structured diff. What matches? What's off? What's missing entirely? This is the richest source of gap analysis data.

Always present your visual analysis to the user for confirmation before logging it. You may see things differently than they do, and their intent is what matters. But your analysis gives them something concrete to react to rather than starting from a blank "how did it look?"

## Reference Image as MJ Input

When a user provides a reference image, there's a separate question beyond analysis: **should this image be fed directly to Midjourney as a reference parameter?**

Evaluate and recommend one of these approaches:

1. **Use as `--sref` (style reference):** When the user wants to match the overall aesthetic, color palette, mood, or rendering style of the reference — but not the specific subject or composition. Good for: "I want this vibe/look applied to a different subject."
2. **Use as `--iref` (image reference):** When the user wants MJ to use the image as compositional or structural inspiration. Good for: "I want something that looks like this."
3. **Use as `--cref` / `--oref` (character/object reference):** When the user wants to maintain a consistent character or object across generations. Note: `--cref` was replaced by `--oref` in V7.
4. **Don't use as reference — prompt-only recreation:** When the user wants to reverse-engineer the look through prompt language alone. This is harder but produces more transferable knowledge — the prompt works without the reference image. Good for: building reusable prompt patterns, learning what keywords produce specific effects, cases where the reference captures a quality the user wants to understand and replicate.
5. **Hybrid approach:** Use an image reference parameter for the hardest-to-describe qualities (specific texture, exact color grade) while prompting explicitly for the elements that can be captured in language. Log which aspects came from the reference param vs. the prompt — this distinction matters for pattern extraction.

Always ask the user which approach they prefer if it's not obvious from context. Explain the tradeoffs. Log the choice in the session data so reflection can analyze which approach works better for different types of images.

## Related Rules

- `auto-core-workflows` — The automation sequences these patterns support
- `core-reference-analysis` — How to analyze the reference itself
- `core-assessment-scoring` — How to score the output images

---
