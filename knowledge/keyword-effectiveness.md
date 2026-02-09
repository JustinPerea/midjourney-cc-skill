# Keyword Effectiveness

**Last updated:** February 8, 2026
**Total keywords:** 117

This document catalogs keyword performance in Midjourney V7 based on logged iteration evidence. Keywords are ranked by effectiveness level and include usage statistics, actual effects observed, and contextual notes.

| Tier | Count | Description |
|------|-------|-------------|
| Excellent | 38 | Highly reliable, consistent intended effects |
| Good | 37 | Strong performance with contextual limitations |
| Moderate | 8 | Mixed or context-dependent results |
| Poor | 12 | Low effectiveness, minimal impact |
| Counterproductive | 22 | Produces unwanted effects, avoid |

---

## Excellent (38 keywords)

Highly reliable keywords that consistently produce intended effects across multiple iterations.

### --sref 1568402756
- **Intended effect:** White studio minimal product photography — clean seamless white background, soft diffuse lighting, premium retail/Apple-product-page aesthetic
- **Actual effect:** Ultra-clean white studio environment. Near-monochrome white/light gray palette. Soft even lighting with gentle gradients, no harsh shadows. Objects rendered on pristine white seamless backgrounds with clean negative space. Very strong style override — desaturates and simplifies everything into minimal gallery presentation. Photorealistic with 3D-render quality.
- **Usage:** 1 used, 1 effective
- **Context:** style-code
- **Notes:** Best for: bright, clean product shots, hero images, e-commerce. Suggested --sw 100-150. May wash out dark products — consider --sw 50-75 for dark subjects. Strong composition control — centers subjects with generous negative space.

### --sref 2569901087
- **Intended effect:** Dark studio dramatic product photography — moody charcoal/slate environment with architectural strip lighting, luxury brand campaign aesthetic
- **Actual effect:** Dark charcoal/slate gray palette with selective warm accents (green moss, gold). Dramatic linear/strip LED lighting and rim lighting on dark backgrounds. Matte dark surfaces with rough stone/rock textures and subtle metallic accents. Pedestal/platform presentations with strong foreground/background separation. Very strong style override. Photorealistic with 3D-visualization quality.
- **Usage:** 1 used, 1 effective
- **Context:** style-code
- **Notes:** Best for: luxury product photography, perfume/cosmetics, high-end brand campaigns, dark moody editorial. Suggested --sw 100-150. Strip lighting creates strong drama. Works well with gold/chrome materials. May fight with bright/airy prompts. Excellent complement to perfume bottle sessions.

### Fujifilm Superia film simulation
- **Intended effect:** Fujifilm color profile
- **Actual effect:** Produces characteristic muted teal shadows with warm amber highlights. Combined with X100V for full Fujifilm color science.
- **Usage:** 7 used, 7 effective
- **Context:** Paired with camera model and --style raw
- **Notes:** Produces characteristic muted teal shadows with warm amber highlights. Combined with X100V for full Fujifilm color science.

### abstract soft focus light
- **Intended effect:** Lead concept for abstract blur composition
- **Actual effect:** Effective front-loaded concept that orients MJ toward abstract light-based output
- **Usage:** 5 used, 4 effective
- **Context:** abstract blur, ICM, front-loaded concept
- **Notes:** Used as lead concept in iters 4,6,7,8,9. Strong orientation keyword that prevents MJ from seeking subjects.

### bird's-eye perspective looking down at the plane
- **Intended effect:** restore ground plane perspective lost in iter 2
- **Actual effect:** successfully restored spatial grounding. Composition jumped +0.28 and spatial +0.37 vs iter 2.
- **Usage:** 1 used, 1 effective
- **Context:** when composition/spatial has been lost due to prefix style overrides
- **Notes:** Session 090060cf iter 3: critical recovery keyword that merged iter 1 composition with iter 2 material gains.

### burnt sienna
- **Intended effect:** Deep warm reddish-brown color tone
- **Actual effect:** Strongly anchored warm palette away from yellow drift. 3 iterations maintained deep warmth consistently.
- **Usage:** 3 used, 3 effective
- **Context:** warm color palette, desert scenes, golden hour
- **Notes:** Session 0ff95168: iters 2-4. Added after iter 1 had yellow drift. Immediately corrected color temperature.

### cinematic
- **Intended effect:** Cinematic visual quality and mood
- **Actual effect:** Consistently produced cinematic quality across all 4 iterations. Mood scores 0.88-0.95.
- **Usage:** 4 used, 4 effective
- **Context:** photorealistic scenes, surreal landscapes
- **Notes:** Session 0ff95168: all iters. V7 handles this mood word directly with strong results.

### cobalt blue
- **Intended effect:** Specific blue color anchoring
- **Actual effect:** Maintained consistent blue across 6 iterations. When weakened (iter 3), color drifted to green/teal.
- **Usage:** 6 used, 5 effective
- **Context:** color control, abstract forms
- **Notes:** Much more reliable than generic blue. Iter 3 reduced prominence and color drifted.

### compressed depth
- **Intended effect:** reduce 3D extrusion while keeping layered look
- **Actual effect:** reduces depth without flattening completely, preserves layered dimensionality
- **Usage:** 3 used, 3 effective
- **Context:** concentric/layered subjects
- **Notes:** Better than 'flat depth' or '2D appearance' which over-flatten.

### dark rectangular doorway
- **Intended effect:** Clean dark opening/doorway on object face
- **Actual effect:** Stayed clean and dark in all 4 images across all iterations — very reliable
- **Usage:** 4 used, 4 effective
- **Context:** architectural elements, surreal scenes
- **Notes:** Session 0ff95168: all iters. Clean dark rectangle maintained consistently. Position on face was unreliable but the doorway itself rendered well.

