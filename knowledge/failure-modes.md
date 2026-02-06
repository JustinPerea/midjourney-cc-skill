# Failure Modes & Refinement Strategies

> Common problems encountered in Midjourney generation and their fixes.
> Auto-generated from iteration logs and patterns database during reflection.
> Last updated: 2026-02-06

## How to Use This File

When a generation fails or doesn't match intent, check this file for known failure modes
that match the symptoms. Each entry includes:
- **Symptom**: What you see in the output
- **Cause**: Why it happens
- **Fix**: What to change in the prompt/parameters
- **Evidence**: Which sessions demonstrated this

---

## Diagnostic Framework

When results don't match expectations, work through these decision trees by dimension.

### Subject Accuracy

| Issue | Likely Cause | Fix |
|-------|--------------|-----|
| Wrong subject entirely | Ambiguous prompt, subject buried in middle | Front-load subject, be more specific |
| Missing key elements | Too many concepts competing | Simplify, focus on essentials |
| Extra unwanted elements | MJ interpretation, no exclusions | Add `--no [unwanted elements]` |
| Wrong style of subject | Style bleeding into subject | Use `--style raw`, separate style from subject |

### Composition

| Issue | Likely Cause | Fix |
|-------|--------------|-----|
| Subject in wrong position | No position instructions | Add explicit: "subject at far right" |
| No text space | "Negative space" misinterpreted | Describe empty areas physically |
| Too zoomed in | No composition guidance | Add "wide shot", "extreme wide angle" |
| Too zoomed out | Subject description too brief | Add details that demand closer framing |
| Collaged/arranged layout instead of isolated elements | Aesthetic/movement keyword triggering layout | Remove "punk zine aesthetic" etc., use material keywords instead |
| 3/4 angle when frontal wanted | MJ default perspective bias | Add "flat frontal view" + "orthographic perspective" |
| Element position wrong on object face | Sub-object positioning unreliable in V7 | Generate batches and select, don't iterate on position wording |
| Continuous pattern instead of isolated forms | Pattern/swirl keywords fill the frame | Remove "all-over pattern", describe "scattered discrete shapes floating in dark void" |
| Gradient direction wrong (horizontal instead of vertical) | No directional language in prompt | Use "from [color] at top to [color] at bottom". Avoid standalone "vertical" (triggers stripe patterns). |

### Mood/Atmosphere

| Issue | Likely Cause | Fix |
|-------|--------------|-----|
| Too cheerful/bright | Lighting keywords wrong | Add "moody", "dramatic", specific lighting |
| Too dark/ominous | Missing warmth keywords | Add "warm", "inviting", adjust lighting |
| Generic/flat feeling | Low stylize, no atmosphere | Increase `--s`, add atmosphere terms |

### Color

| Issue | Likely Cause | Fix |
|-------|--------------|-----|
| Wrong color palette | Not specified | Explicitly state colors in prompt |
| Too saturated | MJ default beautification | Use `--style raw`, add "muted" |
| Clashing colors | Too many color mentions | Limit to 2-3 key colors |
| Color drifting (blue->teal, warm->yellow) | Generic color names | Use specific pigment names: "cobalt blue", "burnt sienna", "warm ochre" |
| Low contrast, lines blend into gradient | No explicit ground specified | Add "pure black canvas", "against dark void", "high contrast linework" |
| Warm color contamination (sunset orange/pink at bottom) | Sky/atmospheric metaphors or MJ default | Add `--no warm, orange, yellow, pink, sunset` |

### Quality/Realism

| Issue | Likely Cause | Fix |
|-------|--------------|-----|
| Too artificial/AI-looking | High stylize | Lower `--s`, add `--style raw`, add "photorealistic" |
| Too realistic when artistic wanted | Low stylize, raw mode | Increase `--s`, remove `--style raw` |
| Blurry/soft | Quality parameter | Ensure `--q 1`, add "sharp", "detailed" |
| Photorealistic when flat/graphic wanted | Physics keywords in prompt | Remove "subsurface scattering", "polished smooth surface"; use "fine art print" |
| 3D fluid ribbons instead of fine linework | Water/fluid simulation keywords | Remove "swirling water vortex"; use "fine flowing lines", "thin ink lines" |
| Thick painterly marks instead of fine lines | "Brushstrokes" keyword | Use "thin ink lines", "hair-thin strokes" instead of "fine delicate brushstrokes" |

### Gradients/Abstract

| Issue | Likely Cause | Fix |
|-------|--------------|-----|
| Painted swatches instead of digital gradient | "Color swatch", "wash", "matte finish" keywords | Remove paint-related vocabulary; use "smooth color transition", "abstract minimalist background" |
| Lens glow/aurora instead of smooth gradient | "Defocused" keyword | Use "smooth", "seamless", "soft blend" instead |
| Gradient banding/harsh transitions | --s value too low | Increase to --s 75-100 for smoother blending |
| Unwanted subjects in abstract output | Weak negative prompt | Use comprehensive --no list (15+ items) AND "no subject" in prompt text |
| Gradient runs wrong direction | No directional language or standalone "vertical" | Use "from [color] at top to [color] at bottom" phrasing |
| Fabric/silk instead of gradient | Warm fabric-associated color names (peach, coral, champagne, blush, soft gold) | Use cool colors, or add `--no silk, satin, fabric, folds, textile` |

