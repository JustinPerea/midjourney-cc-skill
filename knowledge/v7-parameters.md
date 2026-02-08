# Midjourney V7 Parameter Reference

*Last Updated: February 2026*

## Version Information

- **V7 Release:** April 3, 2025
- **Default Since:** June 17, 2025
- **Video Model (V1):** June 2025

---

## What's Different in V7

### Improved Capabilities
- **Better prompt understanding** - Abstract concepts like "cinematic melancholy" or "ethereal nostalgia" work directly
- **Smarter word weighting** - Beginning of prompt is weighted more heavily
- **Simpler prompts work better** - V7 doesn't need the complexity V6 required
- **Enhanced personalization** - On by default after 5-minute unlock process

### Breaking Changes
- **`--cref` is DEPRECATED** - Character reference no longer works
- **Use `--oref` instead** - New "Omni Reference" system for characters/objects
- **Style reference codes** - Old sref codes (pre-June 2025) need `--sv 4`
- **Multi-Prompts (`::`) NOT COMPATIBLE with V7** - Separator syntax doesn't work in V7

---

## Prompt Structure

### Key Insight: Simple Prompts Work Best

Midjourney documentation emphasizes: **"Short, simple prompts work best."** V7 has much better natural language understanding than previous versions.

### Recommended Order (Most to Least Important)
```
[Subject] > [Environment] > [Style/Mood] > [Lighting] > [Composition] > [Parameters]
```

Words at the beginning have more influence. Front-load your most important elements.

### Seven Key Prompt Areas (from MJ docs)
1. **Subject** - The main focus of your image
2. **Medium** - Art style or technique (oil painting, photograph, 3D render)
3. **Environment** - Where the scene takes place
4. **Lighting** - How the scene is lit
5. **Color** - Color palette and mood
6. **Mood** - Emotional tone
7. **Composition** - How elements are arranged

---

## Core Parameters

### Aspect Ratio (`--ar`)

| Use Case | Ratio | Parameter |
|----------|-------|-----------|
| Square (social, profile) | 1:1 | `--ar 1:1` |
| Standard photo | 3:2 | `--ar 3:2` |
| Widescreen | 16:9 | `--ar 16:9` |
| Ultrawide/cinematic | 21:9 | `--ar 21:9` |
| Portrait/mobile | 9:16 | `--ar 9:16` |
| Poster | 2:3 | `--ar 2:3` |
| Panoramic | 32:9 | `--ar 32:9` |

### Stylize (`--s` or `--stylize`)

Controls artistic interpretation vs prompt adherence. Range: 0-1000, Default: 100

| Value | Effect |
|-------|--------|
| 0-50 | Maximum prompt adherence, minimal artistic liberty |
| 50-150 | Balanced (good for specific requirements) |
| 150-300 | Enhanced aesthetics (ideal for most creative work) |
| 300-600 | Strong artistic interpretation |
| 600-1000 | Maximum artistic freedom, prompt becomes suggestion |

**Recommendation:** For commercial/professional work, stay between **100-250**.

### Chaos (`--c` or `--chaos`)

Controls variation between the 4 generated images. Range: 0-100, Default: 0

| Value | Effect |
|-------|--------|
| 0 | All 4 images are similar |
| 20-40 | Moderate variety |
| 50-100 | High variety, exploratory |

### Weird (`--weird`)

Adds unusual/experimental aesthetics. Range: 0-3000, Default: 0

**Note:** Weird is experimental and **not fully compatible with seeds** - results may vary even with same seed.

| Value | Effect |
|-------|--------|
| 0 | Standard output |
| 50-150 | Subtle surrealism (good for artistic work) |
| 200-500 | Noticeably unusual |
| 500+ | Very experimental, unpredictable |

### Quality (`--q` or `--quality`)

**V7 values are different from previous versions!**

| Value | GPU Time | Effect |
|-------|----------|--------|
| 1 | 1x | Default, standard quality |
| 2 | 2x | More detail and textures |
| 4 | 4x | Maximum detail (not compatible with --oref) |

