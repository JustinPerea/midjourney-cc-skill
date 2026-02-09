# Learned Patterns

**Last Updated:** February 8, 2026
**Total Active Patterns:** 87

## Summary

| Category | Count | High | Medium | Low |
|----------|-------|------|--------|-----|
| color | 2 | 1 | 1 | 0 |
| composition | 8 | 0 | 5 | 3 |
| failure-mode | 14 | 0 | 3 | 11 |
| lighting | 3 | 0 | 2 | 1 |
| material | 7 | 0 | 4 | 3 |
| parameters | 10 | 1 | 5 | 4 |
| prompt-construction | 2 | 0 | 0 | 2 |
| prompt-structure | 7 | 0 | 4 | 3 |
| reference-usage | 1 | 0 | 0 | 1 |
| sref | 9 | 1 | 6 | 2 |
| style | 2 | 0 | 1 | 1 |
| technique | 13 | 0 | 8 | 5 |
| workflow | 9 | 1 | 4 | 4 |
| **Total** | **87** | **4** | **43** | **40** |

---

## color

### auto-color-cobalt-blue-anchor
**Confidence:** `HIGH` | **Success Rate:** 100% (5 tests)

**Problem:** Color palette drifts or shifts (e.g., blue becoming green/teal) when color descriptors are not strongly anchored in the prompt

**Solution:** Use 'cobalt blue' as a strong specific color anchor. It remained consistent across 5+ iterations with different prompt structures. Generic 'blue' or positional color descriptions drift more easily.

---

### auto-warm-color-specific-names
**Confidence:** `MEDIUM` | **Success Rate:** 100% (3 tests)

**Problem:** Generic warm color descriptors like "golden hour", "warm amber light" produce inconsistent warmth — some images drift toward yellow or cool reflections break the monochromatic warm palette

**Solution:** Use specific pigment/color names: "burnt sienna", "warm ochre" alongside general warm descriptors. "Entire scene bathed in burnt sienna and warm ochre tones" maintained consistent deep warmth in 4/4 images across 3 iterations, vs "warm amber light" alone which had yellow drift in 2/4.

---

## composition

### auto-composition-flat-frontal-perspective
**Confidence:** `MEDIUM` | **Success Rate:** 100% (2 tests)

**Problem:** MJ V7 defaults to 3/4 angle or dynamic perspective for objects, making centered frontal views unreliable

**Solution:** Use 'flat frontal view' combined with 'orthographic perspective' to enforce consistent head-on centered composition. This combination fixed perspective in 4/4 images after 2/4 were angled without it.

---

### auto-composition-squircle-comprehension
**Confidence:** `MEDIUM` | **Success Rate:** 100% (4 tests)

**Problem:** Getting Midjourney to produce a rounded-square (squircle) shape rather than defaulting to circles or hard rectangles

**Solution:** The keyword 'squircle' is directly understood by MJ V7 and consistently produces rounded-square forms. Reinforcing with 'rounded square shape with soft corners' improves reliability further.

---

### auto-element-position-unreliable
**Confidence:** `MEDIUM` | **Success Rate:** 50% (4 tests)

**Problem:** Specifying element position on an object face (e.g., "doorway on the left side of the front face") is unreliable in MJ V7 — compliance varies from 1/4 to 3/4 across batches and regresses when prompt grows longer

**Solution:** Accept that sub-object element positioning (where a feature sits on a face) is low-reliability in MJ V7. Best strategy: generate multiple batches and select the image with correct placement, then use Vary Subtle to refine. Do not spend multiple iterations trying to fix position through prompt wording alone.

---

### auto-gradient-direction-language
**Confidence:** `MEDIUM` | **Success Rate:** 50% (6 tests)

**Problem:** MJ V7 defaults to horizontal or diagonal gradients when no directional language is present. Abstract gradient prompts without explicit top/bottom instructions produce inconsistent direction.

**Solution:** Use explicit positional directional phrasing: "from [color] at top to [color] at bottom". This was the most effective phrasing tested. Avoid standalone "vertical" which can trigger vertical line/stripe patterns instead of vertical gradients. "Top to bottom" language without "vertical" is safer.

---

### pat-compressed-depth-keyword
**Confidence:** `MEDIUM` | **Success Rate:** 100% (3 tests)

**Problem:** Keywords like 'flat depth' and '2D appearance' are too aggressive for controlling depth in MJ V7, producing truly flat results that lose layered dimensionality

**Solution:** Use 'compressed depth' instead — it reduces 3D extrusion while preserving the sense of layered depth needed for translucent/concentric subjects.

---

### auto-aesthetic-keyword-triggers-layout
**Confidence:** `LOW` | **Success Rate:** 100% (1 test)

**Problem:** Aesthetic/movement keywords like "punk zine aesthetic" trigger compositional behavior in MJ V7 — producing collaged, arranged layouts instead of isolated elements

**Solution:** Remove aesthetic movement keywords when element isolation is needed. "Punk zine aesthetic" caused all 4 images to show composed/collaged layouts with unwanted border treatment. Replacing with purely descriptive material keywords ("screen printed ink on paper", "raw matte finish") preserved the printed feel without triggering layout behavior.

---

### auto-composition-white-bg-art-context
**Confidence:** `LOW` | **Success Rate:** 0% (2 tests) | **ANTI-PATTERN**

**Problem:** White background request is ignored when prompt contains art movement names, gallery references, or artist names — MJ renders dark/gallery backgrounds instead

**Solution:** When white background is essential, avoid art movement labels (color field painting), gallery words (gallery artwork), and artist names. Use 'fine art print' instead, which preserves white background while providing art-quality anchoring.

---

### auto-floating-void-isolation
**Confidence:** `LOW` | **Success Rate:** 100% (1 test)