### Surrealism in Photorealistic Scenes

| Issue | Likely Cause | Fix |
|-------|--------------|-----|
| Surreal modifier treated as mood, no visual change | Abstract surreal words ("impossible reflections", "melting buildings") ignored by --style raw | Describe a concrete impossible OBJECT (whale, paper cranes, koi fish) instead of an impossible EFFECT |
| Photorealistic base degraded by surreal technique | "Double exposure" conflicts with --style raw anchor | Remove technique keywords; use concrete impossible objects placed in the scene |
| Surreal element too subtle / absorbed into atmosphere | Element too small (human-scale) or color-mismatched with scene | Use massive scale or multiples (flock/school). Match element color to scene palette. |
| Surreal element visible but lacks impact | Single object at human scale | Use dense multiples (hundreds of koi, flock of cranes) or massive scale (whale above rooftops) |
| Surreal element clashes with color palette | Cool bioluminescent element in warm scene, or vice versa | Choose elements whose natural colors complement the scene palette (golden koi in warm neon scene) |

---

## Quick Fixes Reference Card

| Symptom | Quick Fix |
|---------|-----------|
| Too busy | `--style raw --s 150 --no clutter` |
| Not following prompt | Front-load subject, lower `--s` |
| Wrong position | "subject at far [direction]" |
| Unwanted text | `--no text, letters, words, writing` |
| Too generic | `--weird 100`, add specific details |
| Wrong colors | Specific pigment names (`cobalt blue`, `burnt sienna`), `--no [wrong color]` |
| Color drifting | Use specific color anchors, not generic names |
| Warm color contamination | `--no warm, orange, yellow, pink, sunset` |
| Low contrast on dark ground | Add `pure black canvas`, `high contrast linework` |
| Too dark | "bright", "well-lit", remove moody terms |
| Too bright | "moody", "dramatic shadows", "dark" |
| AI-looking | `--style raw`, "photorealistic", lower `--s` |
| Not artistic enough | Higher `--s 300+`, remove `--style raw` |
| Photorealistic when graphic wanted | Remove physics keywords, add "fine art print", "graphic quality" |
| Collaged layout | Remove aesthetic/movement keywords, use material keywords |
| Sharp when blur wanted | Remove ALL subject keywords, use "out of focus photography" |
| 3D fluid instead of linework | Remove water/vortex keywords, describe mark-making: "thin ink lines" |
| Thick marks instead of fine lines | Replace "brushstrokes" with "thin ink lines", "hair-thin strokes" |
| Continuous pattern, no breathing room | Remove "all-over pattern", add "scattered discrete shapes", "empty space between" |
| Photorealistic when no medium specified | Add explicit medium: "spray paint airbrush illustration", "oil painting", etc. |
| Standard 2 eyes when multi-eye wanted | Use "almond eyes stacked vertically" + `--sref` + `--sw 200`. Never use "slits". |
| Sref not transferring structure | Increase `--sw 200+`. Default 100 is style-only. |
| Painted swatches instead of gradient | Remove "color swatch", "wash", "matte finish"; use "smooth color transition" |
| Lens glow instead of smooth gradient | Remove "defocused"; use "smooth", "seamless soft blend" |
| Gradient harsh/banding | Increase `--s` to 75-100. `--s 0` produces harsh transitions. |
| Wrong gradient direction | Use "from [color] at top to [color] at bottom". Avoid standalone "vertical". |
| Fabric/silk instead of gradient | Use cool color names. Avoid peach, coral, champagne, blush, soft gold. Add `--no silk, satin, fabric, folds, textile`. |
| Surreal words ignored in photo scene | Replace abstract surreal effects with concrete impossible objects |
| Double exposure kills photo look | Remove "double exposure"; use concrete surreal objects with --style raw |
| Surreal element invisible/absorbed | Increase scale (massive) or quantity (hundreds). Match colors to scene palette. |

---

## When to Pivot

Signs the current prompt direction isn't working:
- 3+ generations all miss the mark
- Key element consistently ignored
- Results getting worse with refinements
- Fighting against MJ's "instincts"

Better to:
1. Step back and re-read original intent
2. Try completely different vocabulary
3. Use a reference image (`--sref`)
4. Break complex scene into simpler elements

---

## Session-Learned Failure Modes

<!-- This section is populated automatically as you use the system.
     Failure modes are extracted from iteration data during reflection.
     Each entry documents a specific way MJ misinterprets prompt language.

     Example entry format:

     ### Failure Mode Name (Session XXXXXXXX)

     **Symptom:** What you see in the output that doesn't match intent
     **Cause:** Why MJ produces this — which keywords or combinations trigger it
     **Fix:** What to change in the prompt/parameters to avoid this
     **Evidence:** Which sessions and iterations demonstrated this, with score data
-->