### film grain, 35mm
- **Intended effect:** Analog film texture
- **Actual effect:** Consistent organic grain across all iterations. No negative side effects.
- **Usage:** 7 used, 7 effective
- **Context:** Any photographic prompt with --style raw
- **Notes:** Consistent organic grain across all iterations. No negative side effects.

### fine art print
- **Intended effect:** graphic/flat style anchor
- **Actual effect:** strongest graphic quality anchor tested, reduces 3D rendering
- **Usage:** 3 used, 2 effective
- **Context:** abstract translucent forms
- **Notes:** Best style anchor. Used in 3C (0.83) and iteration 4 (0.73, degraded by other keywords).

### flat frontal view
- **Intended effect:** Enforce head-on centered perspective, prevent 3/4 angle
- **Actual effect:** Fixed perspective consistency from 2/4 frontal to 4/4 frontal
- **Usage:** 5 used, 5 effective
- **Context:** composition, perspective control, abstract forms
- **Notes:** Added in iter 2 after iter 1 had angled perspectives. Consistently effective across all subsequent iterations.

### from [color] at top to [color] at bottom
- **Intended effect:** Specify vertical gradient direction
- **Actual effect:** Best directional phrasing tested - produced most consistent top-to-bottom gradients
- **Usage:** 2 used, 2 effective
- **Context:** abstract gradients, color transitions
- **Notes:** Session 7345a6e1 iters 2,6. Most reliable directional phrasing for vertical gradients.

### gaussian blur
- **Intended effect:** Produce soft smooth blur edges
- **Actual effect:** Produced genuinely soft defocused output with smooth gradients
- **Usage:** 4 used, 3 effective
- **Context:** abstract blur, ICM photography
- **Notes:** Strong blur keyword. Iters 4,6,7,9. May trigger bokeh circle rendering in some images (iter 4 imgs 2-4). Best combined with out of focus photography.

### halftone dot pattern
- **Intended effect:** Produce visible halftone dot printing effect
- **Actual effect:** Consistently produced halftone dots across all 8 images in both iterations
- **Usage:** 2 used, 2 effective
- **Context:** graphic/print design, B&W
- **Notes:** Session c2f5cce9. Reliable across both iterations with different prompt structures.

### heavy coarse film grain
- **Intended effect:** Produce visible chunky analog film grain texture
- **Actual effect:** Grain scores 0.82-0.93 depending on sref and --raw combination. Best grain achieved with grain-only sref + --raw (0.91-0.93)
- **Usage:** 6 used, 6 effective
- **Context:** B&W film photography, Tri-X aesthetic, used with --style raw
- **Notes:** More effective than film stock names (Tri-X 400, ISO 3200) or visual descriptions (dense photographic noise). Coarse is key differentiator from generic film grain. Session 17bbeab3

### high contrast linework
- **Intended effect:** Light lines standing out against dark background
- **Actual effect:** Produced visible light-on-dark line structure
- **Usage:** 1 used, 1 effective
- **Context:** linework, contrast, illustration
- **Notes:** Session 39ce7668 iter 3. Key enabler for figure-ground separation.

### lavender
- **Intended effect:** cool pastel gradient color
- **Actual effect:** Clean smooth gradient color zone
- **Usage:** 1 used, 1 effective
- **Context:** gradient prompts
- **Notes:** Produced clean smooth gradient in iter 1. Cool color with no fabric associations.

### massive glowing paper cranes drifting through rain
- **Intended effect:** Surreal impossible element — dense flock
- **Actual effect:** Best surreal element tested. Dense flock creates visual impact. Culturally resonant with Tokyo setting. Color-harmonious with warm neon palette. Session peak: 0.919.
- **Usage:** 1 used, 1 effective
- **Context:** Photorealistic street scene with warm neon palette
- **Notes:** Best surreal element tested. Dense flock creates visual impact. Culturally resonant with Tokyo setting. Color-harmonious with warm neon palette. Session peak: 0.919.

### octane render
- **Intended effect:** 3D render aesthetic
- **Actual effect:** Clean, photorealistic 3D render look
- **Usage:** 0 used, 0 effective
- **Context:** Photorealistic 3D work
- **Notes:** Bootstrap - do not combine with other engines

### out of focus photography
- **Intended effect:** Produce genuinely defocused/blurred output
- **Actual effect:** Consistently produced defocused output when no subject keywords present
- **Usage:** 4 used, 4 effective
- **Context:** abstract blur, ICM photography
- **Notes:** Reliable blur keyword. Used in iters 2,4,5,7. Effective when subject keywords absent.

### pale teal
- **Intended effect:** cool pastel gradient color
- **Actual effect:** Clean smooth gradient color zone
- **Usage:** 1 used, 1 effective
- **Context:** gradient prompts
- **Notes:** Produced clean gradient in iter 3.

### perfect mirror finish
- **Intended effect:** Highly reflective mirror surface on object
- **Actual effect:** Produced correct environmental reflections showing surrounding landscape in mirror surface consistently across all 4 iterations
- **Usage:** 4 used, 4 effective
- **Context:** mirrored objects, reflective surfaces, surreal landscapes
- **Notes:** Session 0ff95168: all 4 iters. Mirror reflections showed desert landscape, mountains, sky correctly. Much more effective than generic reflective.

### powder blue
- **Intended effect:** cool pastel gradient color
- **Actual effect:** Clean smooth gradient color zone
- **Usage:** 2 used, 2 effective
- **Context:** gradient prompts
- **Notes:** Produced clean gradient in iters 1 and 3. Reliably cool.

