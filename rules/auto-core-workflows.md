---
title: "Browser Automation Workflows"
impact: "medium"
tags: ["playwright", "polling", "capture", "submit", "auth"]
---

# Browser Automation Workflows

Playwright-based browser control for midjourney.com. This closes the loop: construct prompt → submit via browser → wait for generation → capture result screenshot → analyze → refine → repeat.

## Authentication

Midjourney requires login. On first use:
1. Navigate to `https://www.midjourney.com/imagine`
2. The user logs in manually (Google/Discord OAuth)
3. Cookies persist for subsequent sessions
4. If session expires, prompt the user to re-authenticate

## Core Automation Sequences

**1. Navigate to Midjourney**
```
browser_navigate({ url: "https://www.midjourney.com/imagine" })
browser_snapshot()  -- verify we're on the imagine page
```

**1.5. Disable Personalization**

V7 has personalization ON by default, which silently biases all generations toward the user's aesthetic profile. For reproducible prompt engineering, disable it before submitting prompts.

```
-- After navigating to the imagine page, take a snapshot
browser_snapshot()
-- Look for the personalization toggle near the Imagine bar
-- It may appear as a toggle button, a "--p" indicator, or a profile icon
-- If personalization is active/enabled, click to toggle it OFF
browser_click({ ref: [personalization_toggle_ref], element: "Personalization toggle" })
-- Verify it's now off
browser_snapshot()
```

**Why this matters:** Patterns extracted with personalization on reflect a blend of prompt + user aesthetic. Disabling it isolates prompt effects, making patterns more universal and reproducible. The toggle persists across the session, so this only needs to be done once per browser session.