**Note:** Quality only affects the first set of 4 images. It doesn't affect variations, inpainting/outpainting, or upscales. For saving GPU time, use Draft Mode instead.

### Style Raw (`--style raw` or `--raw`)

In Standard Mode, Midjourney adds creative "auto-pilot" interpretation. Raw Mode turns this off.

**With simple prompts:** More realistic, photo-like images
**With detailed prompts:** Precise control over final look

Use for:
- Cleaner, more controllable outputs
- Photorealistic work
- When you need precise control over aesthetics
- Stylistically detailed prompts where you want exact interpretation

### Draft Mode (`--draft`)

- 10x faster generation
- Half the GPU cost
- Slightly lower quality
- **Perfect for exploration/iteration before final renders**

**Workflow:**
- Activate via the Draft Mode button in the Imagine bar, or add `--draft` to any prompt
- When you like a draft, use **Enhance** button to regenerate at full quality (same composition, standard GPU time)
- Draft images can also be directly upscaled without enhancing first
- Works with Conversational Mode (AI writes prompts for you via text or voice)

### Tile (`--tile`)

Creates seamless, tileable patterns. Essential for:
- Website backgrounds
- Textures
- Animated loops

### Seed (`--seed`)

Range: 0 to 4294967295. Same seed + same prompt = same result.

**Use for:**
- Iterating on a specific composition
- Creating variations with small prompt changes
- Testing how prompt changes affect output

**Important Limitations:**
- **Can't save styles** - Seeds only influence initial noise layout, not style/character. Use `--sref`, `--oref`, or `--p` for consistency
- **Not always predictable** - Seeds may behave unexpectedly across different sessions. If you take a break and come back, results may differ
- **Not always consistent** - Prompt, model version, and parameter changes can override seed effects
- **Don't use with Turbo Mode** - Turbo focuses on speed; seed locking is unreliable

### Repeat (`--repeat` or `--r`)

Generate multiple image sets from a single prompt. Range: 2-40 (plan-dependent).

| Plan | Max --repeat |
|------|-------------|
| Basic | 2 |
| Standard | 4 |
| Pro / Mega | 40 |

**Use for:** Quickly generating many variations to pick from. Each repeat generates a full 4-image grid. Only works in Fast and Turbo modes.

### Negative Prompt (`--no`)

Excludes elements from generation:
```
--no text, words, letters, watermark, signature
--no clutter, busy background
--no people, faces
```

**⚠️ Moderation Warning:** MJ's moderation reads each word in `--no` independently. For example, `--no modern clothing` is interpreted as "no modern" AND "no clothing" — which can trigger content warnings. Instead of using `--no` to exclude clothing styles, include the specific clothing type you DO want in your prompt.

---

## Reference Systems

### Quick Reference: When to Use Each Type

| Type | Parameter | What It Does | Use When |
|------|-----------|--------------|----------|
| **Image Prompt** | (upload) | Influences content, composition, colors | You want similar subject/layout |
| **Style Reference** | `--sref` | Transfers visual style/vibe only | You want the aesthetic, not content |
| **Omni Reference** | `--oref` | Puts specific person/object into image | You need character/object consistency |

### Image Prompts (Content Reference)

Influences **content, composition, and colors** of your output. Upload an image and use it as inspiration.

**Image Weight (`--iw`):** 0-3, default 1

| Value | Effect |
|-------|--------|
| 0-0.5 | Subtle influence |
| 1 | Balanced (default) |
| 1.5-2 | Strong influence |
| 2-3 | Dominant influence |

**Key insight:** Your text prompt should describe the **final image you want**, NOT instructions for changing the reference. MJ uses the image as inspiration, not as a source to modify.

**Three ways to use:**
1. Single image + text prompt
2. Multiple images without text (blends them)
3. Multiple images + text (combined guidance)