### pure black canvas
- **Intended effect:** Establish dark ground for light-on-dark contrast
- **Actual effect:** Achieved true black background with high contrast light lines
- **Usage:** 1 used, 1 effective
- **Context:** contrast structure, linework on dark ground
- **Notes:** Session 39ce7668 iter 3. +0.17 batch avg improvement. Combined with against dark void.

### rose pink
- **Intended effect:** cool-warm pastel gradient color
- **Actual effect:** Clean smooth gradient color zone
- **Usage:** 1 used, 1 effective
- **Context:** gradient prompts with cool-dominant palette
- **Notes:** Produced clean gradient in cool-dominant palette (iter 1).

### screen printed ink on paper
- **Intended effect:** Achieve screen-printing material texture quality
- **Actual effect:** Strong matte ink texture with rough edges across all images
- **Usage:** 1 used, 1 effective
- **Context:** graphic/print design
- **Notes:** Session c2f5cce9. Better than raw matte ink on newsprint for material quality without triggering layout.

### seafoam green
- **Intended effect:** cool pastel gradient color
- **Actual effect:** Clean smooth gradient color zone
- **Usage:** 1 used, 1 effective
- **Context:** gradient prompts
- **Notes:** Produced clean gradient in iter 3.

### shot on Fujifilm X100V
- **Intended effect:** Fujifilm camera style anchor
- **Actual effect:** Acts as style anchor without rendering literal camera. Triggers Fujifilm color science. Maintained across all 7 iterations.
- **Usage:** 7 used, 7 effective
- **Context:** Surreal street photography with --style raw
- **Notes:** Acts as style anchor without rendering literal camera. Triggers Fujifilm color science. Maintained across all 7 iterations.

### smooth seamless color transition
- **Intended effect:** smooth gradient blending
- **Actual effect:** Effective gradient smoothness descriptor
- **Usage:** 5 used, 3 effective
- **Context:** gradient prompts combined with gaussian blur + out of focus photography
- **Notes:** Core phrase in gradient prompt structure. Effective across all cool palettes. Not enough to override fabric trigger from warm colors alone.

### soft purple
- **Intended effect:** cool pastel gradient color
- **Actual effect:** Clean smooth gradient color zone
- **Usage:** 1 used, 1 effective
- **Context:** gradient prompts
- **Notes:** Produced clean gradient in iter 5 aurora palette.

### squircle
- **Intended effect:** Rounded-square shape with soft corners
- **Actual effect:** Consistently produced rounded-square forms across multiple prompt structures
- **Usage:** 5 used, 4 effective
- **Context:** abstract forms, shape control
- **Notes:** MJ V7 directly understands squircle. 4/5 iterations maintained shape well. Iter 5 img 4 lost definition.

### subsurface scattering
- **Intended effect:** Internal light glow in translucent materials
- **Actual effect:** Produces convincing internal light diffusion in glass/wax/skin
- **Usage:** 0 used, 0 effective
- **Context:** Translucent or semi-transparent materials
- **Notes:** Bootstrap. See also counterproductive entry: in abstract/flat contexts, this keyword forces photorealistic 3D rendering.

### surreal
- **Intended effect:** Surreal dreamlike quality
- **Actual effect:** Contributed to surreal atmosphere in desert landscape scene. Mood scores consistently high.
- **Usage:** 4 used, 4 effective
- **Context:** dreamlike scenes, impossible architecture, surreal landscapes
- **Notes:** Session 0ff95168: all iters. Works well combined with cinematic and contemplative.

### volumetric lighting
- **Intended effect:** Subtle atmospheric light scattering
- **Actual effect:** Produces gentle haze and atmosphere
- **Usage:** 0 used, 0 effective
- **Context:** Atmospheric/moody scenes
- **Notes:** Bootstrap

### warm golden glow diffusing into cool teal
- **Intended effect:** Establish warm-to-cool color gradient
- **Actual effect:** Extremely reliable color palette descriptor across all iterations
- **Usage:** 6 used, 6 effective
- **Context:** color palette, warm-cool contrast, abstract
- **Notes:** Color palette remained consistent across all 9 iterations regardless of other prompt changes. Strong anchoring descriptor.

### warm ochre
- **Intended effect:** Earthy warm yellow-brown color tone
- **Actual effect:** Combined with burnt sienna, maintained monochromatic warm palette across iterations
- **Usage:** 3 used, 3 effective
- **Context:** warm color palette, desert scenes, golden hour
- **Notes:** Session 0ff95168: iters 2-4. Works well paired with burnt sienna for consistent warm desert palette.

---

## Good (37 keywords)

Reliable keywords with strong performance but may have contextual limitations.

### --sref 80385884
- **Intended effect:** Celadon porcelain luxury — mint/teal green with gold accents, fine china aesthetic, decorative luxury
- **Actual effect:** Consistent mint/celadon green + cream/white + gold accent palette across all subjects. Soft diffuse ethereal lighting. Everything rendered with porcelain/ceramic quality and gold trim. Semi-realistic with decorative/illustrative elements. Clean centered compositions. Very strong style override — transforms everything into porcelain-like objects.
- **Usage:** 1 used, 1 effective
- **Context:** style-code
- **Notes:** Best for: luxury lifestyle products, cosmetics with pastel branding, decorative objects. Niche but distinctive. Suggested --sw 75-100 (can overpower). Gold accents complement premium products. Not suitable for dark/dramatic shots. Trending on Style Explorer (Top Month Feb 2026).

