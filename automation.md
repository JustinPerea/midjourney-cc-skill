# Browser Automation
> Part of the Midjourney Prompt Learning System
> Dependencies: playwright MCP (`claude mcp add playwright -- npx @playwright/mcp@latest --headed`)

This module controls Midjourney directly through the browser using the Playwright MCP server. This closes the loop: construct prompt (see `skill.md`) → submit via browser → wait for generation → capture result screenshot → analyze → refine → repeat.

---

## Authentication

Midjourney requires login. On first use:
1. Navigate to `https://www.midjourney.com/imagine`
2. The user logs in manually (Google/Discord OAuth)
3. Cookies persist for subsequent sessions
4. If session expires, prompt the user to re-authenticate

---

## Core Automation Sequences

**1. Navigate to Midjourney**
```
browser_navigate({ url: "https://www.midjourney.com/imagine" })
browser_snapshot()  -- verify we're on the imagine page
```

**2. Submit a Prompt**
```
-- Take snapshot to find the prompt input
browser_snapshot()
-- Type the prompt into the input field
browser_type({ ref: [prompt_input_ref], text: "[full prompt with parameters]" })
-- Submit
browser_press_key({ key: "Enter" })
```

**3. Wait for Generation (Smart Polling)**

Use `browser_run_code` for efficient polling instead of manual wait/snapshot cycles.
This avoids consuming context with repeated DOM snapshots during the wait.

```javascript
browser_run_code({
  code: `async (page) => {
    // Poll every 5s for up to 3 minutes
    for (let i = 0; i < 36; i++) {
      await page.waitForTimeout(5000);
      const trashButtons = await page.$$('button[aria-label="Trash Image"], button:has-text("Trash Image")');
      if (trashButtons.length >= 4) {
        return 'Generation complete (' + ((i + 1) * 5) + 's)';
      }
    }
    return 'Timeout after 180s';
  }`
})
```

After completion, take a snapshot to identify the job URL and action buttons:
```
browser_snapshot()
```

**4. Capture Results (Batch Image Capture)**

Use `browser_run_code` to capture all 4 images in a single tool call.
This replaces 12+ individual navigate/wait/screenshot calls with one script,
reducing context usage by ~40-50% per iteration.

```javascript
browser_run_code({
  code: `async (page) => {
    const jobId = '[JOB_ID from URL]';
    const dir = 'sessions/[SESSION_ID_8]/iter-[NN]';

    for (let i = 0; i < 4; i++) {
      await page.goto('https://www.midjourney.com/jobs/' + jobId + '?index=' + i);
      // Wait for lightbox to load
      await page.waitForTimeout(3000);
      await page.screenshot({ path: dir + '/img-' + (i + 1) + '.png' });
    }
    return 'All 4 images captured to ' + dir;
  }`
})
```

Then load all 4 images for analysis:
```
Read({ file_path: "sessions/[ID]/iter-[NN]/img-1.png" })
Read({ file_path: "sessions/[ID]/iter-[NN]/img-2.png" })
Read({ file_path: "sessions/[ID]/iter-[NN]/img-3.png" })
Read({ file_path: "sessions/[ID]/iter-[NN]/img-4.png" })
```

**Why `browser_run_code` over individual calls:** Each `browser_navigate` or
`browser_snapshot` call returns the full page DOM as YAML (~200-500 lines),
most of which is irrelevant sidebar/navigation content. A single `browser_run_code`
call executes all steps server-side and returns only the result string. For a
4-image capture, this saves ~2000+ lines of context per iteration.

**5. Perform Actions (Upscale/Variation)**
```
-- From the snapshot, identify U1-U4 (upscale) or V1-V4 (variation) buttons
browser_click({ ref: [button_ref], element: "U1 upscale button" })
-- Wait for upscale/variation to complete
browser_wait_for({ time: 15 })
browser_take_screenshot({ type: "png", filename: "midjourney_upscale_[timestamp].png" })
```

---

## Selector Strategy

