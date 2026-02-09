# Failure Modes & Refinement Strategies

> Common problems encountered in Midjourney generation and their fixes.
> Auto-generated from iteration logs and patterns database during reflection.
> Last updated: 2026-02-09

## How to Use This File

When a generation fails or doesn't match intent, check this file for known failure modes
that match the symptoms. Each entry includes:
- **Symptom**: What you see in the output
- **Cause**: Why it happens
- **Fix**: What to change in the prompt/parameters
- **Evidence**: Which sessions demonstrated this
- **Confidence**: How well-tested the pattern is

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

Failure modes are organized by confidence level: **Medium** (tested 2+ times with logged evidence) down to **Low** (single observation, needs validation).

### MEDIUM CONFIDENCE (Well-Tested Patterns)

#### Subject Keywords Override Abstract/Blur Effects
**Pattern ID:** `auto-icm-subject-keyword-dominance`
**Confidence:** Medium (0% success, 3 tests)

**Symptom:** Any concrete subject keyword — even softened with "hint of", "faint", "dissolving" — produces sharp rendering instead of blur/abstract/defocus effects.

**Cause:** V7 prompt hierarchy: subject/material > style/abstract > perceptual quality. Subject nouns re-anchor output in conventional sharp rendering, overriding blur keywords.

**Fix:**
- Do NOT attempt to soften subject keywords with qualifiers
- Complete subject removal is the only reliable approach
- Even "hint of dissolving botanical silhouettes" produced identifiable sharp stems and leaves (iter 7: blur scores dropped from 0.90-0.95 to 0.45-0.55)
- If organic forms needed, achieve them through Vary Strong on an abstract parent, not prompt keywords

**Evidence:** Strong failure mode from ICM session 365b2d9b. Iter 5: "dissolving flower petals" → 3/4 sharp (0.73 avg, blur 0.45-0.80). Iter 7: "hint of dissolving botanical silhouettes" → all 4 sharp (0.74 avg, blur 0.45-0.55). Iter 1: "motion-blurred flowers" → 0/4 blurred (0.64 avg). Cross-session confirmed in 6 sessions (365b2d9b, 39ce7668, 5ebbd0ef, 799400c2, 822750f3, bf0036e5).

---

#### Warm Fabric-Associated Color Names → Silk/Satin Rendering
**Pattern ID:** `auto-warm-color-triggers-fabric`
**Confidence:** Medium (50% success, 4 tests)

**Symptom:** Warm color names like peach, coral, champagne, blush pink, dusty rose, soft gold, or warm ivory produce silk/satin fabric rendering instead of smooth abstract gradients.

**Cause:** These colors are strongly associated with silk/satin textile training data in MJ V7. The model interprets them as material descriptors rather than pure color specifications.

**Fix:**
- Avoid warm fabric-associated color names in gradient prompts
- Use cool or cool-dominant palettes for reliable gradients
- If warm gradient needed, try less fabric-associated names like "warm amber" or "terracotta"
- Add explicit anti-fabric keywords: `--no silk, satin, fabric, folds, textile`
- A single warm color (e.g., dusty pink) can work when surrounded by dominant cool colors

**Evidence:** Session d48e5b3c. Tested 4 times: 2 warm palettes both triggered fabric (iters 2, 4), 2 cool palettes succeeded (iters 1, 3), 1 mixed-cool palette with dusty pink succeeded (iter 5). The cool-to-warm ratio appears to matter.

---

#### Gallery Framing Trap (Art Movement + Gallery Context)
**Pattern ID:** `pat-gallery-framing-trap`
**Confidence:** Medium (0% success, 2 tests)

**Symptom:** MJ renders a photo of artwork on a gallery wall rather than generating the artwork itself.

**Cause:** Combining art movement names (color field painting) with gallery/exhibition context (gallery artwork) triggers meta-rendering.

**Fix:**
- Use artist inspiration (e.g., "James Turrell inspired") without gallery context words
- OR use mood/quality words (contemplative, hypnotic luminosity) instead of art movement labels

**Evidence:** Discovered in iteration 3B. "Gallery artwork" triggered meta-rendering of painting in exhibition space.

---

### LOW CONFIDENCE (Single/Limited Tests, Needs Validation)

#### "Color Swatch" / "Wash" / "Matte Finish" → Painted Swatches
**Pattern ID:** `auto-color-swatch-triggers-paint`
**Confidence:** Low (0% success, 1 test)