### --weird 75
- **Intended effect:** Push output away from conventional photography
- **Actual effect:** Helped produce non-conventional abstract output in combination with subject removal
- **Usage:** 2 used, 2 effective
- **Context:** abstract blur, unconventional output
- **Notes:** Used in iters 2-3. Contributed to breaking away from conventional macro photography. Not needed once abstract keywords were strong enough (iters 4+).

### 23mm f/2
- **Intended effect:** Wide street perspective with bokeh
- **Actual effect:** Produces authentic wide-angle street perspective. Focal length acts as compositional anchor.
- **Usage:** 7 used, 6 effective
- **Context:** Street photography prompts
- **Notes:** Produces authentic wide-angle street perspective. Focal length acts as compositional anchor.

### Cinema 4D
- **Intended effect:** 3D render aesthetic
- **Actual effect:** Slightly more stylized 3D look than Octane
- **Usage:** 0 used, 0 effective
- **Context:** Motion graphics / stylized 3D
- **Notes:** Bootstrap

### atmospheric color transition
- **Intended effect:** Smooth gradient language
- **Actual effect:** Contributed to very smooth color blending when combined with sky metaphor
- **Usage:** 1 used, 1 effective
- **Context:** abstract gradients, sky-based approaches
- **Notes:** Session 7345a6e1 iter 4. Part of the sky metaphor approach that produced best smoothness.

### blob
- **Intended effect:** Amorphous organic form
- **Actual effect:** Surprisingly effective for abstract organic shapes
- **Usage:** 0 used, 0 effective
- **Context:** Abstract organic forms
- **Notes:** Bootstrap

### camera shake
- **Intended effect:** Produce directional motion blur
- **Actual effect:** Produced directional blur quality with motion streaks
- **Usage:** 1 used, 1 effective
- **Context:** abstract blur, ICM, directional motion
- **Notes:** Used in iter 2. Produced directional blur. Only tested once but effective.

### centered radial glow
- **Intended effect:** Keep warm glow centered in form rather than pooling at bottom
- **Actual effect:** Glow was more centered compared to iter 1 where it pooled at bottom in angled views
- **Usage:** 1 used, 1 effective
- **Context:** lighting, internal glow, abstract forms
- **Notes:** Iter 2: added to fix glow pooling at bottom. Worked alongside perspective fix.

### clear dusk sky
- **Intended effect:** Sky metaphor for smooth gradient
- **Actual effect:** Produced beautifully smooth gradient with correct muted teal hue
- **Usage:** 1 used, 1 effective
- **Context:** abstract gradients, smooth color transitions
- **Notes:** Session 7345a6e1 iter 4. Best smoothness of all iterations. Triggers warm sunset at bottom though.

### completely even soft illumination
- **Intended effect:** Reinforce flat lighting from all directions
- **Actual effect:** Supporting phrase that helped maintain flat lighting alongside flat shadowless studio lighting
- **Usage:** 6 used, 5 effective
- **Context:** B&W film photography, surreal portrait, paired with flat shadowless studio lighting
- **Notes:** Works as reinforcement for flat lighting intent. Alone may not be sufficient. Session 17bbeab3

### diagonal slash
- **Intended effect:** Bold diagonal geometric element
- **Actual effect:** Consistently produced strong diagonal forms
- **Usage:** 2 used, 2 effective
- **Context:** geometric graphic design
- **Notes:** Session c2f5cce9. Both plural and singular effective.

### dissolving luminous shapes
- **Intended effect:** Abstract formless light shapes
- **Actual effect:** Produced abstract light forms without recognizable subjects
- **Usage:** 4 used, 3 effective
- **Context:** abstract blur, ICM, subject-free
- **Notes:** Used in iters 4,6,8,9. Effective subject-free form descriptor. Sometimes produced static bokeh orbs rather than dissolving effect.

### dramatic lighting (in --no)
- **Intended effect:** Prevent MJ from adding dramatic directional lighting
- **Actual effect:** Reduced side lighting tendency when combined with other --no lighting terms. Lighting improved from ~0.78 to ~0.83
- **Usage:** 6 used, 4 effective
- **Context:** B&W film photography, used in --no list alongside side lighting and rim light
- **Notes:** Part of a trio: dramatic lighting + side lighting + rim light in --no. More effective together than individually. Does not fully eliminate directionality when sref carries dark contrasty lighting. Session 17bbeab3

### dreamy ethereal atmosphere
- **Intended effect:** Set mood for dreamy output
- **Actual effect:** Contributed to ethereal quality especially at --s 100
- **Usage:** 4 used, 3 effective
- **Context:** abstract blur, ICM, mood
- **Notes:** Used in iters 4,6,7,9. Mood influence visible especially combined with --s 100 --style raw.

### fine art abstract photography
- **Intended effect:** Style anchor for artistic abstract output
- **Actual effect:** Produced quality artistic output consistently
- **Usage:** 6 used, 5 effective
- **Context:** abstract blur, ICM, style anchor
- **Notes:** Used across most iterations. Reliable style anchor. Less dominant than fine art print but effective for abstract blur photography.

### flat shadowless studio lighting
- **Intended effect:** Produce flat even lighting without shadows or directionality
- **Actual effect:** Improved lighting flatness by +0.06 vs previous iterations. Lighting scores rose from ~0.78-0.80 to 0.83-0.85
- **Usage:** 6 used, 5 effective
- **Context:** B&W film photography, surreal portrait, used with --style raw and sref
- **Notes:** Most effective when combined with --no dramatic/side/rim lighting. Without --no, MJ still injects some directionality. Session 17bbeab3

