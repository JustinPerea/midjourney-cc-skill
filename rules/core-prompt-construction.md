---
title: "Prompt Construction Best Practices"
impact: "critical"
tags: ["prompt", "v7", "keywords", "knowledge-check"]
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
