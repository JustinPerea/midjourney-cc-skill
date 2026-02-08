---
title: "Selector Strategy & Reference Patterns"
impact: "medium"
tags: ["selectors", "errors", "timing", "grid", "image-analysis"]
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