**Symptom:** Painted swatches on paper with visible brush edges instead of clean digital gradients.

**Cause:** These keywords activate physical medium rendering in MJ V7.

**Fix:**
- Avoid paint-related vocabulary when seeking clean digital gradients or color fields
- Use atmospheric/environmental language instead
- Describe color transition directly without medium references

**Evidence:** Session 7345a6e1 iter 5. Complete failure: all 4 images showed painted swatches. Scores dropped to avg ~0.31.

---

#### "Defocused" → Lens Glow/Aurora Effects
**Pattern ID:** `auto-defocused-triggers-lens-effects`
**Confidence:** Low (0% success, 1 test)

**Symptom:** Lens glow, aurora, and light flare effects instead of smooth gradient softness.

**Cause:** "Defocused" activates lens simulation rather than simple softness.

**Fix:**
- Use "smooth", "seamless", or "soft blend" instead of "defocused" for gradient smoothness
- For actual intentional defocus/blur, use "out of focus photography" (tested separately as reliable)

**Evidence:** Session 7345a6e1 iter 6. "Defocused" sabotaged 3/4 images with lens glow/aurora. Image 2 (without lens effects) was one of the best gradient results, proving the rest of the prompt worked.

---

#### Water/Fluid Keywords → 3D Fluid Simulation
**Pattern ID:** `auto-water-vortex-triggers-3d-fluid`
**Confidence:** Low (0% success, 1 test)

**Symptom:** 3D fluid simulation rendering with thick ribbons instead of painted/illustrated linework.

**Cause:** Water/fluid motion keywords (swirling water vortex, fluid patterns) activate MJ's 3D fluid training data, overriding painting/illustration style anchors like "oil painting".

**Fix:**
- Avoid water simulation keywords when seeking painted/illustrated linework
- Describe visual mark-making instead: "fine flowing lines", "delicate strokes", "thin ink lines"

---

#### "Fine Delicate Brushstrokes" → Thick Painterly Marks
**Pattern ID:** `auto-fine-brushstrokes-ignored`
**Confidence:** Low (0% success, 1 test)

**Symptom:** Thick painted marks instead of fine/thin lines.

**Cause:** MJ interprets "brushstrokes" as thick painterly marks regardless of "fine" qualifier.

**Fix:**
- Describe line quality directly: "hair-thin strokes", "thin ink lines", "fine flowing lines"
- Avoid "brushstrokes" keyword entirely
- "Traditional brush drawing on black ground" was more effective than "fine delicate brushstrokes"

---

#### "Torn Paper Edge Texture" → Physical Paper Frame
**Pattern ID:** `auto-torn-paper-creates-frame`
**Confidence:** Low (0% success, 1 test)

**Symptom:** Literal torn paper page sitting on background, creating unwanted frame/border effect.

**Cause:** MJ interprets this as a semantic object (paper) rather than just a texture quality.

**Fix:**
- Avoid "torn paper edge texture" when element isolation is critical
- Use "distressed edges" or "rough ink edges" instead
- Adding "frame" to --no list does not fully prevent this

**Evidence:** Session c2f5cce9. Appeared in 2/4 images in iteration 2 despite --no frame.

---

#### "Double Exposure" in Photorealistic Prompts
**Pattern ID:** `auto-double-exposure-degrades-photo`
**Confidence:** Low (0% success, 1 test)

**Symptom:** Output shifts from photography to artistic/abstract treatment.

**Cause:** "Double exposure" conflicts with --style raw which anchors photorealism.

**Fix:**
- Avoid "double exposure" when photorealistic base is desired
- Use concrete impossible objects instead for surrealism within photorealism

**Evidence:** Session 822750f3 iter 2. Double exposure degraded Fujifilm photorealistic quality. User rejected the artistic shift.

---

#### Pattern/Swirl Keywords → Continuous All-Over Patterns
**Pattern ID:** `auto-continuous-vs-isolated-forms`
**Confidence:** Low (0% success, 1 test)

**Symptom:** Continuous pattern filling the frame instead of isolated floating forms with void between them.

**Cause:** MJ V7 defaults to continuous all-over patterns when given pattern/swirl keywords.

**Fix:**
- Remove "all-over pattern"
- Describe spatial structure explicitly: "scattered discrete shapes floating in dark void", "empty space between form clusters"
- The pattern-filling instinct is strong and persists even with "negative space between strokes"

---

#### Generic 2D/3D Material Contrast Description Fails
**Pattern ID:** `material-contrast-needs-physical-desc`
**Confidence:** Low (0% success, 1 test)