### Style Reference (`--sref`)

Transfers visual style from a reference image.

**Basic:**
```
/imagine a mountain landscape --sref https://your-image-url.jpg
```

**With weight:**
```
/imagine a mountain landscape --sref https://url.jpg --sw 300
```

**Multiple references:**
```
/imagine a portrait --sref https://url1.jpg::2 https://url2.jpg::1 --sw 250
```

**Style Weight (`--sw`):** 0-1000, default 100. In V7, `--sw` has more impact with sref codes than with images.

| Value | Effect |
|-------|--------|
| 0-50 | Subtle influence |
| 100 | Balanced |
| 200-400 | Strong style transfer |
| 500-1000 | Dominant style influence |

**Incompatibilities:** `--sw` is not compatible with Moodboards.

**Version:**
- `--sv 6` (default) - Smarter style understanding
- `--sv 4` - Required for sref codes created before June 2025
- **Incompatibility:** `--sv` is not compatible with Moodboards.

**Style Codes:** Use `--sref <numeric_code>` to apply a style from MJ's internal library instead of an image. You cannot create a style code from an uploaded image — codes come from the Style Explorer, Style Creator, or `--sref random`. See `rules/core-prompt-construction.md` for full style code documentation.

**Random styles:**
```
/imagine a forest scene --sref random
```

**Behavior notes:**
- Rerun/reroll and variations preserve the style code from the original prompt
- `--sref random` with permutations or `--repeat` gives each image a different code

### Omni Reference (`--oref`) -- REPLACES --cref

Universal reference for characters, objects, vehicles, creatures. **V7 only.**

**Basic:**
```
/imagine a person walking through Tokyo --oref https://character-image.jpg
```

**With weight (`--ow`):** 1-1000, default 100

| Value | Effect |
|-------|--------|
| 25-50 | Subtle influence (style transfer) |
| 100 | Balanced preservation |
| 200-400 | Strong feature preservation |
| 400-1000 | Maximum fidelity to reference |

**Best practice:** Keep `--ow` below 400 unless using very high stylize values.

**Best Practices:**
- Combine with clear text prompt - text is just as important
- To change style: mention desired style at **START and END** of prompt
- Example: "**Illustration** of a young woman with short gray hair **drawn by a comic book artist**"
- Lower `--ow` when using style references
- Intricate details (freckles, logos) may not match perfectly

**Limitations (IMPORTANT):**
- Costs 2x GPU time
- NOT compatible with: Draft Mode, Fast Mode, inpainting, outpainting, `--q 4`
- Results NOT compatible with: Vary Region, Pan, Zoom Out (use Editor instead)
- Only ONE image can be used as Omni Reference per prompt

---

## Video/Animation

### Overview

V1 Video Model (June 2025) enables image-to-video animation. This is NOT text-to-video -- you animate existing images.

### Video Parameters

| Parameter | Effect |
|-----------|--------|
| `--motion low` | Subtle ambient movement |
| `--motion high` | Dynamic movement |
| `--loop` | Seamless loop (end matches start) |

### Duration

- Base: 5 seconds
- Extendable in ~4 second increments
- Maximum: 21 seconds

### Motion Prompting (Manual Mode)

```
Camera slowly pans left, clouds drift across sky, gentle ambient movement
```

```
Subtle rotation, internal particles gently swirling, smooth morphing
```

### Technical Limitations

- **Native resolution: 480p** (upscaling required for production)
- **Frame rate:** ~24 fps
- **Export formats:** MP4, GIF
- **Cost:** ~8x GPU time of image generation

### What Animates Well

Good: Abstract patterns, atmospheric scenes (clouds, fog, water), flowing elements (hair, fabric, smoke), nature scenes

Bad: Detailed human faces (artifacts), complex mechanical movement, text or UI elements

### Animation Workflow

1. Generate base image with `--tile` for seamless edges
2. Evaluate animation suitability
3. Animate with low motion + loop for hero backgrounds
4. Upscale to 1080p+ using Topaz, TensorPix, or DaVinci