**Problem:** Getting isolated elements on a solid background — generic phrases like "isolated elements" or "on solid black background" are too weak to override MJ default compositing behavior

**Solution:** "Floating on pure black void" is significantly more effective than "on solid black background" for achieving element isolation. The stronger, more evocative language pushes MJ to treat elements as floating in space rather than arranged on a surface. Best result achieved composition score 0.88 (up from 0.85) with this single keyword change.

---

## failure-mode

### auto-icm-subject-keyword-dominance
**Confidence:** `MEDIUM` | **Success Rate:** 0% (3 tests)

**Problem:** ANY concrete subject keyword — even softened with "hint of", "faint", "dissolving" — dominates blur/abstract/defocus keywords in MJ V7 and re-anchors output in conventional sharp rendering. This applies broadly, not just to ICM: any abstract or defocused effect is overridden by subject nouns.

**Solution:** Do not attempt to soften subject keywords with qualifiers. The only reliable approach is complete subject removal. Even 'hint of dissolving botanical silhouettes' produced identifiable sharp stems and leaves (iter 7: blur scores dropped from 0.90-0.95 to 0.45-0.55). If organic forms are needed, achieve them through Vary Strong on an abstract parent rather than prompt keywords.

**Context:** CROSS-SESSION: Confirmed in 6 sessions (365b2d9b, 39ce7668, 5ebbd0ef, 799400c2, 822750f3, bf0036e5). V7 prompt hierarchy: subject/material > style/abstract > perceptual quality.

---

### auto-warm-color-triggers-fabric
**Confidence:** `MEDIUM` | **Success Rate:** 50% (4 tests)

**Problem:** Warm fabric-associated color names (peach, coral, champagne, blush pink, dusty rose, soft gold, warm ivory) trigger silk/satin fabric rendering in MJ V7 instead of producing smooth abstract gradients

**Solution:** Avoid warm fabric-associated color names in gradient prompts. These colors are strongly associated with silk/satin textile training data in MJ V7. Use cool or cool-dominant palettes for reliable gradients. If warm gradient is needed, try less fabric-associated warm names (e.g., "warm amber", "terracotta") or add explicit anti-fabric keywords to --no (silk, satin, fabric, folds, textile). A single warm-adjacent color (dusty pink) can work when surrounded by dominant cool colors.

---

### pat-gallery-framing-trap
**Confidence:** `MEDIUM` | **Success Rate:** 0% (2 tests)

**Problem:** Combining art movement names (color field painting) with gallery/exhibition context (gallery artwork) causes MJ to render a photo of artwork on a gallery wall rather than generating the artwork itself

**Solution:** Use artist inspiration (e.g. 'James Turrell inspired') without gallery context words. Or use mood/quality words (contemplative, hypnotic luminosity) instead of art movement labels.

---

### auto-color-swatch-triggers-paint
**Confidence:** `LOW` | **Success Rate:** 0% (1 test) | **ANTI-PATTERN**

**Problem:** "Color swatch", "wash", and "matte finish" trigger physical paint/watercolor medium rendering in MJ V7, producing painted swatches on paper instead of clean digital gradients. All 4 images in the batch showed painted swatches with visible brush edges.

**Solution:** Avoid paint-related vocabulary ("color swatch", "wash", "matte finish") when seeking clean digital gradients or color fields. These keywords activate physical medium rendering. Use atmospheric/environmental language instead or describe the color transition directly without medium references.

---

### auto-continuous-vs-isolated-forms
**Confidence:** `LOW` | **Success Rate:** 0% (1 test) | **ANTI-PATTERN**

**Problem:** MJ V7 defaults to continuous all-over patterns when given pattern/swirl keywords — achieving isolated floating forms with void between them requires explicit structural description

**Solution:** To get discrete floating shapes with dark void between them (rather than continuous pattern filling the frame), remove "all-over pattern" and describe the spatial structure explicitly: "scattered discrete shapes floating in dark void", "empty space between form clusters". The pattern-filling instinct is strong and persists even with "negative space between strokes".

---

### auto-defocused-triggers-lens-effects
**Confidence:** `LOW` | **Success Rate:** 0% (1 test) | **ANTI-PATTERN**

**Problem:** "Defocused" triggers lens glow, aurora, and light flare effects in MJ V7 instead of producing smooth gradient softness. In a gradient context, 3 of 4 images showed lens artifacts instead of smooth transitions.

**Solution:** Use "smooth", "seamless", or "soft blend" instead of "defocused" when seeking gradient smoothness. "Defocused" activates lens simulation rather than simple softness. For actual intentional defocus/blur, use "out of focus photography" (tested separately as reliable).

---

### auto-double-exposure-degrades-photo
**Confidence:** `LOW` | **Success Rate:** 0% (1 test) | **ANTI-PATTERN**

**Problem:** Adding "double exposure" to photorealistic street photography prompt shifted output from photography to artistic/abstract treatment

**Solution:** Avoid "double exposure" when photorealistic base is desired. It conflicts with --style raw which anchors photorealism. Use concrete impossible objects instead for surrealism within photorealism.

---

### auto-fine-brushstrokes-ignored
**Confidence:** `LOW` | **Success Rate:** 0% (1 test) | **ANTI-PATTERN**

**Problem:** "Fine delicate brushstrokes" does not produce fine/thin lines in MJ V7 — MJ interprets brushstrokes as thick painted marks regardless of "fine" qualifier

**Solution:** Describe the line quality directly: "hair-thin strokes", "thin ink lines", "fine flowing lines". Avoid "brushstrokes" as it triggers thick painterly marks. "Traditional brush drawing on black ground" was more effective than "fine delicate brushstrokes" for achieving visible individual lines.

---