### floating on pure black void
- **Intended effect:** Isolate elements on black background with breathing room
- **Actual effect:** Achieved genuine isolation in best candidate (comp 0.88)
- **Usage:** 1 used, 1 effective
- **Context:** element isolation, background control
- **Notes:** Session c2f5cce9. Significantly stronger than on solid black background. Works best with single dominant element.

### fluid
- **Intended effect:** Flowing form that remains solid
- **Actual effect:** Produces flowing shapes without liquid/wet appearance
- **Usage:** 0 used, 0 effective
- **Context:** Forms that should flow but not be wet
- **Notes:** Bootstrap

### gentle light diffusion (abstract blur context)
- **Intended effect:** Smooth gradient light transitions
- **Actual effect:** Contributed to smooth gradients between warm and cool zones
- **Usage:** 4 used, 3 effective
- **Context:** abstract blur, ICM, light quality
- **Notes:** Used in iters 4,6,8,9. Subtle but supportive keyword for smooth light transitions.

### gentle light diffusion (gradient context)
- **Intended effect:** soft light quality in gradients
- **Actual effect:** Contributes to smooth gradient transitions
- **Usage:** 5 used, 3 effective
- **Context:** gradient prompts
- **Notes:** Supportive gradient keyword. Part of the successful prompt structure.

### god rays
- **Intended effect:** Dramatic light shafts
- **Actual effect:** Produces heavy dramatic beams
- **Usage:** 0 used, 0 effective
- **Context:** Dramatic/religious/epic scenes
- **Notes:** Bootstrap - too intense for subtle use

### graphic quality
- **Intended effect:** push toward graphic/non-photorealistic rendering
- **Actual effect:** helps reduce photorealism when combined with fine art print
- **Usage:** 3 used, 2 effective
- **Context:** abstract forms needing non-photorealistic look
- **Notes:** Good mid-strength style keyword. Best when paired with 'fine art print'.

### hundreds of golden koi fish swimming through air
- **Intended effect:** Surreal impossible element — warm-colored multiples
- **Actual effect:** Color harmonizes with warm Fujifilm palette. Some batch inconsistency in fish count. Score: 0.896.
- **Usage:** 1 used, 1 effective
- **Context:** Photorealistic street scene
- **Notes:** Color harmonizes with warm Fujifilm palette. Some batch inconsistency in fish count. Score: 0.896.

### levitating
- **Intended effect:** Object floating above ground
- **Actual effect:** Achieved visible floating/levitation in 3/4 images when combined with suspended in air and visible gap/shadow descriptors
- **Usage:** 2 used, 1 effective
- **Context:** floating objects, surreal scenes, spatial relationships
- **Notes:** Session 0ff95168: iter 3-4. Much more effective than hovering slightly (0/4). Combined form achieved 3/4.

### massive whale silhouette swimming through fog
- **Intended effect:** Surreal impossible element at massive scale
- **Actual effect:** Rendered as semi-transparent fog shape above rooftops. Massive scale works well for surrealism within photorealism. Score: 0.897.
- **Usage:** 1 used, 1 effective
- **Context:** Photorealistic street scene
- **Notes:** Rendered as semi-transparent fog shape above rooftops. Massive scale works well for surrealism within photorealism. Score: 0.897.

### matte
- **Intended effect:** Non-shiny surface
- **Actual effect:** Works well for matte surfaces
- **Usage:** 0 used, 0 effective
- **Context:** Do not combine with glossy
- **Notes:** Bootstrap

### no subject
- **Intended effect:** Prevent MJ from adding subjects to abstract output
- **Actual effect:** Effective when combined with heavy --no list
- **Usage:** 4 used, 4 effective
- **Context:** abstract output, gradients, backgrounds
- **Notes:** Session 7345a6e1 iters 1-2,5-6. Consistent subject prevention across iterations.

### organic flowing
- **Intended effect:** Smooth organic curved forms
- **Actual effect:** Effectively counteracts geometric bias from other keywords
- **Usage:** 0 used, 0 effective
- **Context:** Abstract forms, sculptures
- **Notes:** Bootstrap

### orthographic perspective
- **Intended effect:** Remove perspective distortion, enforce flat view
- **Actual effect:** Works in combination with flat frontal view to lock perspective
- **Usage:** 1 used, 1 effective
- **Context:** composition, abstract forms
- **Notes:** Used in iter 2 alongside flat frontal view. Hard to isolate individual contribution.

### raw matte finish
- **Intended effect:** Flat non-glossy surface quality
- **Actual effect:** Effectively prevented glossy rendering across all images
- **Usage:** 1 used, 1 effective
- **Context:** material/surface quality
- **Notes:** Session c2f5cce9.

### retro-futuristic psychedelic
- **Intended effect:** set mood and era for the illustration style
- **Actual effect:** consistently contributed to mood dimension. One of the most stable keywords across iterations.
- **Usage:** 7 used, 5 effective
- **Context:** illustration and graphic design contexts
- **Notes:** Session 090060cf: mood scores consistently 0.65-0.79 across all iterations. Good mood keyword.

### rim light (in --no)
- **Intended effect:** Prevent rim/edge lighting on subject
- **Actual effect:** Contributed to reduced directional lighting alongside other --no lighting terms
- **Usage:** 6 used, 4 effective
- **Context:** B&W film photography, used in --no list with dramatic lighting and side lighting
- **Notes:** Part of lighting --no trio. Helps suppress MJ default dramatic portrait lighting tendency. Session 17bbeab3

### satin
- **Intended effect:** Middle ground between matte and glossy
- **Actual effect:** Produces subtle sheen, soft reflections
- **Usage:** 0 used, 0 effective
- **Context:** When both matte and glossy are desired
- **Notes:** Bootstrap