---

## Effective Keywords

### Lighting
Volumetric lighting, rim light, backlighting, golden hour, blue hour, dramatic shadows, soft diffused light, harsh directional light, bioluminescent, neon glow, ambient occlusion, subsurface scattering, caustics

### Atmosphere/Mood
Ethereal, dreamy, nostalgic, melancholic, cinematic, epic, intimate, serene, mysterious, ominous, hopeful, whimsical

### Quality/Style
Hyperrealistic, photorealistic, stylized, octane render, redshift render, Cinema 4D, Houdini, professional photography, editorial, commercial, 8K render, ray traced

### Camera/Composition
Wide shot, extreme close-up, bird's eye view, shallow depth of field, bokeh, tilt-shift, rule of thirds, centered composition, macro, telephoto compression

### Materials (for 3D aesthetics)
Translucent, refractive, glossy, matte, subsurface scattering, volumetric, glass, chrome, ceramic, fabric

---

## Creating Text-Friendly Compositions

Midjourney doesn't understand "leave space for text" literally. Describe empty areas physically:

**Effective:**
```
Subject positioned at far right, large empty area on left side
```

```
Extreme wide shot with focal point in lower right corner
```

```
Vast landscape with smooth gradient sky occupying upper two-thirds
```

**The invisible area technique:**
```
A photo with a huge invisible empty center area while the subject occupies the edges
```

---

## Common Issues & Fixes

| Problem | Solution |
|---------|----------|
| Too busy/cluttered | Add `--style raw`, lower `--s`, use `--no clutter, busy` |
| Not following prompt | Front-load key words, simplify prompt, lower `--s` |
| Unwanted text appearing | Add `--no text, words, letters, writing` |
| Too generic/stock-photo feel | Increase `--weird` slightly (50-150), add specific details |
| Subject in wrong position | Explicitly state position: "subject at far left edge" |
| Inconsistent style | Use `--sref` with consistent `--sw` value |
| Animation too jittery | Use `--motion low`, choose calmer source images |
| Old sref codes not working | Add `--sv 4` for pre-June 2025 codes |
| --cref not working | Switch to `--oref` (V7 change) |

---

## Text Generation

Use double quotation marks to render words in your images. Available in V6+.

**Syntax:**
```
a neon sign that says "OPEN" in a dark alley
a cartoon manual with the words "read the docs" in big text on the pages
```

**Best practices:**
- Use **double quotes only** — single quotes and apostrophes don't work
- Shorter words/phrases are more reliable than long sentences
- Include context words like "with the words", "text", "written", "sign that says"
- Works best with standard Latin alphabet (English letters)
- If text is garbled: try `--style raw`, lower `--s`, or use the Editor/Vary Region to fix

**Bad:** `a logo with the company name Boing` (no quotes)
**Good:** `a pastel watercolor landscape with "imagine" written in the clouds`

---

## Permutations

Generate multiple prompt variations from a single prompt using curly braces `{}`.

**Syntax:**
```
a {red, green, yellow} bird        → generates 3 separate jobs
a cat in a {forest, city, desert}  → generates 3 separate jobs
a landscape --ar {1:1, 16:9, 2:3}  → tests 3 aspect ratios
```

**Works on any part of the prompt**, including parameters. Each permutation runs as a separate job consuming its own GPU time.

**Plan limits:**
| Plan | Max permutations per prompt |
|------|----------------------------|
| Basic | 4 |
| Standard | 10 |
| Pro / Mega | 40 |

**Important:** Only works in Fast and Turbo modes. Not available in Relax mode.

**Use cases for prompt engineering:**
- A/B test keywords: `a portrait, {volumetric lighting, rim light, soft diffused light}`
- Compare styles: `a cat, {oil painting, watercolor, pencil sketch} style`
- Test parameters: `a landscape --s {50, 150, 300}`

---

## Upscalers