Midjourney's UI may change. Use this priority order for finding elements:
1. **data-testid attributes** (most stable)
2. **ARIA labels** (accessibility attributes)
3. **Text content** (button labels, placeholders)
4. **Semantic HTML elements** (input, button, textarea)
5. **CSS classes** (least stable, last resort)

Always use `browser_snapshot()` to get the current page state before interacting. The snapshot returns accessible element references you can use with `browser_click()`, `browser_type()`, etc.

---

## Error Handling

| Error | Recovery |
|-------|----------|
| Element not found | Take fresh snapshot, re-identify elements |
| Page not loading | Wait and retry, check network |
| Generation timeout (>120s) | Take screenshot of current state, report to user |
| Session expired | Prompt user to log in again |
| Rate limited | Wait the indicated time, then retry |

---

## 4-Image Grid Analysis

Midjourney generates a 2x2 grid of 4 images. When analyzing results:

1. **Take a screenshot** of the full grid
2. **Analyze all 4 images** — they represent different interpretations of the same prompt
3. **Identify the best candidate** based on the session intent
4. **Note differences between the 4** — these reveal which prompt elements MJ interprets consistently vs. variably
5. **Recommend action**: Upscale (U1-U4) the best one, or use Variation (V1-V4) for more options from a promising direction

---

## Timing Guidelines

| Action | Expected Time |
|--------|---------------|
| Image generation | 30-90 seconds |
| Upscale | 15-30 seconds |
| Variation | 30-60 seconds |
| Page navigation | 3-5 seconds |
| Batch 4-image capture | 12-15 seconds (single `browser_run_code` call) |
| Smart generation poll | Auto-detects completion, polls every 5s |

---

## Image Analysis Workflow

When a user shares an image (reference or MJ output), analyze it directly:

1. **Look at the image.** Extract the same dimensions you'd log in a reference analysis or result assessment.
2. **For reference images:** Produce the full reference analysis (subject, lighting, colors, material, composition, mood, style, render quality) from what you see. Present your analysis and let the user correct or confirm. The user may also provide a text description alongside the image or instead of it — both paths are valid, and combining them produces the richest analysis.
3. **For MJ output images:** Score each assessment dimension by comparing what you see against the session intent. Identify specific gaps — not vague impressions but concrete observations ("the rim light is missing on the right side", "the form is angular where organic was intended").
4. **For side-by-side comparison (reference + output):** Produce a structured diff. What matches? What's off? What's missing entirely? This is the richest source of gap analysis data.

Always present your visual analysis to the user for confirmation before logging it. You may see things differently than they do, and their intent is what matters. But your analysis gives them something concrete to react to rather than starting from a blank "how did it look?"

---

## Reference Image as MJ Input

When a user provides a reference image, there's a separate question beyond analysis: **should this image be fed directly to Midjourney as a reference parameter?**

Evaluate and recommend one of these approaches:

1. **Use as `--sref` (style reference):** When the user wants to match the overall aesthetic, color palette, mood, or rendering style of the reference — but not the specific subject or composition. Good for: "I want this vibe/look applied to a different subject."
2. **Use as `--iref` (image reference):** When the user wants MJ to use the image as compositional or structural inspiration. Good for: "I want something that looks like this."
3. **Use as `--cref` / `--oref` (character/object reference):** When the user wants to maintain a consistent character or object across generations. Note: `--cref` was replaced by `--oref` in V7.
4. **Don't use as reference — prompt-only recreation:** When the user wants to reverse-engineer the look through prompt language alone. This is harder but produces more transferable knowledge (the prompt works without the reference image). Good for: building reusable prompt patterns, learning what keywords produce specific effects, cases where the reference captures a quality the user wants to understand and replicate.
5. **Hybrid approach:** Use an image reference parameter for the hardest-to-describe qualities (specific texture, exact color grade) while prompting explicitly for the elements that can be captured in language. Log which aspects came from the reference param vs. the prompt — this distinction matters for pattern extraction.

Always ask the user which approach they prefer if it's not obvious from context. Explain the tradeoffs. Log the choice in the session data so reflection can analyze which approach works better for different types of images.