### auto-icm-sref-ui-unreliable
**Confidence:** `LOW` | **Success Rate:** 0% (1 test) | **ANTI-PATTERN**

**Problem:** Using Midjourney UI style reference panel auto-selects multiple recent images from your library, contaminating the style transfer with unintended visual qualities

**Solution:** Avoid the MJ UI style reference panel for precise style transfer. It auto-loaded 2 images instead of 1, introducing unwanted organic fiber textures. Use direct --sref URL in prompt text for single-image control, or rely on prompt-only approach which proved more reliable in this session.

---

### auto-torn-paper-creates-frame
**Confidence:** `LOW` | **Success Rate:** 0% (1 test) | **ANTI-PATTERN**

**Problem:** "Torn paper edge texture" is interpreted by MJ V7 as a literal torn paper page sitting on background, creating unwanted frame/border effect

**Solution:** Avoid "torn paper edge texture" when element isolation is critical — it creates paper-as-frame compositions. Use "distressed edges" or "rough ink edges" instead. Even adding "frame" to --no list does not fully prevent this.

---

### auto-water-vortex-triggers-3d-fluid
**Confidence:** `LOW` | **Success Rate:** 0% (1 test) | **ANTI-PATTERN**

**Problem:** Water/fluid motion keywords (swirling water vortex, fluid patterns) trigger 3D fluid simulation rendering in MJ V7, overriding painting/illustration style anchors like oil painting

**Solution:** Avoid water simulation keywords when seeking painted/illustrated linework. Describe the visual mark-making instead: "fine flowing lines", "delicate strokes", "thin ink lines". Water/fluid keywords activate MJ's 3D fluid training data, producing thick ribbons instead of fine brushwork.

---

### border-triggers-print-framing
**Confidence:** `LOW` | **Success Rate:** 0% (1 test) | **ANTI-PATTERN**

**Problem:** Combining painted white border or painted border with fine art print causes MJ to render the image as a physical print on paper/surface instead of generating the artwork itself. This is a variant of the Gallery Framing Trap.

**Solution:** Remove border and fine art print keywords when they co-occur. For edge separation between face and body, describe it as part of the illustration content: white edge glow, glowing edge where dark meets light. For style anchoring without photorealism, spray paint airbrush illustration alone is sufficient.

---

### ed01
**Confidence:** `LOW` | **Success Rate:** 0% (1 test) | **ANTI-PATTERN**

**Problem:** MJ editor inpainting introduces environmental elements (walls, corners, surfaces) when regenerating backgrounds, even when the prompt specifies flat/seamless backdrop

**Solution:** Editor inpainting is not suitable for creating flat seamless backgrounds. The preserved figure implies a physical space that MJ fills with environmental context. Use prompt-only approaches for flat backdrops instead.

---

### ed02
**Confidence:** `LOW` | **Success Rate:** 0% (1 test) | **ANTI-PATTERN**

**Problem:** Editor edit creates grain/texture mismatch between preserved and regenerated areas when the original image had sref-assisted grain

**Solution:** When using editor edit on sref-assisted images, the regenerated area will have different grain character than the preserved area. This is especially visible with heavy film grain. Consider whether the texture discontinuity is acceptable before using editor edit.

---

### material-contrast-needs-physical-desc
**Confidence:** `LOW` | **Success Rate:** 0% (1 test) | **ANTI-PATTERN**

**Problem:** Describing 2D/3D material contrast as outline edge or separation does not produce visible contrast. MJ renders face and body in similar material quality despite keywords about different materials.

**Solution:** Describe the material contrast physically: use opposing material adjectives for each part. Flat matte for void face vs glossy/luminous for body. Name the materials explicitly as different substances rather than relying on outline edge to create separation.

---

## lighting

### lighting-dual-tone-explicit
**Confidence:** `MEDIUM` | **Success Rate:** 0% (0 tests)

**Problem:** Midjourney defaults to single light source even when dual-tone lighting is implied by the prompt

**Solution:** Specify both light colors with explicit directions (e.g., "from left", "from right")

---

### lighting-rim-direction
**Confidence:** `MEDIUM` | **Success Rate:** 0% (0 tests)

**Problem:** Rim lighting appears random or absent when direction is not specified

**Solution:** Always specify the direction of rim lighting explicitly

---

### lighting-volumetric-vs-godrays
**Confidence:** `LOW` | **Success Rate:** 0% (0 tests)

**Problem:** God rays produces heavy dramatic beams; too intense for subtle atmospheric lighting

**Solution:** Use "volumetric lighting" for subtle atmosphere, reserve "god rays" for dramatic shafts of light

---

## material

### material-chrome-explicit
**Confidence:** `MEDIUM` | **Success Rate:** 100% (4 tests)

**Problem:** The keyword "reflective" alone does not produce convincing chrome or mirror surfaces

**Solution:** Use "mirror finish" or "chrome" explicitly for highly reflective metallic surfaces

---

### pat-physics-keywords-anchor-photorealism
**Confidence:** `MEDIUM` | **Success Rate:** 67% (4 tests)

**Problem:** Physics-simulation keywords (subsurface scattering, polished smooth surface, glass, octane render) force MJ V7 into photorealistic rendering even when other style keywords request flat/graphic output. This extends to any literal material descriptor — the material > style hierarchy is a core V7 behavior.

**Solution:** Remove LITERAL MATERIAL keywords (glass, polished, octane, chrome) but keep PERCEPTUAL QUALITY keywords (translucent, luminous, glowing). Material-literal keywords sit above style keywords in V7 prompt hierarchy. For graphic/flat styles, use "graphic quality" and medium anchors instead. When photorealism IS the goal, material keywords are beneficial.

