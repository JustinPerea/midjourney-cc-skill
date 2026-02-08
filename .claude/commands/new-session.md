# New Session

Start a new prompt engineering session with full knowledge application.

## Instructions

0. **Verify database access.** Run `SELECT COUNT(*) FROM sessions` via sqlite-simple MCP. If the query fails, tell the user: "Database not available. Run `claude mcp add sqlite-simple -- npx @anthropic-ai/sqlite-simple-mcp mydatabase.db` then restart Claude Code." Do not proceed without database access.

1. **Gather the user's intent:**
   - What are they trying to create?
   - Do they have a reference image? They can share the image, describe it in text, or both.
   - Any specific requirements (aspect ratio, style, mood, use case)?

2. **Check for unreflected sessions** before starting new work:
   ```sql
   SELECT id, intent, total_iterations, status
   FROM sessions
   WHERE status IN ('success', 'abandoned') AND reflected = 0
   ```

   If any unreflected sessions exist:
   - For each, run the lightweight reflection extraction (see "Session Lifecycle & Automatic Reflection" in `rules/learn-reflection.md`)
   - Mark each session as `reflected = 1`
   - Briefly inform the user: "Extracted patterns from N previous session(s) before starting."

   Also check for sessions left in 'active' status that aren't the current one:
   ```sql
   SELECT id, intent, total_iterations FROM sessions WHERE status = 'active'
   ```
   If found, ask the user: should these be marked as abandoned (triggers reflection) or are they still in progress?

3. **Analyze the reference — image, text, or both:**

   **If the user shares a reference image:**
   - Look at it and produce the full reference analysis: subject, lighting (type, key light, fill, rim, atmosphere), colors (palette, temperature, saturation), material/texture, composition (framing, subject position, depth, negative space), mood, style, render quality.
   - Think about it from a prompt-engineering perspective: what makes this image look this way, what would be hardest to reproduce in MJ, what could MJ misinterpret, and what keywords map to each visual quality.
   - Map visual qualities to prompt language using the keyword effectiveness database.
   - Present your analysis to the user. Let them correct, confirm, or add context that the image alone doesn't convey.

   **If the user provides a text description:**
   - Analyze it using the Reference Analysis Template from `rules/core-reference-analysis.md`. Extract what you can. Ask about genuinely ambiguous aspects only.

   **If both image and text are provided:**
   - Combine them. The image shows what words may not capture; the description reveals intent the image alone doesn't convey. Note any contradictions between the two and ask the user to clarify.

4. **Decide how to use the reference image in MJ (if an image was provided).**
   Evaluate and recommend one of these approaches — ask the user which they prefer:

   - **`--sref` (style reference):** Match the aesthetic, color palette, mood, or rendering style — but with a different subject. Best when the user wants "this vibe" applied to something else.
   - **`--iref` (image reference):** Use as compositional or structural inspiration. Best when the user wants "something that looks like this."
   - **`--oref` (object reference, V7):** Maintain a consistent character or object across generations. (Replaces `--cref` from V6.)
   - **Prompt-only recreation:** Reverse-engineer the look through keywords alone. Harder, but produces transferable knowledge — the prompt works without the reference. Best for learning what keywords produce specific effects.
   - **Hybrid:** Use a reference parameter for the hardest-to-describe qualities while prompting explicitly for everything else. Log which aspects came from the reference param vs. the prompt.

   Log the chosen approach in the session data. This distinction matters for pattern extraction during reflection.

   **Also capture the approach rationale — learning vs. efficiency:**
   - **Learning mode:** Prompt-only or minimal reference use. Goal is to discover which keywords/techniques produce specific effects. Scores may be lower than necessary because the user is intentionally avoiding shortcuts. Reflection should weight keyword data heavily from these sessions.
   - **Efficiency mode:** Use all available tools (--iref, --sref, --oref) to get the best result fastest. Scores reflect tool-assisted quality. Reflection should focus on which reference parameters worked, not keyword discovery.
   - **Hybrid:** Some aspects learned through prompt, others assisted by references. Log which is which.

   Store the rationale:
   ```sql
   UPDATE sessions SET approach_rationale = ? WHERE id = ?
   ```