V7 images start at 1024x1024 pixels (at 1:1). Upscaling doubles the dimensions.

### Subtle vs Creative

| Upscaler | What it does | Use when |
|----------|-------------|----------|
| **Subtle** | Doubles size, preserves original look as closely as possible | Final output is close to what you want |
| **Creative** | Doubles size, may add new details and make small changes | You want refinement or want to fix minor issues (hands, faces) |

**Pro tip:** Creative upscale can sometimes correct small issues like awkward hands or odd expressions. You can re-run Creative upscale multiple times — each produces a slightly different result.

### Resolution by Aspect Ratio

| Aspect Ratio | Initial | After Upscale |
|-------------|---------|---------------|
| 1:1 | 1024 x 1024 | 2048 x 2048 |
| 4:3 | 1232 x 928 | 2464 x 1856 |
| 2:3 | 896 x 1344 | 1792 x 2688 |
| 16:9 | 1456 x 816 | 2912 x 1632 |

**GPU cost:** Upscaling can take up to 2x the GPU minutes of the initial generation.

**For larger sizes:** Use third-party upscalers (Topaz, TensorPix, DaVinci Resolve) after MJ upscale.

---

## Pan & Zoom Out

### Pan

Expand the canvas in any direction to reveal new content beyond the original frame.

**Use when:**
- Composition is good but you need more space on one side (e.g., for text overlay)
- You want to extend a scene without regenerating

**Note:** Not compatible with images made using `--oref`. Use the Editor instead.

### Zoom Out

Shrink the original image and fill in new surrounding content, creating a wider view of the scene.

**Use when:**
- Image is too tightly cropped
- You want to reveal the environment around an existing subject
- Building out a composition that started as a close-up

**Note:** Not compatible with images made using `--oref`. Use the Editor instead.

---

## Artistic Mediums (from Official Docs)

These medium keywords reliably produce distinct styles when used with V7. Tested format: `[medium] style [subject]`.

### Print & Traditional
Block Print, Ballpoint Pen Sketch, Cyanotype, Risograph, Ukiyo-e, Pencil Sketch, Watercolor, Pixel Art, Cross Stitch, Acrylic Pour, Cut Paper, Pressed Flowers, Oil Painting

### Specialty
Blacklight Painting, Paint-by-Numbers, Graffiti

### Color Modes
Millennial Pink, Acid Green, Sepia, Two Toned, Pastel, Duotone, Ebony, Neutral, CMYK, Indigo, Iridescent, Neon, Grayscale

### Time Periods as Style
Adding a decade (e.g., "1920s", "1970s", "1990s") to your prompt shifts the entire visual style to match that era's aesthetic — lighting, color grading, composition, and subject presentation all adjust.

---



```
--ar 16:9          Aspect ratio
--s 200            Stylize (0-1000)
--c 20             Chaos (0-100)
--weird 100        Unusual aesthetics (0-3000)
--style raw        Remove default beautification
--draft            Fast/cheap iteration mode (10x faster, half cost)
--q 2              Quality level (1=default, 2=2x GPU, 4=4x GPU)
--no [items]       Exclude elements
--seed 12345       Reproducible results (0-4294967295)
--tile             Seamless/tileable pattern
--p                Apply personalization (your style preferences)
--sref [url]       Style reference
--sw 300           Style weight (0-1000)
--sv 4             Style version (for old codes)
--oref [url]       Omni reference (characters/objects)
--ow 200           Omni weight (0-1000)
--iw 1.5           Image prompt weight (0-3)
--repeat 4         Generate N image sets from one prompt (--r)
--loop             Seamless video loop
--motion low       Subtle animation
"text here"        Render text in image (use double quotes)
{opt1, opt2}       Permutations (generates separate jobs)
```

---

## Parameter Combinations

### Maximum Control (Precise Requirements)
```
--s 50-100 --style raw --no [exclusions]
```

### Balanced Creative (Most Use Cases)
```
--s 150-250 --style raw
```