**Context:** CONDITIONAL: This pattern applies when graphic/flat/illustrated output is intended. When photorealism IS the goal, subsurface scattering is beneficial — see material-subsurface-scattering. | CROSS-SESSION: V7 prompt hierarchy confirmed across 6 sessions: material-literal > style-abstract > perceptual-quality. Perceptual words do not trigger photorealism.

---

### material-subsurface-scattering
**Confidence:** `MEDIUM` | **Success Rate:** 0% (0 tests)

**Problem:** The keyword "translucent" alone produces flat, unconvincing see-through materials

**Solution:** Add "subsurface scattering" for convincing internal light behavior in translucent materials

**Context:** CONDITIONAL: Subsurface scattering helps translucent materials WHEN photorealism is desired, but CONFLICTS with flat/graphic styles — see pat-physics-keywords-anchor-photorealism. Use only when photorealistic rendering is the goal.

---

### forms-sculpture-geometric-bias
**Confidence:** `MEDIUM` | **Success Rate:** 0% (0 tests)

**Problem:** The keyword "sculpture" biases output toward geometric, angular forms even when organic is intended

**Solution:** Prepend "organic" or "organic flowing" before form descriptions that include sculpture

---

### forms-blob-organic
**Confidence:** `LOW` | **Success Rate:** 0% (0 tests)

**Problem:** Achieving amorphous organic forms is difficult with typical descriptors

**Solution:** The keyword "blob" is surprisingly effective for abstract organic forms

---

### forms-fluid-vs-liquid
**Confidence:** `LOW` | **Success Rate:** 0% (0 tests)

**Problem:** The keyword "liquid" implies wetness and puddles; not ideal for describing flowing solid forms

**Solution:** Use "fluid" instead of "liquid" for flowing forms that should remain solid

---

### material-matte-glossy-conflict
**Confidence:** `LOW` | **Success Rate:** 0% (0 tests)

**Problem:** Using both "matte" and "glossy" in the same prompt creates confused, inconsistent surface rendering

**Solution:** Pick one surface finish or use "satin" for a middle ground between matte and glossy

---

## parameters

### auto-icm-s100-raw-dreamy
**Confidence:** `HIGH` | **Success Rate:** 100% (5 tests)

**Problem:** Default --s values or lower stylize with --style raw do not produce sufficiently dreamy/ethereal quality for abstract blur photography

**Solution:** Use --s 100 combined with --style raw for dreamy abstract blur photography. This combination produced the highest-scoring batches in the ICM session (0.83, 0.89, 0.895 averages). The higher stylize adds aesthetic dreaminess while raw prevents MJ from over-interpreting the prompt.

---

### 665ac2ad
**Confidence:** `MEDIUM` | **Success Rate:** 75% (1 test)

**Problem:** Expanded --no list reduces sref text transfer to ~25%

**Solution:** Add "text, words, writing, typography, lettering, font, characters" to --no when sref references contain text overlays. Not 100% effective but significantly reduces incidence.

---

### auto-stylize-gradient-smoothness
**Confidence:** `MEDIUM` | **Success Rate:** 50% (4 tests)

**Problem:** --s 0 produces harsh transitions with visible banding in gradients. Very low stylize values remove the aesthetic smoothing that gradients need.

**Solution:** Use --s 75-100 for smooth gradient transitions. --s 100 produced the smoothest result (iter 4), --s 75 was acceptable (iter 6), --s 50 was adequate (iter 1), and --s 0 was too harsh (iter 3). Higher stylize values contribute to smoother color blending.

---

### params-prompt-adherence
**Confidence:** `MEDIUM` | **Success Rate:** 100% (4 tests)

**Problem:** High stylize values cause MJ to deviate significantly from prompt, ignoring specific descriptors

**Solution:** For maximum prompt adherence, use --s 50-100 combined with --style raw

---

### v7-personref-change
**Confidence:** `MEDIUM` | **Success Rate:** 0% (0 tests)

**Problem:** --cref (character reference) was removed in V7

**Solution:** Use --oref instead of --cref for character/object reference in V7

---

### auto-no-warm-colors-blocks-contamination
**Confidence:** `LOW` | **Success Rate:** 100% (1 test)

**Problem:** When generating abstract gradients or cool-toned outputs, MJ V7 can introduce warm color contamination (sunset orange, pink, yellow) especially when sky/atmospheric metaphors are used.

**Solution:** Add explicit warm color names to the --no parameter: "--no warm, orange, yellow, pink, sunset". This effectively blocks warm contamination while preserving cool teal-to-white gradients. Confirmed effective in iter 6 where warm contamination from iter 4 (sky metaphor) was eliminated.

---

### params-no-clutter
**Confidence:** `LOW` | **Success Rate:** 0% (0 tests)

**Problem:** Lowering --s alone is insufficient to clean up busy, cluttered outputs

**Solution:** Combine lower --s with --no to explicitly exclude unwanted elements (e.g., --no clutter, busy, complex background)

---

### params-weird-range
**Confidence:** `LOW` | **Success Rate:** 0% (0 tests)

**Problem:** High --weird values produce unpredictable, often unusable results

**Solution:** Use --weird 50-150 for subtle creative interest; values above 200 become unpredictable

---

### raw-sref-source-dependent
**Confidence:** `LOW` | **Success Rate:** 50% (2 tests)

**Problem:** --style raw + --sref interaction produces opposite results depending on the sref source image. Raw blocks MJ's interpretive layer, which hurts when the sref needs interpretation (professional photo to illustration) but helps when the sref already has the right qualities (self-generated illustration).

**Solution:** Match --style raw usage to sref source type. If sref is a professional/photographic image that needs MJ to reinterpret it as illustration, OMIT --style raw. If sref is already in the target style (e.g., your own generated output), USE --style raw to prevent MJ from adding its own interpretation on top.

---

## prompt-construction