5. **Apply knowledge before constructing the prompt:**
   - Identify relevant categories from the analysis
   - Query all active patterns (including low-confidence auto-extracted):
     ```sql
     SELECT * FROM patterns WHERE is_active = 1
     ORDER BY
       CASE confidence WHEN 'high' THEN 1 WHEN 'medium' THEN 2 WHEN 'low' THEN 3 END,
       success_rate DESC
     ```
   - **Score each pattern for relevance** to this specific task (not just category match):
     - Does the pattern's problem description match the current situation?
     - If the pattern has conditional notes from contrastive refinement (e.g., "works when X but not when Y"), does the current task match the success conditions?
     - Is the specificity level appropriate? (universal always applies; specific only when exact context matches)
     - When was it last validated and for which MJ version?
   - Organize patterns into tiers:
     - **Strong matches** (high confidence, reviewed)
     - **Likely relevant** (medium confidence)
     - **Worth trying** (low confidence, auto-extracted — flag as "from recent sessions, limited evidence")
     - **Anti-patterns to avoid**
   - Check keyword effectiveness for descriptors you're considering:
     ```sql
     SELECT * FROM keyword_effectiveness WHERE effectiveness IN ('excellent', 'good') ORDER BY effectiveness DESC
     ```
   - Check failure modes to avoid: read `knowledge/failure-modes.md`
   - Look for similar successful sessions:
     ```sql
     SELECT id, intent, final_successful_prompt, reference_analysis FROM sessions WHERE status = 'success'
     ```

5.5. **Assess knowledge coverage and research if needed** (Phase: Testing):

   After applying knowledge (step 5), assess how much internal coverage exists for this intent.

   a. **Calculate coverage score** from step 5 results:

      | Signal | Weight | Calculation |
      |--------|--------|-------------|
      | Pattern matches | 0.40 | `min(1.0, (strong_matches * 3 + likely_relevant * 2 + worth_trying) / 6)` |
      | Keyword data | 0.30 | `descriptors_with_good_data / total_key_descriptors` (from keyword_effectiveness query) |
      | Similar sessions | 0.30 | `min(1.0, similar_successful_sessions / 2)` |

      Overall = weighted sum of the three signals.

   b. **Present coverage assessment** to the user (always, even when high):
      ```
      Knowledge Coverage: [score] ([high/medium/low])
      - Patterns: [N strong, N likely, N worth trying]
      - Keywords: [N/M descriptors have effectiveness data]
      - Similar sessions: [N successful sessions with related intent]
      ```

   c. **If coverage < 0.3**, run community research:
      - Construct 3-5 targeted search queries from intent and gap categories:
        1. Core technique: `"midjourney v7" "{primary_concept}" prompt`
        2. Reddit community: `site:reddit.com/r/midjourney "{concept}" tips`
        3. Failure-specific: `"midjourney" "{hard_aspect}" how to`
        4. Parameter-specific: `"midjourney v7" --style raw "{concept}"`
        5. Prompt examples: `"midjourney prompt" "{concept}" example`
      - Use WebSearch for up to 3 queries, WebFetch for top 2 result pages
      - **Budget:** max 3 searches + 2 page fetches (~30s wall time)
      - **Extraction prompt for WebFetch:** "Extract Midjourney prompt techniques for [CONCEPT]. For each: specific keywords, parameters, source context, caveats. Focus on actionable V7 techniques, ignore general advice."
      - Synthesize findings into structured format:
        ```
        Community Research Findings (unvalidated):

        1. TECHNIQUE: [name]
           Keywords: [specific keywords to try]
           Parameters: [if any]
           Source: [where found]
           Relevance: [how this addresses the gap]
        ```
      - Present findings clearly labeled as **"Community Research (unvalidated)"** — separate from internal knowledge which is "battle-tested" (has logged evidence)

   d. **Tag session** as research-assisted (after session is created in step 6):
      ```sql
      UPDATE sessions SET tags = json_insert(COALESCE(tags, '[]'), '$[#]', 'research-assisted') WHERE id = ?
      ```
      Append to approach_rationale:
      ```sql
      UPDATE sessions SET approach_rationale = COALESCE(approach_rationale, '') || ' | Research-assisted: coverage=' || ? WHERE id = ?
      ```

   e. **If coverage >= 0.3**, skip research. User can trigger `/research` mid-session if needed.

   f. **In prompt construction (step 7)**: internal knowledge forms the backbone, research findings are layered as experimental additions. Each element should be annotated with its source (internal pattern vs. community research).

6. **Create the session in the database:**
   ```sql
   INSERT INTO sessions (id, intent, reference_description, reference_analysis, status)
   VALUES (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(6))), ?, ?, ?, 'active')
   ```

