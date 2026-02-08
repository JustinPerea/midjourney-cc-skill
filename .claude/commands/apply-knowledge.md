# Apply Knowledge

Given a reference description or intent, show which learned patterns would apply and construct a prompt using accumulated knowledge.

## Instructions

0. **Verify database access.** Run `SELECT COUNT(*) FROM sessions` via sqlite-simple MCP. If the query fails, tell the user: "Database not available. Run `claude mcp add sqlite-simple -- npx @anthropic-ai/sqlite-simple-mcp mydatabase.db` then restart Claude Code." Do not proceed without database access.

1. **Analyze the user's input** to identify relevant categories. The input could be:
   - A description of what they want ("glowing organic form with dual-tone lighting")
   - A reference to a visual style ("like that glass sculpture look")
   - A set of requirements ("commercial product shot, clean, minimal")

2. **Extract category tags** from the input. Map descriptions to categories:
   - Mentions of light, glow, shadow, bright, dark → `lighting`
   - Mentions of glass, metal, wood, fabric, ceramic → `materials`
   - Mentions of shape, form, organic, geometric → `forms`
   - Mentions of color names, warm, cool, vibrant → `color`
   - Mentions of mood, feeling, vibe → `mood`
   - Mentions of render, 3D, photo, illustration → `style`
   - Mentions of framing, layout, position → `composition`

3. **Query candidate patterns:**
   ```sql
   SELECT * FROM patterns
   WHERE is_active = 1 AND category IN (...extracted categories...)
   AND confidence IN ('medium', 'high')
   ORDER BY confidence DESC, success_rate DESC
   ```

4. **Score each pattern for relevance to this specific task.** Not every pattern in a matching category is equally useful. For each candidate pattern, assess:

   a. **Context match** — Does the pattern's problem description match the current situation? A lighting pattern for "soft ambient" is irrelevant when the user wants "harsh directional." Read the pattern's `problem`, `example_bad`, `example_good`, and `notes` fields to judge fit.

   b. **Specificity alignment** — Prefer patterns whose specificity level matches the task:
      - `universal` patterns always apply (prompt structure rules, parameter basics)
      - `general` patterns apply when the category matches
      - `specific` patterns apply only when the exact context matches (check `notes` and `tags` for conditional context like "works when subject is organic" or "only for V7")
      - `user-preference` patterns apply when the same user's style preferences are relevant

   c. **Evidence strength for similar contexts** — If the pattern has conditional notes from contrastive refinement (e.g., "works when X but not when Y"), check whether the current task matches the success conditions or the failure conditions.
      ```sql
      SELECT pe.outcome, pe.notes, s.intent, s.reference_analysis
      FROM pattern_evidence pe
      JOIN sessions s ON pe.session_id = s.id
      WHERE pe.pattern_id = ?
      ORDER BY pe.created_at DESC LIMIT 5
      ```

   d. **Recency** — More recently validated patterns are more likely to work with the current MJ version. Check `last_validated_at` and `mj_version_last_validated`.

   **Rank patterns** by combining these factors. Present the top patterns to the user organized as:
   - **Strong match** — High relevance, high confidence, recent validation
   - **Likely relevant** — Category match with good confidence but less specific context match
   - **Worth trying** — Lower confidence or less direct relevance but potentially useful
   - **Anti-patterns to avoid** — Failure modes that match this specific context

5. **Query relevant keywords:**
   ```sql
   SELECT * FROM keyword_effectiveness
   WHERE intended_effect LIKE '%...%'
   AND effectiveness IN ('excellent', 'good')
   ORDER BY effectiveness DESC
   ```

6. **Check for failure modes** that are relevant to avoid. Pay special attention to failure modes whose trigger conditions match the current task.

7. **Check reference translations:**
   - Look in `knowledge/reference-translations/` for matching visual concepts
   - Query sessions with similar reference analyses:
     ```sql
     SELECT * FROM sessions WHERE status = 'success' AND reference_analysis LIKE '%...%'
     ```

8. **Construct a recommended prompt** by:
   - Starting with the subject/form
   - Applying lighting patterns (strong matches first)
   - Applying material patterns
   - Adding mood/style descriptors using effective keywords
   - Setting parameters based on parameter patterns
   - Adding `--no` items based on failure mode avoidance
   - Noting any conditional pattern constraints ("using X because the subject is organic; would use Y instead if metallic")

9. **Present to the user:**
   - The recommended prompt
   - For each part of the prompt, cite which pattern or evidence informed it, with relevance tier (strong match / likely relevant / worth trying)
   - Parameter recommendations with reasoning
   - Warnings about known failure modes to watch for, especially those whose trigger conditions overlap with this task
   - Confidence level for the overall recommendation
   - Any conditional notes: "If this doesn't work, the most likely cause is [X] based on pattern [Y]"

10. **Log which patterns were applied** so we can later validate if they worked:
    ```sql
    INSERT INTO session_patterns_applied (session_id, pattern_id) VALUES (?, ?)
    ```

## User input: $ARGUMENTS