### seamless soft blend
- **Intended effect:** Smooth gradient transition
- **Actual effect:** Contributed to acceptable gradient in non-sabotaged images
- **Usage:** 1 used, 1 effective
- **Context:** abstract gradients, color transitions
- **Notes:** Session 7345a6e1 iter 6. Image 2 (without lens effects from defocused) showed good gradient.

### side lighting (in --no)
- **Intended effect:** Prevent side-lit dramatic look
- **Actual effect:** Contributed to reduced directional lighting alongside other --no lighting terms
- **Usage:** 6 used, 4 effective
- **Context:** B&W film photography, used in --no list with dramatic lighting and rim light
- **Notes:** Part of lighting --no trio. Effective when grain sref is not overriding with its own dark lighting aesthetic. Session 17bbeab3

### soft diffused light
- **Intended effect:** soft lighting quality without forcing photorealism
- **Actual effect:** achieves luminous quality while keeping graphic rendering
- **Usage:** 3 used, 2 effective
- **Context:** abstract translucent forms
- **Notes:** Visual-quality keyword (not physics). Works well in 3C (0.83).

### thin ink lines
- **Intended effect:** Fine delicate linework
- **Actual effect:** Produced finer lines with visible individual strokes
- **Usage:** 1 used, 1 effective
- **Context:** linework, illustration, ink drawing
- **Notes:** Session 39ce7668 iter 3. Better than brushstrokes for fine line quality.

---

## Moderate (8 keywords)

Mixed performance or context-dependent effectiveness.

### geometric abstraction
- **Intended effect:** Produce flat, graphic geometric forms
- **Actual effect:** Produced cleanest flattest results but lost luminous/translucent quality and color control
- **Usage:** 1 used, 1 effective
- **Context:** abstract forms, flat graphic output
- **Notes:** Iter 3: effective for flatness but too aggressive - lost translucency and color drifted. Needs material descriptors alongside.

### hairline-thin parallel lines
- **Intended effect:** achieve ultra-fine line precision matching op-art reference
- **Actual effect:** lines became finer than iter 1 but still not reference-level precision. Works directionally.
- **Usage:** 2 used, 1 effective
- **Context:** op-art / moire pattern contexts
- **Notes:** Session 090060cf: improved line quality in iters 2-3 but couldn't achieve reference-level fineness through keywords alone.

### liquid
- **Intended effect:** Flowing form
- **Actual effect:** Adds wetness and puddle-like qualities
- **Usage:** 0 used, 0 effective
- **Context:** Only when actual wetness is desired
- **Notes:** Bootstrap - implies wetness

### reflective
- **Intended effect:** Mirror-like surface
- **Actual effect:** Produces mild reflectivity, not full mirror
- **Usage:** 0 used, 0 effective
- **Context:** Not sufficient alone for chrome/mirror
- **Notes:** Bootstrap | Session 0ff95168 confirmed: perfect mirror finish is excellent in V7 for environmental reflections. reflective alone still insufficient.

### sculpture
- **Intended effect:** Three-dimensional art form
- **Actual effect:** Biases toward geometric/angular forms
- **Usage:** 0 used, 0 effective
- **Context:** Prepend "organic" for non-geometric results
- **Notes:** Bootstrap

### torn paper edge texture
- **Intended effect:** Ragged/torn edge quality on graphic elements
- **Actual effect:** Created literal torn paper page framing instead of just edge quality
- **Usage:** 2 used, 1 effective
- **Context:** graphic/print design, texture
- **Notes:** Session c2f5cce9. Works as texture in some images but creates unwanted frame in others. Consider distressed edges instead.

### translucent
- **Intended effect:** See-through material with internal light
- **Actual effect:** Produces flat transparency without depth
- **Usage:** 0 used, 0 effective
- **Context:** Materials
- **Notes:** Bootstrap - better when combined with SSS

### vertical
- **Intended effect:** Vertical gradient orientation
- **Actual effect:** Partially effective for direction but can trigger vertical line/stripe patterns
- **Usage:** 1 used, 0 effective
- **Context:** abstract gradients
- **Notes:** Session 7345a6e1 iter 3. 3/4 images improved direction but 1/4 showed vertical stripe pattern. Standalone "vertical" is risky.

---

## Poor (12 keywords)

Low effectiveness or minimal impact on output.

### astronaut floating weightlessly
- **Intended effect:** Surreal impossible element — human-scale single object
- **Actual effect:** Too subtle at human scale. Single object less impactful than multiples (cranes, koi) or massive scale (whale). Score: 0.871.
- **Usage:** 1 used, 0 effective
- **Context:** Photorealistic street scene
- **Notes:** Too subtle at human scale. Single object less impactful than multiples (cranes, koi) or massive scale (whale). Score: 0.871.

### contemplative
- **Intended effect:** add contemplative mood to abstract image
- **Actual effect:** minimal mood impact, may contribute to increased 3D rendering when combined with artist references
- **Usage:** 1 used, 0 effective
- **Context:** abstract translucent forms
- **Notes:** Used in iteration 4. Unclear individual effect, batch regressed 0.83->0.73.

### digital illustration
- **Intended effect:** Shift rendering from photorealistic to illustrated/graphic style
- **Actual effect:** No visible effect when material descriptors (glass, subsurface scattering) are present
- **Usage:** 1 used, 0 effective
- **Context:** style control, abstract forms with material descriptors
- **Notes:** Iter 2: replaced octane render with digital illustration, no visible style shift. Material descriptors dominate.