### Artistic Freedom (Exploratory)
```
--s 300-500 --weird 50-150
```

### Fast Iteration (Exploration Phase)
```
--draft --s 150
```

### Animation-Ready
```
--tile --s 150 --style raw
```

### Consistent Series (Using References)
```
--sref [url] --sw 200-300
```

---

## Variations (Iteration Actions)

### Subtle Variations
Small, detailed changes to your image. **Use when:**
- You like the overall image but want to tweak small areas
- Fine-tuning without full redesign
- Subject/composition is right but details need adjustment

### Strong Variations
Significant changes while keeping the main theme intact. **Use when:**
- Exploring bold creative possibilities
- Core idea is right but visual execution needs major push
- Stuck and need fresh interpretation of same concept

### Remix Mode
Allows changing the prompt while making variations. Use when you want to vary AND adjust the prompt simultaneously.

**Works with:** Variations, Vary Region, and Pan
**Can change:** Both your prompt text AND parameters in a single operation

---

## Personalization (`--p`)

Personalization acts as a style assistant, applying your aesthetic preferences automatically to generations.

### Unlocking Personalization

1. Visit the Personalize Page on midjourney.com
2. Rank at least 200 image pairs (or like enough images from Explore page)
3. Once unlocked, you can use `--p` in your prompts

### Using Personalization

**Basic:** Add `--p` to apply your Global Profile
```
a mountain landscape --p
```

**Specific profile:** Use profile code
```
a mountain landscape --p xjspemh
```

### Profiles

- Create multiple profiles with different styles (V7 Profiles and V6 Profiles are separate)
- Each profile generates a unique ID/code
- Set one as your default
- Can also create **Moodboards** — curated image collections that define a specific style

### Stylize + Personalization

When using `--p`, the `--s` (stylize) parameter controls how much personalization is applied:
- Lower stylize = Less personalization effect
- Higher stylize = More personalization effect

| --s Value | Personalization Effect |
|-----------|----------------------|
| 0 | Minimal personalization |
| 100 | Balanced (default) |
| 500+ | Strong personalization |

---

## Utility Tools

### Describe (Vocabulary Discovery)

Upload any image and MJ generates 4 creative prompt suggestions that could recreate it. **Essential for:**
- Discovering effective vocabulary for visual styles
- Learning how MJ interprets visual elements
- Finding keywords you wouldn't have thought of
- Translating visual analysis into MJ-effective language

**Workflow tip:** Use Describe on reference images to discover vocabulary, then incorporate those keywords into your prompts.

---

## Editor

The Editor on midjourney.com provides tools for editing both Midjourney images and your own uploaded images.

### Editor Tools (Light & Full Version)

| Tool | Function |
|------|----------|
| **Undo/Redo/Reset** | Standard editing controls |
| **Move/Resize** | Move, scale, rotate image; change aspect ratio |
| **Paint (Erase)** | Select portions to regenerate |
| **Paint (Restore)** | Bring back erased areas |
| **Smart Select** | Create selection masks for areas to edit |

### Edit Tab Only (Full Editor)

| Tool | Function |
|------|----------|
| **Suggest Prompt** | Uses Describe to generate prompts from your image |
| **Custom Aspect Ratios** | Manually enter any aspect ratio |
| **Layers** | Add additional images to your composition |
| **Retexture** | Regenerate entire image in new style, keeping structure |

### Export Options

- **Upscale to Gallery** — Save to your MJ gallery
- **Download Image** — Save to device (includes option for transparent PNG of erased areas)

### Important Notes

- **Omni Reference images:** Images made with `--oref` can only be opened in the Edit tab. You must remove the `--oref` and `--ow` parameters before submitting edits.
- **Layers/Uploads:** Edited images using layers and uploaded images won't appear in Create/Organize pages unless you upscale them.
- **Instead of Vary Region/Pan/Zoom Out** for `--oref` results, use the Editor for modifications.