6.5. **Create session directory and persist reference image:**

   a. Create the session directory structure:
      ```bash
      mkdir -p sessions/{session_id_first_8_chars}
      ```

   b. **If a reference image was provided**, persist it to the session directory:
      - If the user provided a **stable file path** (e.g., `~/Downloads/ref.png` or `reference-images/radiant.png`), copy it:
        ```bash
        cp /path/to/user/image.png sessions/{id}/reference.png
        ```
      - If the user **pasted/dropped an image into the terminal**, you can see and analyze it — but the source file is a macOS temp path that disappears almost immediately. You **cannot** copy it. Instead:
        1. Analyze the image immediately (you can see it)
        2. Ask the user to save the image to a stable location: `reference-images/` or directly to `sessions/{id}/reference.png`
        3. Once they confirm the path, copy it to the session directory
      - If a **URL** was provided, download it:
        ```bash
        curl -o sessions/{id}/reference.png <url>
        ```

      **Recommended workflow:** Ask users to save reference images to `reference-images/` before starting. This avoids temp-file issues and keeps originals accessible across sessions.

   c. Update the database with the reference path (if saved):
      ```sql
      UPDATE sessions SET reference_image_path = 'sessions/{id}/reference.png' WHERE id = ?
      ```

   d. If no reference image is available, that's fine — scoring falls back to the
      text-based `reference_analysis` field. But note in the session that visual
      comparison is not available.

7. **Construct the initial prompt** applying all relevant knowledge. Explain your reasoning:
   - Which patterns are being applied and why, with their relevance tier (strong match / likely relevant / worth trying)
   - Which keywords were chosen based on effectiveness data
   - What failure modes you're avoiding, especially those whose trigger conditions overlap with this task
   - Parameter choices and rationale
   - Any conditional constraints from contrastive refinement ("using X because the subject is organic; would use Y instead if metallic")

8. **Log patterns applied:**
   ```sql
   INSERT INTO session_patterns_applied (session_id, pattern_id) VALUES (?, ?)
   ```

9. **Present the prompt** to the user with:
   - The full prompt ready to paste into Midjourney
   - A breakdown of why each part was chosen
   - Parameter recommendations
   - Things to watch for in the output (likely failure points based on patterns)
   - Suggested variations if the first attempt doesn't work
   - **If research-assisted:** a separate section showing which prompt elements came from community research vs. internal knowledge, so the user knows which parts are experimental

10. **Offer browser automation** (if Playwright MCP is available):
   Ask the user if they'd like you to submit the prompt directly to Midjourney via browser automation.

   **If yes:**
   - Navigate to midjourney.com (check if already there)
   - Check authentication state — if not logged in, ask the user to log in manually (cookies persist after first login)
   - Locate the prompt input field using the selector strategy: `data-testid` > ARIA labels > text content > semantic elements > CSS classes
   - Submit the prompt
   - **Use smart generation polling** via `browser_run_code` (see `rules/auto-core-workflows.md` "Wait for Generation") to efficiently wait for completion without consuming context on repeated DOM snapshots
   - **Use batch image capture** via `browser_run_code` (see `rules/auto-core-workflows.md` "Capture Results") to capture all 4 images in a single tool call, saving ~40-50% context per iteration
   - Analyze all 4 images against the session intent using the **7 standard scoring dimensions** (subject, lighting, color, mood, composition, material, spatial) — see `rules/core-assessment-scoring.md`:
     - Score every dimension for every image. Flag low-confidence dimensions.
     - Identify the best candidate and explain why
     - Note consistency patterns across all 4 (if all miss the same thing, it's a prompt issue)
     - Note divergences (if only some miss, it's MJ interpretation variance)
   - **Present scores as PRELIMINARY** — ask user to validate before logging, especially low-confidence dimensions
   - Recommend next action using the Iteration Action Decision Framework (see `rules/core-iteration-framework.md`): Upscale best, Vary (specify image), or prompt edit
   - If the user approves an action, perform it via browser automation

   **If no:**
   - Tell the user to paste the prompt into Midjourney and share the output image when ready

11. **After generation results** (whether via browser automation or user-shared image):
    - Your visual analysis of the output against the reference/intent produces the richest iteration data
    - Automatically log the iteration using the `/log-iteration` workflow — set `action_type = 'initial'` for the first generation
    - **Spatial assessment check:** If the reference or intent involves floating, levitation, unusual grounding, or surreal physics, explicitly ask the user to validate your spatial scoring (see "Known Agent Limitations" in `rules/core-assessment-scoring.md`)
    - Propose next steps based on the gap analysis, using the Iteration Action Decision Framework from `rules/core-iteration-framework.md` to recommend the appropriate action type (Vary vs. prompt edit)

## User input: $ARGUMENTS
