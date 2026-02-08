---
title: "Assessment Scoring Guide"
impact: "critical"
tags: ["scoring", "7-dimensions", "confidence", "spatial"]
---

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
