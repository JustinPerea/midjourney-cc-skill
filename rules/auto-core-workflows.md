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

## Related Rules

- `auto-reference-patterns` — Selector strategy and error handling for these workflows
- `core-iteration-framework` — Decides which actions (upscale/vary) to perform
- `learn-data-model` — Session directory structure for image storage
