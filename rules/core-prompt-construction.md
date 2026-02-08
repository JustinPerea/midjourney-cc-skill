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

## Related Rules

- `core-reference-analysis` — Produces the analysis that feeds prompt construction
- `core-research-phase` — Fills knowledge gaps before constructing the prompt
- `learn-data-model` — Contains the SQL queries for pattern and keyword lookups