### double exposure
- **Intended effect:** Surreal layered imagery
- **Actual effect:** Degrades photorealistic base, shifts to artistic treatment. Conflicts with --style raw. Avoid when photorealism is desired.
- **Usage:** 1 used, 0 effective
- **Context:** Photorealistic street photography with --style raw
- **Notes:** Degrades photorealistic base, shifts to artistic treatment. Conflicts with --style raw. Avoid when photorealism is desired.

### extreme motion blur
- **Intended effect:** Strong motion blur effect
- **Actual effect:** Largely ignored when flower subject present. Only 1/4 images achieved genuine dissolution.
- **Usage:** 1 used, 0 effective
- **Context:** ICM photography, motion effects
- **Notes:** Iter 5: extreme qualifier did not strengthen motion blur when subject keywords present.

### fine delicate brushstrokes
- **Intended effect:** Thin fine lines
- **Actual effect:** Thick painterly marks, not fine lines
- **Usage:** 1 used, 0 effective
- **Context:** linework style
- **Notes:** Session 39ce7668 iter 1. MJ interprets brushstrokes as thick marks.

### giant bioluminescent jellyfish
- **Intended effect:** Surreal impossible element — cool bioluminescent
- **Actual effect:** Too subtle, absorbed into teal fog. Cool bioluminescence clashed with warm scene palette. Score: 0.871.
- **Usage:** 1 used, 0 effective
- **Context:** Photorealistic street scene with warm palette
- **Notes:** Too subtle, absorbed into teal fog. Cool bioluminescence clashed with warm scene palette. Score: 0.871.

### hovering slightly above
- **Intended effect:** Subtle floating above ground
- **Actual effect:** Completely ignored by MJ V7 — all 4 images showed object grounded on surface
- **Usage:** 1 used, 0 effective
- **Context:** floating objects, spatial relationships
- **Notes:** Session 0ff95168: iter 2. 0/4 floating. Too subtle for MJ to act on.

### long exposure
- **Intended effect:** Produce long exposure light streaks
- **Actual effect:** No visible effect in any image
- **Usage:** 1 used, 0 effective
- **Context:** ICM photography, light trails
- **Notes:** Used in iter 1. No light streaks produced. Technical camera term ignored.

### motion blur
- **Intended effect:** Produce motion blur effect
- **Actual effect:** Completely ignored when subject keywords present; MJ rendered sharp subjects
- **Usage:** 1 used, 0 effective
- **Context:** ICM photography, abstract blur
- **Notes:** Used in iter 1 as motion-blurred. Completely ignored. Subject keywords dominated.

### op-art moire
- **Intended effect:** generate optical illusion interference patterns in linework
- **Actual effect:** MJ understands the general concept but cannot produce true moire interference. Lines warp but don't create moire optical effects.
- **Usage:** 3 used, 0 effective
- **Context:** fine geometric pattern generation
- **Notes:** Session 090060cf: attempted across all 7 iterations. MJ warps lines around sphere but never achieves actual moire interference.

### punk zine aesthetic
- **Intended effect:** Printed punk feel and texture quality
- **Actual effect:** Triggered collaged layout/composition behavior instead of just texture
- **Usage:** 1 used, 0 effective
- **Context:** graphic/print design
- **Notes:** Session c2f5cce9. Caused all 4 images to arrange elements in composed layouts with borders.

---

## Counterproductive (22 keywords)

Keywords that produce unwanted effects or conflict with intended output.

### James Turrell inspired
- **Intended effect:** contemplative luminous mood without gallery framing
- **Actual effect:** triggers physical art object rendering even without gallery context words
- **Usage:** 2 used, 0 effective
- **Context:** abstract translucent forms
- **Notes:** Used in 3B with gallery trap (0.77) and iteration 4 without gallery words (0.73). Both times increased 3D/physical quality.

### blush pink
- **Intended effect:** warm pastel gradient color
- **Actual effect:** Triggers silk/satin fabric rendering in gradient context
- **Usage:** 1 used, 0 effective
- **Context:** gradient prompts
- **Notes:** Part of warm palette that triggered fabric in iter 2.

### buildings melting slightly at edges
- **Intended effect:** Surreal architecture distortion
- **Actual effect:** MJ V7 with --style raw will not produce architecture distortion. --style raw anchors photorealistic rendering too strongly for structural impossibilities.
- **Usage:** 1 used, 0 effective
- **Context:** Photorealistic street photography with --style raw
- **Notes:** MJ V7 with --style raw will not produce architecture distortion. --style raw anchors photorealistic rendering too strongly for structural impossibilities.

### champagne
- **Intended effect:** warm pastel gradient color
- **Actual effect:** Triggers silk/satin fabric rendering in gradient context
- **Usage:** 2 used, 0 effective
- **Context:** gradient prompts
- **Notes:** Used in 2 warm palettes (iters 2, 4), both triggered fabric. Champagne is a classic fabric/wedding descriptor.

### color field painting
- **Intended effect:** art movement style reference for luminous color work
- **Actual effect:** combined with gallery context, triggers photo-of-painting rendering
- **Usage:** 1 used, 0 effective
- **Context:** abstract color forms
- **Notes:** Art movement label. Triggered gallery framing in 3B.

### color swatch
- **Intended effect:** Clean color field reference
- **Actual effect:** Triggered watercolor paint sample rendering on paper with visible brush edges
- **Usage:** 1 used, 0 effective
- **Context:** abstract gradients, color fields
- **Notes:** Session 7345a6e1 iter 5. Total failure: all 4 images showed painted swatches.

### coral
- **Intended effect:** warm pastel gradient color
- **Actual effect:** Triggers silk/satin fabric rendering in gradient context
- **Usage:** 1 used, 0 effective
- **Context:** gradient prompts
- **Notes:** Part of warm palette that triggered fabric. Coral strongly associated with silk/satin textile training data.