### product-photo-pattern-transfer
**Confidence:** `LOW` | **Success Rate:** 100% (1 test)

**Problem:** Applying artistic session patterns to commercial product photography

**Solution:** Patterns from artistic sessions (explicit lighting direction, material-specific adjectives like subsurface scattering, mirror finish) transfer directly to product photography. Achieved 0.879 batch avg on first attempt.

---

### rim-light-intensity
**Confidence:** `LOW` | **Success Rate:** 0% (1 test)

**Problem:** Rim light renders subtle despite explicit mention in prompt

**Solution:** Simple "rim light on [subject] edges" produces visible but weak rim. Likely needs intensity modifiers like "strong" or "bright" to increase prominence.

---

## prompt-structure

### 58466c50
**Confidence:** `MEDIUM` | **Success Rate:** 50% (4 tests)

**Problem:** "fine art print" causes grain/stipple in ~50% of images

**Solution:** Use "compressed depth" + "flat color zones" instead of "fine art print" for achieving flat/2D appearance without grain side effects.

**Context:** CONTRASTIVE: Safe alone. Triggers Gallery Framing Trap with border/frame keywords (add "border, frame" to --no). Introduces grain/stipple ~50% of time. Safer alternative: "spray paint airbrush illustration".

---

### prompt-frontload-subject
**Confidence:** `MEDIUM` | **Success Rate:** 0% (0 tests)

**Problem:** Important subjects or elements buried later in the prompt get less attention from MJ

**Solution:** Front-load the most important element as the first thing in the prompt

---

### prompt-one-render-engine
**Confidence:** `MEDIUM` | **Success Rate:** 0% (0 tests)

**Problem:** Naming multiple render engines (Octane, Cinema 4D, Blender) in the same prompt causes style confusion

**Solution:** Choose one render engine reference that best matches the desired look

---

### reflect-medium-frontload-v7
**Confidence:** `MEDIUM` | **Success Rate:** 100% (6 tests)

**Problem:** Without an explicit medium keyword at the start of the prompt, V7 defaults to photorealistic rendering regardless of other style keywords later in the prompt.

**Solution:** Front-load the medium as the first phrase: "Spray paint airbrush illustration of..." or "Oil painting of..." or "35mm film photography of...". V7 weights prompt beginning most heavily. The medium keyword anchors the entire rendering style. Without it, adding style keywords later in the prompt cannot override the photorealism default.

---

### auto-prompt-structure-dont-embellish-optimized
**Confidence:** `LOW` | **Success Rate:** 0% (1 test) | **ANTI-PATTERN**

**Problem:** Adding mood keywords, artist references, or stylistic embellishments to an already-optimized prompt destabilizes it and causes score regression

**Solution:** Once a prompt achieves high scores (0.80+), resist adding more keywords. Iteration 5's 0.83 dropped to 0.73 when mood/artist words were added in iteration 6. Treat high-scoring prompts as fragile — test additions in separate branches, not by appending to the winner.

---

### pat-medium-first-loses-detail
**Confidence:** `LOW` | **Success Rate:** 0% (1 test) | **ANTI-PATTERN**

**Problem:** Leading with abstract medium description (geometric abstraction, concentric rounded squares) and omitting specific material/light descriptors produces flat but lifeless results lacking luminosity

**Solution:** Include visual-quality descriptors (translucent, soft diffused light, warm glow) even in minimal prompts. Material feel and light quality are essential for luminous results.

---

### prompt-expansion-dilution
**Confidence:** `LOW` | **Success Rate:** 0% (1 test) | **ANTI-PATTERN**

**Problem:** When expanding a minimal prompt to full composition, specific details (like eye characteristics) get lost because they are pushed further back. V7 weights beginning of prompt most heavily, so expansion dilutes priority details.

**Solution:** Restructure expanded prompts so the MOST CRITICAL visual detail stays at the very front. Use pattern: [Critical detail] + [Medium] + [Subject context] rather than [Medium] + [Subject] + [Critical detail buried in middle].

---

### v7-simpler-prompts
**Confidence:** `LOW` | **Success Rate:** 100% (1 test)

**Problem:** V7 handles prompt complexity differently than V6; overly detailed prompts can confuse V7

**Solution:** Use simpler, more concise prompts in V7. Complexity that worked in V6 may need simplification.

---

## reference-usage

### oref-env-transfer
**Confidence:** `LOW` | **Success Rate:** 100% (1 test)

**Problem:** Need to maintain object identity when changing environment/context

**Solution:** --oref with CDN URL preserves object shape, material, color, and proportions while allowing completely different lighting/environment. The prompt controls environment freely.

---

## sref

### sref-url-reuse
**Confidence:** `HIGH` | **Success Rate:** 100% (5 tests)

**Problem:** Re-uploading reference images via MJ UI for each iteration is slow and unreliable

**Solution:** After first UI-based sref upload, capture the CDN URL (s.mj.run/...) from job metadata and reuse it with --sref URL in subsequent prompts directly in the text input.

---

### 0ab75dde
**Confidence:** `MEDIUM` | **Success Rate:** 100% (3 tests)

**Problem:** AI text removal from sref references degrades output fidelity

**Solution:** Use pixel-level inpainting (Photoshop content-aware fill) instead of AI regeneration tools (Nano Banana) for cleaning sref reference images. AI tools regenerate at lower quality.

---

### 02d67944
**Confidence:** `MEDIUM` | **Success Rate:** 100% (1 test)

**Problem:** Cropping sref references to remove unwanted elements degrades output quality

**Solution:** Use expanded --no lists or hybrid ref approaches instead of cropping. Cropped images lose essential style information the sref system needs.

---

### 664b9f6b
**Confidence:** `MEDIUM` | **Success Rate:** 100% (1 test)

