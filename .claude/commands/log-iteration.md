# Log Iteration

Log a Midjourney generation attempt. This captures the prompt, parameters, result assessment, and user feedback for later pattern extraction.

## Instructions

1. **Check for an active session.** Query the database:
   ```sql
   SELECT id, intent, total_iterations FROM sessions WHERE status = 'active' ORDER BY created_at DESC LIMIT 1
   ```

2. **If no active session exists**, ask the user:
   - What are you trying to create? (intent)
   - Do you have a reference image to describe? (reference_description)
   - Then create a new session with a generated UUID.

3. **Determine what data is available.** There are five scenarios:

   **Scenario A: Browser automation capture (richest data path).**
   If the generation was submitted via Playwright MCP (from `/new-session` or manual browser control):
   - Create the iteration screenshot directory:
     ```bash
     mkdir -p sessions/{session_id_first_8}/iter-{NN}/
     ```
   - **Use batch capture** via `browser_run_code` to capture all 4 images in one tool call (see "Batch Image Capture" in automation.md). This saves ~40-50% context compared to individual navigate/screenshot calls:
     ```javascript
     browser_run_code({
       code: `async (page) => {
         const jobId = '[JOB_ID]';
         const dir = 'sessions/[ID]/iter-[NN]';
         for (let i = 0; i < 4; i++) {
           await page.goto('https://www.midjourney.com/jobs/' + jobId + '?index=' + i);
           await page.waitForTimeout(3000);
           await page.screenshot({ path: dir + '/img-' + (i + 1) + '.png' });
         }
         return 'All 4 images captured';
       }`
     })
     ```
   - You already know the exact prompt and parameters (from the session)
   - Analyze all 4 images in the grid using the **7 standard scoring dimensions** (subject, lighting, color, mood, composition, material, spatial) — see "Assessment Scoring Guide" in skill.md. Score every dimension for every image, even if "not applicable" (score 1.0).
     - Flag any dimensions where agent confidence is low (especially spatial_relationships)
     - Identify the best candidate and explain why
     - Note consistency patterns: if all 4 miss the same thing, it's a prompt-level issue; if they diverge, it's MJ interpretation variance
   - Formulate gap analysis per image and overall
   - **Present scores as PRELIMINARY** — ask the user to validate before logging, especially for low-confidence dimensions
   - After user confirms/corrects, recommend next action using the Iteration Action Decision Framework: Upscale best, Vary promising (specify which image), or prompt edit
   - If user approves an action, perform it via browser and capture the result

   **For all scenarios:** Before scoring, check if a reference image is available:
   ```sql
   SELECT reference_image_path FROM sessions WHERE id = ?
   ```
   If the path exists and the file is on disk, load it for direct visual comparison.
   If not available, fall back to text-based comparison using `reference_analysis`.
   Note in the assessment which comparison method was used.

   **Scenario B: User shares the MJ output image.**
   Analyze the image yourself:
   - Look at the image against the session intent and reference analysis (or reference image if available).
   - Score all **7 standard dimensions** (subject, lighting, color, mood, composition, material, spatial) on a 0-1 scale with concrete observations for each. See "Assessment Scoring Guide" in skill.md.
   - If it's a 4-image grid, analyze all 4 individually (same as Scenario A analysis).
   - Identify the top 2-3 gaps between intent and output.
   - Formulate the gap analysis: what's missing, what's wrong, what's unexpected, and your hypothesis for why.
   - Present your full assessment to the user and ask them to confirm, adjust, or add their own observations.
   - Also ask: what prompt did you use, and what parameters?

   **Scenario C: User shares both the output image and the prompt.**
   Same as Scenario B, but you can also analyze the prompt against the output to identify which keywords worked and which didn't. This is especially valuable for keyword effectiveness data.

   **Scenario D: User shares the output image with their own description/feedback.**
   Combine your visual analysis with their observations. The user may notice things you miss (intent mismatch that isn't visually obvious) and you may notice things they miss (subtle lighting or material details). Both perspectives produce the richest log entry.

   **Scenario E: User describes the result in text only.**
   If no image is shared, collect from the user or conversation context:
   - What prompt did you use?
   - What parameters? (--ar, --s, --style, --weird, --no, etc.)
   - What MJ version?
   - How did the result look? (use the assessment scoring guide from skill.md)
   - Any specific feedback?
   - What was missing, wrong, or unexpected?

4. **Insert the iteration** into the database with all collected data. Use JSON for structured fields (parameters, result_assessment, gap_analysis, what_worked, what_failed). Include the `screenshot_dir` path, `action_type`, and `parent_image`:
   ```sql
   INSERT INTO iterations (..., screenshot_dir, action_type, parent_image, scores_validated)
   VALUES (..., 'sessions/{id}/iter-{NN}/', ?, ?, ?)
   ```

   **Action type values:** `initial` (first prompt), `prompt_edit`, `vary_subtle`, `vary_strong`, `rerun`, `upscale_subtle`, `upscale_creative`

   **Parent image:** The image number (1-4) from the previous iteration that this was derived from. NULL for `prompt_edit`, `rerun`, and `initial`.

   **Scores validated:** Set to `1` if the user confirmed or corrected the scores before logging. Set to `0` if agent-only (user didn't review). User-validated scores are higher-quality data for reflection.

   See "Iteration Action Decision Framework" in skill.md for the full decision heuristic and "Assessment Scoring Guide" for the standard 7 dimensions.

5. **If the user says this iteration was successful**, mark it:
   - Set `success = 1` on the iteration
   - Record `what_worked` as a JSON array — be specific about which keywords, parameter choices, or structural decisions contributed
   - Update the session: `status = 'success'`, `final_successful_prompt = <the prompt>`
   - **Trigger automatic reflection:** Run the lightweight reflection extraction (see "Session Lifecycle & Automatic Reflection" in learning.md), or spawn the reflection subagent for background processing
   - Inform the user: "Session marked as successful. Patterns from this session have been captured."

5.5. **If the user signals abandonment** (e.g., "this isn't working", "let's try something different"):
   - Update session: `UPDATE sessions SET status = 'abandoned' WHERE id = ?`
   - **Trigger automatic reflection** (same as success path above)
   - Inform the user: "Session closed. Patterns from the attempts have been captured for future reference."

6. **If not successful** (and not abandoning), record the gap analysis with action decision reasoning:
   - What was missing from the output?
   - What was wrong?
   - What was unexpected?
   - What's the hypothesis for fixing it?
   - **Recommend the next action type** using the Iteration Action Decision Framework from skill.md:
     - Classify the gap type (conceptual miss, single element wrong, right concept wrong execution, etc.)
     - Recommend: Vary Subtle, Vary Strong, prompt edit, or other action
     - If recommending Vary, specify which image number and why
     - If recommending prompt edit, propose specific changes
     - Check for learned action patterns in the database:
       ```sql
       SELECT action_type, parent_image,
              AVG(json_extract(result_assessment, '$.batch_avg')) as avg_score
       FROM iterations
       WHERE action_type IS NOT NULL
       GROUP BY action_type
       ```
   - **Record action decision reasoning** in the gap_analysis JSON (see "Extended Gap Analysis JSON Structure" in skill.md):
     ```json
     "action_decision": {
       "chosen": "prompt_edit",
       "reason": "All 4 images showed same layout problem — structural prompt issue",
       "alternatives_considered": ["vary_strong on img-4"],
       "why_not_alternatives": "Vary wouldn't fix the collage trigger keyword"
     }
     ```
     This reasoning is critical for learning when each action type is appropriate.

7. **Show the user** a summary of what was logged and the current session state (iteration count, what's been tried so far).

8. **If this is iteration 2+**, populate the `delta` section of gap_analysis (see "Extended Gap Analysis JSON Structure" in skill.md):

   a. Query the previous iteration:
      ```sql
      SELECT prompt, parameters, result_assessment FROM iterations
      WHERE session_id = ? AND iteration_number = ?
      ```

   b. Compare prompts and identify changes:
      - `keywords_added`: New keywords not in previous prompt
      - `keywords_removed`: Keywords that were in previous but removed
      - `keywords_modified`: Keywords that changed form (e.g., "soft blur" → "gaussian blur")
      - `parameters_changed`: Any parameter value changes (e.g., `"--s": "50 → 75"`)
      - `structural_changes`: Higher-level changes (reordering, subject removal, etc.)

   c. After scoring, calculate effect:
      - `improved`: Dimensions where score increased ≥0.1
      - `degraded`: Dimensions where score decreased ≥0.1
      - `unchanged`: Dimensions within ±0.1
      - `score_delta`: Change in batch average (e.g., "+0.13")

   d. Store in gap_analysis JSON:
      ```json
      "delta": {
        "from_iteration": 1,
        "keywords_added": ["floating on pure black void"],
        "keywords_removed": ["punk zine aesthetic"],
        "parameters_changed": {"--s": "50 → 75"},
        "structural_changes": "removed layout-triggering descriptor",
        "effect_observed": {
          "improved": ["spatial_relationships", "composition"],
          "degraded": [],
          "unchanged": ["color", "mood"],
          "score_delta": "+0.13"
        }
      }
      ```

   This delta data is where the most valuable patterns emerge — it reveals causation between changes and effects.

## User input: $ARGUMENTS