### defocused
- **Intended effect:** Smooth softness for gradients
- **Actual effect:** Triggered lens glow/aurora/flare effects in 3 of 4 images
- **Usage:** 1 used, 0 effective
- **Context:** abstract gradients
- **Notes:** Session 7345a6e1 iter 6. Sabotaged 3/4 images. Use smooth/seamless instead for gradients.

### dissolving flower petals
- **Intended effect:** Abstract blurred floral forms
- **Actual effect:** Re-anchored MJ in conventional sharp botanical photography. 3/4 images had sharp petals despite blur keywords.
- **Usage:** 1 used, 0 effective
- **Context:** ICM photography, abstract blur with organic hint
- **Notes:** Iter 5: Subject keyword dominated blur keywords. Flower/petal acts as strong photorealism anchor.

### dusty rose
- **Intended effect:** warm pastel gradient color
- **Actual effect:** Triggers silk/satin fabric rendering in gradient context when dominant
- **Usage:** 1 used, 0 effective
- **Context:** gradient prompts with warm-dominant palette
- **Notes:** Triggered fabric in warm-dominant palette (iter 4). But dusty pink worked in cool-dominant palette (iter 5).

### flat vector illustration
- **Intended effect:** force flat illustrative rendering instead of 3D
- **Actual effect:** achieved flat rendering and fine lines but destroyed composition and spatial grounding — sphere became isolated floating graphic
- **Usage:** 1 used, 0 effective
- **Context:** when paired with sphere-on-plane compositions, prefix overrides spatial context
- **Notes:** Session 090060cf iter 2: material +0.20 but composition -0.30, spatial -0.30. Net score regressed -0.04.

### gallery artwork
- **Intended effect:** fine art presentation context
- **Actual effect:** triggers meta-rendering: photo of painting on gallery wall
- **Usage:** 1 used, 0 effective
- **Context:** any art-style prompt
- **Notes:** Gallery framing trap. Discovered in 3B.

### hint of dissolving botanical silhouettes
- **Intended effect:** Subtle organic forms within abstract blur
- **Actual effect:** Produced identifiable sharp stems and leaves. Blur scores dropped from 0.90-0.95 to 0.45-0.55.
- **Usage:** 1 used, 0 effective
- **Context:** ICM photography, organic form in abstract
- **Notes:** Iter 7: Even hint/faint qualifiers cannot override MJ subject rendering. Any botanical keyword dominates.

### impossible reflections in puddles showing a different sky
- **Intended effect:** Surreal puddle reflections
- **Actual effect:** MJ V7 completely ignores this. Reflections always render realistically. Abstract impossible effects do not work in --style raw.
- **Usage:** 1 used, 0 effective
- **Context:** Photorealistic street photography with --style raw
- **Notes:** MJ V7 completely ignores this. Reflections always render realistically. Abstract impossible effects do not work in --style raw.

### intentional camera movement
- **Intended effect:** Produce ICM photography effect
- **Actual effect:** Completely ignored by MJ V7
- **Usage:** 1 used, 0 effective
- **Context:** ICM photography
- **Notes:** Used in iter 1. Not understood by MJ at all. Technical photography terms are ineffective.

### peach
- **Intended effect:** warm pastel gradient color
- **Actual effect:** Triggers silk/satin fabric rendering in gradient context
- **Usage:** 1 used, 0 effective
- **Context:** gradient prompts
- **Notes:** Part of warm palette that triggered fabric. Peach strongly associated with silk/satin textile training data.

### polished smooth surface
- **Intended effect:** clean glass surface quality
- **Actual effect:** anchors photorealistic material rendering
- **Usage:** 2 used, 0 effective
- **Context:** abstract translucent forms
- **Notes:** Physics keyword. Removed in 3C, contributes to photorealism ceiling.

### soft gold
- **Intended effect:** warm pastel gradient color
- **Actual effect:** Triggers silk/satin fabric rendering in gradient context
- **Usage:** 2 used, 0 effective
- **Context:** gradient prompts
- **Notes:** Used in 2 warm palettes (iters 2, 4), both triggered fabric. Gold strongly associated with luxe fabric.

### subsurface scattering (abstract context)
- **Intended effect:** translucent glass material quality
- **Actual effect:** forces photorealistic 3D rendering, overrides flat/graphic style keywords
- **Usage:** 3 used, 0 effective
- **Context:** abstract translucent forms
- **Notes:** Physics-simulation keyword. Tested in iterations 1-2, removed in 3C which jumped from 0.77 to 0.83. See also excellent entry: works well for actual translucent materials like glass/wax/skin.

### swirling water vortex
- **Intended effect:** Artistic water swirl pattern
- **Actual effect:** Triggered 3D fluid simulation rendering, thick ribbon-like swirls instead of fine linework
- **Usage:** 1 used, 0 effective
- **Context:** linework/illustration style
- **Notes:** Session 39ce7668. Overrides oil painting style anchor.

### warm ivory
- **Intended effect:** warm pastel gradient color
- **Actual effect:** Triggers silk/satin fabric rendering in gradient context
- **Usage:** 1 used, 0 effective
- **Context:** gradient prompts
- **Notes:** Part of warm palette that triggered fabric in iter 4.

### wash
- **Intended effect:** Smooth color application
- **Actual effect:** Triggered watercolor technique rendering
- **Usage:** 1 used, 0 effective
- **Context:** abstract gradients, color fields
- **Notes:** Session 7345a6e1 iter 5. Combined with color swatch, produced paint-on-paper.