**Problem:** Hybrid sref approach reduces text artifacts while maintaining sharpness

**Solution:** Mix one original reference (with text) and one cleaned reference to reduce text transfer ~50% while keeping most of the sharpness from the original.

---

### 75c81368
**Confidence:** `MEDIUM` | **Success Rate:** 100% (2 tests)

**Problem:** Style codes produce higher first-iteration scores than prompt-only or image-sref approaches

**Solution:** When the target aesthetic matches a known MJ style code, use --sref <code> instead of prompt-only. Combine with a simple, focused prompt covering subject/scene while the code handles aesthetic. Expect 0.89+ batch avg on first iteration vs 0.50-0.70 for prompt-only.

---

### reflect-sref-breaks-ceiling
**Confidence:** `MEDIUM` | **Success Rate:** 100% (2 tests)

**Problem:** Complex prompt-only recreations hit a ceiling around 0.78-0.82 that no amount of keyword refinement can break through.

**Solution:** Introduce --sref with reference image to break the ceiling. Use --sw 200 for structural features (not just style). Keep the best prompt text alongside the sref — the prompt handles what the reference cannot specify (like unusual anatomy or specific spatial arrangements). Expected jump: 0.80 -> 0.86+.

---

### sref-structural-transfer
**Confidence:** `MEDIUM` | **Success Rate:** 50% (4 tests)

**Problem:** Style reference (--sref) only transfers visual style not structural features like multi-eye or unusual anatomy

**Solution:** Use --sw 200+ to increase structural influence from reference image. Combine with explicit text description of structural features.

---

### 2b436354
**Confidence:** `LOW` | **Success Rate:** 100% (2 tests)

**Problem:** Sref reads design context holistically — text overlays signal high production value

**Solution:** When reference images have text overlays, MJ interprets them as higher production value. Removing text may reduce perceived quality. Consider hybrid approach or accepting minor text artifacts.

---

### self-sref-technique
**Confidence:** `LOW` | **Success Rate:** 100% (1 test)

**Problem:** When the original reference image pushes MJ toward the wrong style (e.g., album cover production polish to photorealism), using it as --sref transfers unwanted qualities instead of the target aesthetic.

**Solution:** Use your own best generated output as --sref instead of the original reference. Generate 2-3 prompt-only iterations to establish the right direction, pick the best image, then feed it back as --sref. This transfers the exact qualities you achieved (color palette, line style, rendering mode) without the original's production context contamination.

---

## style

### pat-style-anchor-hierarchy
**Confidence:** `MEDIUM` | **Success Rate:** 67% (4 tests)

**Problem:** Different style anchor keywords produce different levels of graphic vs photorealistic rendering in MJ V7

**Solution:** Use 'fine art print' for strongest graphic quality anchoring. 'digital illustration' is moderate. 'abstract graphic artwork' is weakest and can still drift toward 3D.

---

### auto-style-artist-ref-triggers-3d
**Confidence:** `LOW` | **Success Rate:** 0% (2 tests) | **ANTI-PATTERN**

**Problem:** Artist reference keywords (e.g., 'James Turrell inspired') trigger physical art installation or 3D object rendering in MJ V7, even WITHOUT gallery/exhibition context words

**Solution:** Avoid artist references entirely when seeking flat/graphic output. The existing advice to 'use artist inspiration without gallery context' is insufficient — the artist name alone anchors rendering toward physical art. Use mood/quality descriptors (contemplative, luminous) separated from artist names.

---

## technique

### auto-cool-gradient-prompt-structure
**Confidence:** `MEDIUM` | **Success Rate:** 100% (3 tests)

**Problem:** Need a reliable prompt structure for generating smooth multi-directional pastel gradient wallpapers in MJ V7

**Solution:** Use the structure: "soft pastel color gradient, [color A] and [color B] blending into [color C] and [color D], smooth seamless color transition, abstract soft focus light, gaussian blur, out of focus photography, gentle light diffusion --ar 16:9 --s 100 --style raw --no texture, pattern, shapes, objects, text, lines, grain, subject, detail, sharp". Works reliably for cool and cool-dominant palettes. Produces amorphous multi-directional color zones with zero texture.

---

### auto-film-grain-stack-analog
**Confidence:** `MEDIUM` | **Success Rate:** 100% (7 tests)

**Problem:** Need authentic film texture in MJ V7 without degrading image quality

**Solution:** Use "film grain, 35mm" — produces organic film-like grain texture. Works well with --style raw and Fujifilm camera model references. Consistent across all iterations tested.

---

### auto-fujifilm-camera-model-anchor
**Confidence:** `MEDIUM` | **Success Rate:** 100% (7 tests)

**Problem:** Need to achieve Fujifilm-specific color rendering (muted teal shadows, warm amber highlights) in MJ V7

**Solution:** Use "shot on Fujifilm X100V, Fujifilm Superia film simulation" — camera model acts as style anchor, film simulation name triggers characteristic color split. Works with --style raw. Camera model is not rendered literally; it sets the visual style.

---

### auto-heavy-no-list-abstract
**Confidence:** `MEDIUM` | **Success Rate:** 100% (4 tests)

**Problem:** MJ V7 has a strong tendency to add subjects, objects, textures, and recognizable elements to abstract/minimal prompts. Simple "no subject" is often insufficient.

**Solution:** Use a comprehensive --no list for abstract output: "--no clouds, sky, landscape, horizon, objects, text, texture, noise, grain, shapes, lines, subject, person, figure, pattern". This heavy negative prompt was effective in achieving zero subject contamination across multiple iterations. Front-load "no subject" in the prompt text AND in --no for double reinforcement.

---

### auto-icm-out-of-focus-photography
**Confidence:** `MEDIUM` | **Success Rate:** 100% (4 tests)