**Symptom:** Face and body rendered in similar material quality despite keywords about different materials.

**Cause:** Describing 2D/3D material contrast as "outline edge" or "separation" is too abstract.

**Fix:**
- Describe material contrast physically using opposing material adjectives for each part
- Example: "flat matte black" for void face vs "glossy luminous rainbow" for body
- Name materials explicitly as different substances rather than relying on edge/outline separation

---

#### Border + Fine Art Print → Physical Print Rendering
**Pattern ID:** `border-triggers-print-framing`
**Confidence:** Low (0% success, 1 test)

**Symptom:** MJ renders the image as a physical print on paper/surface instead of generating the artwork itself.

**Cause:** Combining "painted white border" or "painted border" with "fine art print" creates physical object framing. Variant of Gallery Framing Trap.

**Fix:**
- Remove border and fine art print keywords when they co-occur
- For edge separation, describe it as illustration content: "white edge glow", "glowing edge where dark meets light"
- For style anchoring without photorealism, "spray paint airbrush illustration" alone is sufficient

---

#### MJ UI Style Reference Panel Auto-Selection
**Pattern ID:** `auto-icm-sref-ui-unreliable`
**Confidence:** Low (0% success, 1 test)

**Symptom:** Unintended visual qualities contaminate style transfer; unwanted textures appear.

**Cause:** MJ UI style reference panel auto-selects multiple recent images from your library instead of single selected image.

**Fix:**
- Avoid MJ UI style reference panel for precise style transfer
- Use direct `--sref URL` in prompt text for single-image control
- Or rely on prompt-only approach

**Evidence:** ICM session 365b2d9b iter 8. UI auto-selected 2 refs, introduced unwanted organic fibers. Batch avg dropped from 0.89 (prompt-only iter 6) to 0.78. Needs more testing.

---

#### Editor Inpainting Introduces Unwanted Environmental Elements
**Pattern ID:** `ed01`
**Confidence:** Low (0% success, 1 test)

**Symptom:** MJ editor inpainting regenerates backgrounds with walls, corners, surfaces even when prompt specifies flat/seamless backdrop.

**Cause:** The preserved figure implies a physical space that MJ fills with environmental context.

**Fix:**
- Editor inpainting is not suitable for creating flat seamless backgrounds
- Use prompt-only approaches for flat backdrops instead

**Evidence:** Session 17bbeab3 iter 15. Smart Select segmentation worked but regenerated area had walls and tonal gradients instead of flat gray.

---

#### Editor Edit Creates Grain/Texture Mismatch on sref-Assisted Images
**Pattern ID:** `ed02`
**Confidence:** Low (0% success, 1 test)

**Symptom:** Preserved area has coarse sref-transferred grain; regenerated area has different/smoother grain.

**Cause:** Editor edit regenerates only the selected area, which loses the sref grain transfer applied to the full image.

**Fix:**
- When using editor edit on sref-assisted images, the regenerated area will have different grain character than the preserved area
- This is especially visible with heavy film grain
- Consider whether the texture discontinuity is acceptable before using editor edit

**Evidence:** Session 17bbeab3 iter 15. Preserved figure had coarse sref-transferred grain; regenerated background had smoother different grain.

---

## Patterns Requiring Further Validation

The following patterns have been observed once and need cross-session validation before increasing confidence level:

- **auto-color-swatch-triggers-paint** — Needs at least 2 more tests confirming painted swatches in clean gradient attempts
- **auto-defocused-triggers-lens-effects** — Needs validation that "smooth" consistently outperforms "defocused" across multiple gradient sessions
- **auto-water-vortex-triggers-3d-fluid** — Needs tests comparing water keywords vs alternative linework descriptions
- **auto-fine-brushstrokes-ignored** — Needs comparison tests of "brushstrokes" vs "hair-thin strokes"
- **auto-torn-paper-creates-frame** — Needs tests with different edge descriptors
- **auto-double-exposure-degrades-photo** — Single photo session; needs validation in other photorealistic contexts
- **auto-continuous-vs-isolated-forms** — Pattern/void tradeoff needs testing across 2+ sessions
- **material-contrast-needs-physical-desc** — Needs tests comparing abstract vs physical material descriptions
- **border-triggers-print-framing** — Needs tests of border-only, print-only, and combined variations

---

**Total Patterns:** 18 failure-mode patterns (3 Medium, 15 Low)
**Last Generated:** 2026-02-09