**Exception:** If the user explicitly wants personalization on (e.g., testing their profile's effect), skip this step and log `personalization=on` in the session's `approach_rationale`.

**2. Submit a Prompt**
```
-- Take snapshot to find the prompt input
browser_snapshot()
-- Type the prompt into the input field
browser_type({ ref: [prompt_input_ref], text: "[full prompt with parameters]" })
-- Submit
browser_press_key({ key: "Enter" })
```

**3. Wait for Generation (Multi-Signal Adaptive Polling)**

Use `browser_run_code` for efficient polling instead of manual wait/snapshot cycles.
This avoids consuming context with repeated DOM snapshots during the wait.

The polling uses multiple independent signals to detect completion, making it resilient to UI changes:
- **Action buttons** (Vary, Upscale, Rerun, Strong, Subtle) — most reliable positive signal
- **CDN images** — 4+ loaded `cdn.midjourney.com` images indicate a finished grid
- **Progress indicators** — percentage text or "Running"/"Queued" status means still generating
- **Diagnostic dump on timeout** — captures visible buttons and image count so you can debug selector drift

```javascript
browser_run_code({
  code: `async (page) => {
    // Skip first 15s — no generation finishes faster
    await page.waitForTimeout(15000);

    // Poll every 5s for up to 3 minutes total
    for (let i = 0; i < 33; i++) {
      await page.waitForTimeout(5000);
      const elapsed = 15 + ((i + 1) * 5);

      // --- Positive signals (any = done) ---
      // Check for action buttons (Vary, Upscale, Rerun, etc.)
      const actionBtns = await page.$$([
        'button:has-text("Vary")',
        'button:has-text("Upscale")',
        'button:has-text("Rerun")',
        'button:has-text("Strong")',
        'button:has-text("Subtle")',
        'button:has-text("Creative Upscale")',
        'button[aria-label*="Vary"]',
        'button[aria-label*="Upscale"]'
      ].join(', '));

      if (actionBtns.length >= 2) {
        return 'DONE: ' + actionBtns.length + ' action buttons found (' + elapsed + 's)';
      }

      // --- Negative signals (presence = still generating) ---
      const progressText = await page.evaluate(() => {
        const body = document.body.innerText;
        const pctMatch = body.match(/(\\d{1,3})%/);
        const running = body.includes('Running') || body.includes('Queued');
        return { pct: pctMatch ? pctMatch[1] : null, running };
      });

      // If we see progress, we know it's actively generating — keep waiting
      if (progressText.pct || progressText.running) continue;

      // No progress AND no action buttons — might be in a transition state
      // Check for loaded images as secondary signal
      const images = await page.$$('img[src*="cdn.midjourney.com"]');
      if (images.length >= 4) {
        return 'DONE: ' + images.length + ' CDN images loaded (' + elapsed + 's)';
      }
    }

    // Timeout — collect diagnostic info
    const diag = await page.evaluate(() => {
      const buttons = [...document.querySelectorAll('button')].map(b => b.textContent.trim()).filter(t => t.length > 0 && t.length < 30);
      const hasProgress = document.body.innerText.match(/(\\d{1,3})%/);
      const imgCount = document.querySelectorAll('img').length;
      return { buttons: buttons.slice(0, 15), progress: hasProgress ? hasProgress[1] + '%' : 'none', imgCount };
    });
    return 'TIMEOUT 180s. Diag: ' + JSON.stringify(diag);
  }`
})
```

**Interpreting results:**
- `DONE: N action buttons found (Xs)` — normal completion, proceed to snapshot
- `DONE: N CDN images loaded (Xs)` — completed but action buttons may have different selectors; proceed but note this for future selector updates
- `TIMEOUT 180s. Diag: {...}` — check the diagnostic JSON: `buttons` shows what's actually in the DOM (use these labels to update selectors), `progress` indicates if generation is still running, `imgCount` shows total images on page

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

**6. Editor Edit (Selective Inpainting)**

Use MJ's built-in editor to mask specific areas for regeneration while preserving the rest. This is the automation path for `action_type: editor_edit` in the iteration framework.

```
-- Navigate to the image detail page
browser_navigate({ url: "https://www.midjourney.com/jobs/[JOB_ID]?index=[IMAGE_INDEX]" })
browser_snapshot()
-- Click the Edit button
browser_click({ ref: [edit_button_ref], element: "Edit button" })
browser_snapshot()  -- verify editor opened
```

**Masking with Smart Select (preferred):**
```
-- Click Smart Select tool
browser_click({ ref: [smart_select_ref], element: "Smart Select tool" })
-- Click on the region to segment (e.g., background area)
browser_click({ ref: [canvas_ref], element: "Canvas - select background region" })
-- Wait for segmentation API response
browser_wait_for({ time: 3 })
browser_take_screenshot()  -- verify green selection mask
-- Convert selection to erase mask
browser_click({ ref: [erase_selection_ref], element: "Erase Selection button" })
-- Verify: erased area shows checkerboard transparency pattern
browser_take_screenshot()
```

**Fallback: Manual Erase tool painting:**
If Smart Select fails (segmentation API error), use the manual Erase tool:
```
-- Click Erase tool (use exact ref, not name — "Erase" matches multiple buttons)
browser_click({ ref: [erase_tool_ref], element: "Erase tool button" })
-- Paint mask strokes on the canvas using browser_run_code for coordinate control
browser_run_code({
  code: `async (page) => {
    const canvas = page.locator('canvas').first();
    const box = await canvas.boundingBox();
    // Paint horizontal strokes across the target area
    for (let y = box.y + 20; y < box.y + box.height - 20; y += 15) {
      await page.mouse.move(box.x + 20, y);
      await page.mouse.down();
      await page.mouse.move(box.x + box.width - 20, y, { steps: 10 });
      await page.mouse.up();
      await page.waitForTimeout(50);
    }
    return 'Erase mask painted';
  }`
})
```

**Update prompt and submit:**
```
-- Clear and update the prompt text
browser_run_code({
  code: `async (page) => {
    const textbox = page.getByRole('textbox', { name: 'What will you imagine?' });
    await textbox.press('ControlOrMeta+a');
    await textbox.fill('[new prompt emphasizing desired qualities for regenerated area]');
    return 'Prompt updated';
  }`
})
-- Submit the edit
browser_click({ ref: [submit_edit_ref], element: "Submit Edit button" })
```

Then use the standard polling (step 3) and capture (step 4) sequences. The new job URL will appear in the page snapshot after submission.

**Key notes:**
- The Erase tool button has strict mode issues — `getByRole('button', { name: 'Erase' })` matches "Erase", "Erase Selection", and "Erase Background". Always use the exact element `ref` from the snapshot.
- Smart Select may need multiple clicks on different parts of the region to build a complete mask.
- Consider removing `--sref` or `--raw` from the edit prompt if those parameters caused the regional issue being fixed.
- Editor edits produce 4-image batches like normal generations — capture and score all 4.

**7. Animate Image (Loop / Auto)**

MJ can animate any generated image into a 5-second video clip. Two modes:
- **Auto** — one-directional motion (Low/High Motion)
- **Loop** — start and end frames match for seamless looping (Low/High Motion)

Each mode has Low Motion (subtle, form-preserving) and High Motion (dramatic, transformative).

```
-- Navigate to the image detail page
browser_navigate({ url: "https://www.midjourney.com/jobs/[JOB_ID]?index=[IMAGE_INDEX]" })
browser_snapshot()
-- Find animation buttons: "Loop Low Motion", "Loop High Motion", "Auto Low Motion", "Auto High Motion"
-- Click the desired animation button using its ref
browser_click({ ref: [animation_button_ref], element: "Loop Low Motion" })
```

**Wait for Video Completion:**

Animation takes longer than image generation (~45-120s). After clicking the animation button, a new job is created. Navigate to the new job page to poll for completion:

```javascript
browser_run_code({
  code: `async (page) => {
    // Navigate to the animation job page
    await page.goto('https://www.midjourney.com/jobs/[ANIMATION_JOB_ID]?index=0');
    await page.waitForTimeout(10000);

    // Poll for video element
    for (let i = 0; i < 40; i++) {
      await page.waitForTimeout(5000);
      const elapsed = 10 + ((i + 1) * 5);

      const video = await page.$('video');
      if (video) {
        const src = await page.evaluate(() => {
          const v = document.querySelector('video source, video');
          return v?.src || v?.querySelector('source')?.src || 'video found, no src';
        });
        return 'DONE: Video loaded (' + elapsed + 's). URL: ' + src;
      }
    }
    return 'TIMEOUT 210s — no video element found';
  }`
})
```

**Capture video screenshot:**
```
browser_take_screenshot({ type: "png", filename: "sessions/[ID]/iter-[NN]/loop-low-motion.png" })
```

**Key findings from testing:**
- Animation generates **4 video variations** (index 0-3), just like image generation
- Videos are at `cdn.midjourney.com/video/{job-id}/{index}.mp4` (5.04s each)
- Cost is ~8x a regular image generation
- **Low Motion** preserves form identity — ideal for loops with geometric/symmetric subjects
- **High Motion** dramatically deforms the source — use for cinematic one-shots, not loops
- Best animation source images: radial symmetry, clean black backgrounds, internal glow, centered composition

**Ideal animation source prompt pattern:**
Heavy `--no` list to eliminate background detail, `--style raw` for clean rendering, `--ar 1:1` for symmetric output, luminous/glowing subjects on "pure black void."

## Related Rules

- `auto-reference-patterns` — Selector strategy and error handling for these workflows
- `core-iteration-framework` — Decides which actions (upscale/vary) to perform, including editor_edit
- `learn-data-model` — Session directory structure for image storage