**Problem:** Standard blur keywords like 'motion blur', 'blurred', 'defocused' are unreliable for producing actual out-of-focus or blur effects in MJ V7

**Solution:** Use 'out of focus photography' as a keyword — it consistently produces genuine defocused output. Combine with 'gaussian blur' for softer edges and 'camera shake' for directional blur quality.

**Context:** CONTRASTIVE: Works cleanly ONLY in pure abstract contexts with no subject and no organic forms. In photographic contexts triggers bokeh circles. With organic forms triggers 3D volume.

---

### auto-icm-remove-subject-for-blur
**Confidence:** `MEDIUM` | **Success Rate:** 60% (5 tests)

**Problem:** Midjourney V7 ignores blur/motion keywords (motion blur, intentional camera movement, long exposure, camera shake) when a recognizable subject (flowers, petals, botanical) is present in the prompt — the subject anchors MJ in conventional sharp photography

**Solution:** Remove ALL subject keywords to achieve abstract blur/ICM effects. Describe only the visual qualities: light, color transitions, blur type, atmosphere. Use 'abstract soft focus light' or 'defocused light' as lead concept instead of naming subjects. Subject keywords can be reintroduced only through Vary Strong on an already-abstract parent.

---

### auto-mood-words-v7-direct
**Confidence:** `MEDIUM` | **Success Rate:** 100% (11 tests)

**Problem:** Uncertainty about whether V7 handles mood/atmosphere keywords directly or needs translation to visual equivalents

**Solution:** V7 handles mood keywords (cinematic, surreal, contemplative) directly and effectively for photorealistic surreal scenes. "Cinematic, surreal, contemplative" consistently produced the intended mood across all 4 iterations with 0.88-0.95 mood scores. No translation to visual equivalents needed.

---

### auto-concrete-impossible-elements
**Confidence:** `MEDIUM` | **Success Rate:** 60% (5 tests)

**Problem:** Abstract surreal modifiers (surreal, impossible reflections, double exposure) are treated as mood words by MJ V7 --style raw, not as structural scene elements

**Solution:** Describe a specific impossible OBJECT (whale silhouette, paper cranes, koi fish swimming in air) rather than an impossible EFFECT (double exposure, melting buildings, impossible reflections). MJ renders concrete objects reliably even when physically impossible. Best results come from multiples (flock of cranes > single astronaut) or massive scale (whale > astronaut).

---

### multi-eye-anatomy-prior
**Confidence:** `MEDIUM` | **Success Rate:** 50% (4 tests)

**Problem:** MJ V7 has extremely strong 2-eye facial anatomy priors that resist multi-eye descriptions

**Solution:** Use "almond eyes stacked vertically" not "eye-slits arranged down". Word "almond" produces eye shapes while "slits" produces tear streaks. Combine with --sref + --sw 200.

---

### ed03
**Confidence:** `MEDIUM` | **Success Rate:** 33% (3 tests)

**Problem:** --style raw increases grain texture fidelity but darkens the overall image. Removing --raw brightens the image but reduces grain quality.

**Solution:** When grain and lighting are both critical, this is a fundamental tradeoff with no single-prompt solution. Best approach: accept the balanced result (with --raw at moderate sref weight) rather than trying to maximize both. Alternatively, use editor edit to fix lighting regionally, accepting some texture mismatch.

---

### auto-color-harmonious-surreal
**Confidence:** `LOW` | **Success Rate:** 50% (4 tests)

**Problem:** Surreal elements can clash with scene color palette, reducing visual cohesion and score

**Solution:** Choose surreal elements whose natural colors match the scene palette. Paper cranes and koi (warm amber/gold) harmonized with Fujifilm neon highlights (0.919 and 0.896). Jellyfish (cool bioluminescent) got absorbed into teal fog (0.871). The surreal element should complement, not fight, the color scheme.

---

### auto-levitation-strong-language
**Confidence:** `LOW` | **Success Rate:** 50% (2 tests)

**Problem:** Subtle levitation/floating keywords like "hovering slightly above" are ignored by MJ V7 — objects remain grounded

**Solution:** Use strong levitation language: "levitating above the [surface]", "suspended in air with a visible gap and shadow on the ground beneath it". The combination of levitating + suspended + visible gap + shadow achieved floating in 3/4 images after "hovering slightly" achieved 0/4.

---

### auto-pure-black-canvas-contrast
**Confidence:** `LOW` | **Success Rate:** 100% (1 test)

**Problem:** Light-on-dark contrast structure is lost when using color-based descriptions (teal cyan on dark slate blue) without explicitly specifying the ground as pure black

**Solution:** Use "pure black canvas" or "against dark void" + "high contrast linework" to establish the figure-ground relationship. This produced a +0.17 batch average improvement. Without explicit black ground keywords, lines blend into a uniform gradient.

---

### auto-sky-metaphor-smooth-gradient
**Confidence:** `LOW` | **Success Rate:** 100% (1 test)

**Problem:** Achieving perfectly smooth color transitions (gradients) in MJ V7 is difficult with literal gradient vocabulary. MJ adds focal spots, banding, or texture to abstract color fields.

**Solution:** Use sky/atmosphere metaphors ("clear dusk sky", "zenith fading to horizon", "atmospheric color transition") to leverage MJ training data on smooth sky gradients. This produced the smoothest gradients and correct muted teal hue. However, dusk/horizon language triggers warm sunset colors at the bottom — combine with --no warm,sunset,orange if pure white endpoint is needed.

---

### v7-abstract-concepts
**Confidence:** `LOW` | **Success Rate:** 0% (0 tests)

**Problem:** In V6, abstract emotional concepts needed translation to visual descriptors. V7 understands them directly.

