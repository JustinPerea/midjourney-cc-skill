---
title: "Reference Analysis & Visual Framework"
impact: "critical"
tags: ["reference", "analysis", "visual-framework", "vocabulary"]
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