**Solution:** In V7, use abstract concepts like "melancholy" or "euphoria" directly instead of translating to visual equivalents

---

## workflow

### vary-subtle-structural-stability
**Confidence:** `HIGH` | **Success Rate:** 100% (2 tests)

**Problem:** Need to polish high-scoring structural breakthrough without losing the structural feature

**Solution:** Vary Subtle preserves structural breakthroughs (like multi-eye) across multiple rounds. Multi-eye remained stable across 2 rounds of Vary Subtle (iter 14->15->16). Safe to use for polishing.

**Context:** CONTRASTIVE: Vary Subtle is a PRESERVATION tool, not improvement. 0% success rate for score improvement (4 uses), 0% regression rate. Use to lock in gains after breakthrough, not to push past plateau.

---

### auto-icm-vary-strong-refinement
**Confidence:** `MEDIUM` | **Success Rate:** 100% (3 tests)

**Problem:** Single generations of abstract blur produce inconsistent quality — some images in a batch may be too formless, too dense, or have unwanted artifacts

**Solution:** Use Vary Strong chaining on the best image from an abstract blur batch. Each round refines the quality while preserving the core blur aesthetic. 2-3 rounds of Vary Strong on a strong parent converges toward the quality target. Batch averages improved: 0.83 -> 0.89 -> 0.895 across 3 rounds.

---

### meta-capability-check
**Confidence:** `MEDIUM` | **Success Rate:** 0% (5 tests) | **ANTI-PATTERN**

**Problem:** Sessions attempting effects MJ fundamentally cannot produce (ICM motion blur, 2D/3D material contrast within single figure, fine linework control) consume 7+ iterations then get abandoned

**Solution:** Before committing to a session, assess whether the intent aligns with MJ strengths (photorealism, abstract gradients, style transfer) vs known limitations. If the core effect is a known limitation, recommend --sref or adjusted intent upfront rather than iterating on keywords.

---

### meta-iteration-ceiling
**Confidence:** `MEDIUM` | **Success Rate:** 55% (11 tests)

**Problem:** Continuing to refine keywords after 3+ consecutive prompt edits without >0.05 score improvement leads to stagnation and eventual abandonment

**Solution:** If batch avg has not improved by >0.05 over 3 consecutive prompt edits, switch approach entirely: add --sref, try a style code, simplify the intent, or change subject framing. Keyword refinement has diminishing returns.

---

### reflect-prompt-edit-ceiling
**Confidence:** `MEDIUM` | **Success Rate:** 0% (10 tests) | **ANTI-PATTERN**

**Problem:** Prompt edits after iteration 6 have 0% success rate across all sessions. Sessions plateau and incremental keyword changes stop producing improvement.

**Solution:** After 6 failed prompt edits, switch strategy: introduce --sref with a reference image, fundamentally restructure the concept, or accept the current quality and polish with Vary Subtle. The only session that broke a late-stage plateau (bf0036e5) did so by introducing --sref at iteration 12 — a strategy change, not incremental tweaking.

---

### 25e22edf
**Confidence:** `LOW` | **Success Rate:** 100% (1 test)

**Problem:** Style Explorer page is a high-value resource for discovering curated aesthetics

**Solution:** Browse midjourney.com/explore?tab=styles_top_month before starting sessions. Each style card shows 3 preview images and a numeric --sref code. Clicking reveals an 8-image grid across different subjects, showing how the style transfers. Use /discover-styles command.

---

### illustration-prompt-ceiling
**Confidence:** `LOW` | **Success Rate:** 100% (1 test)

**Problem:** Complex illustration styles with precise linework, specific color palettes, and compositional elements hit a lower prompt-only ceiling (~0.65-0.70) than photographic recreations (~0.78-0.82). Words cannot hold all 7 visual dimensions simultaneously for illustration — fixing one (e.g., line fineness) breaks another (e.g., composition/ground plane).

**Solution:** For complex illustration targets, expect prompt-only ceiling around 0.65-0.70 (vs 0.78-0.82 for photographic). Plan to introduce --sref earlier (after 2-3 prompt iterations rather than 5+). Use the prompt-only phase to establish the right direction for self-sref, not to reach final quality.

---

### oref-cdn-url-workflow
**Confidence:** `LOW` | **Success Rate:** 100% (1 test)

**Problem:** Need to use --oref with a previously generated MJ image without re-uploading via UI

**Solution:** Use the CDN URL directly: https://cdn.midjourney.com/{job-id}/{index}_{index}.jpeg — MJ accepts it and converts to s.mj.run shortlink automatically. No UI upload needed. Object identity (shape, color, material, proportions) preserved across completely different environments.

---

### 8c8ee1ec-64e2-4d41-0449-8791d9f2223a
**Confidence:** `LOW` | **Success Rate:** 0% (2 tests) | **ANTI-PATTERN**

**Problem:** Adding keywords to fix one visual element (e.g., levitation language) may degrade compliance on other positional elements (e.g., doorway position regressed from 3/4 correct to 2/4 correct)

**Solution:** When adding new descriptors to fix a gap, check whether existing positional/compositional elements are at risk. Consider Vary Subtle on a strong candidate instead of prompt edits that lengthen the prompt. If prompt edit is necessary, try replacing rather than appending keywords.

---

### auto-vary-subtle-cant-fix-prompt
**Confidence:** `LOW` | **Success Rate:** 0% (1 test) | **ANTI-PATTERN**

**Problem:** Vary Subtle preserves overall image quality and composition but cannot fix issues that originate in the prompt text (e.g., wrong element position, missing features)

**Solution:** Use Vary Subtle only for polish/refinement when the parent image is already close to target. For prompt-level issues (wrong position, missing element, incorrect spatial relationships), edit the prompt instead. Vary Subtle modifies rendering details, not semantic content.

---
