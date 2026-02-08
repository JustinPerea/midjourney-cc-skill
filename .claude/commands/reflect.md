# Reflect

Analyze iteration logs and extract/update patterns in the knowledge base.

## Updated Role

This command now serves as the **deep analysis** layer. Lightweight pattern extraction and
markdown regeneration happen automatically when sessions close (see "Session Lifecycle & Automatic
Reflection" in `rules/learn-reflection.md`). Pattern confidence graduates automatically based on `times_tested` and
`success_rate` thresholds — no manual review gate.

`/reflect` adds:
- Contrastive analysis across sessions (success vs failure comparison)
- Cross-session pattern discovery
- Contradiction resolution (when patterns conflict, produce conditional rules)
- Force full knowledge base regeneration

## Instructions

0. **Verify database access.** Run `SELECT COUNT(*) FROM sessions` via sqlite-simple MCP. If the query fails, tell the user: "Database not available. Run `claude mcp add sqlite-simple -- npx @anthropic-ai/sqlite-simple-mcp mydatabase.db` then restart Claude Code." Do not proceed without database access.

1. **Gather recent data.** Query the database for sessions and iterations that haven't been reflected on yet (or all data if this is the first reflection):

   ```sql
   SELECT s.id, s.intent, s.status, s.final_successful_prompt, s.reference_analysis,
     i.iteration_number, i.prompt, i.parameters, i.result_assessment, i.user_feedback,
     i.gap_analysis, i.success, i.what_worked, i.what_failed, i.action_type, i.parent_image
   FROM sessions s
   JOIN iterations i ON s.id = i.session_id
   WHERE s.reflected = 0
   ORDER BY s.created_at DESC, i.iteration_number ASC
   ```

2. **Analyze successful iterations.** Look for recurring themes in `what_worked`:
   ```sql
   SELECT what_worked FROM iterations WHERE success = 1 AND what_worked IS NOT NULL
   ```
   Parse the JSON arrays and count frequency of each technique across sessions.

3. **Analyze failures.** Look for recurring themes in `what_failed` and `gap_analysis`:
   ```sql
   SELECT what_failed, gap_analysis FROM iterations WHERE (what_failed IS NOT NULL OR gap_analysis IS NOT NULL)
   ```

4. **Extract patterns from iteration deltas.** For multi-iteration sessions, the `gap_analysis.delta` field contains structured change-to-effect mappings. This is the highest-value data for learning:

   ```sql
   SELECT i.iteration_number, i.gap_analysis, i.result_assessment,
          LAG(i.result_assessment) OVER (PARTITION BY i.session_id ORDER BY i.iteration_number) as prev_assessment
   FROM iterations i
   WHERE json_extract(i.gap_analysis, '$.delta') IS NOT NULL
   ORDER BY i.session_id, i.iteration_number
   ```

   For each delta entry, extract:
   - **Keyword addition patterns:** "Adding 'floating on pure black void' improved spatial by +0.2"
   - **Keyword removal patterns:** "Removing 'punk zine aesthetic' fixed composition issues"
   - **Parameter effect patterns:** "Increasing --s from 50 to 75 improved mood but degraded subject accuracy"
   - **Structural patterns:** "Removing concrete subject and describing pure visual effect improved abstraction scores"

   Aggregate across sessions:
   - If the same keyword change appears in 2+ deltas with similar effects → candidate pattern
   - If a parameter change consistently improves/degrades specific dimensions → candidate pattern
   - Store patterns in appropriate category (`keyword`, `parameters`, `technique`)

4.5. **Analyze action decision effectiveness.** Use the `gap_analysis.action_decision` data to learn when each action type is appropriate:

   a. **Aggregate action outcomes:**
      ```sql
      SELECT action_type, parent_image,
             COUNT(*) as count,
             AVG(CASE WHEN success = 1 THEN 1.0 ELSE 0.0 END) as success_rate
      FROM iterations
      WHERE action_type IS NOT NULL
      GROUP BY action_type
      ```

   b. **Extract decision reasoning patterns:**
      ```sql
      SELECT json_extract(gap_analysis, '$.action_decision.chosen') as action,
             json_extract(gap_analysis, '$.action_decision.reason') as reason,
             json_extract(gap_analysis, '$.delta.effect_observed.score_delta') as effect
      FROM iterations
      WHERE json_extract(gap_analysis, '$.action_decision') IS NOT NULL
      ```

   c. **Correlate reasoning with outcomes:**
      - Group decisions by their stated reason
      - Calculate success rate for each reason category
      - Example findings:
        - "prompt_edit when 'all 4 showed same issue'" → 85% success rate
        - "vary_strong when 'single image close but needs push'" → 70% success rate
        - "prompt_edit when 'single element wrong'" → 45% success rate (should have used Vary)

   d. **Identify decision anti-patterns:**
      - Cases where reasoning predicted success but action failed
      - Cases where alternative would have been better (compare to other sessions with similar gaps)

   e. **Extract workflow patterns** and store in the `workflow` category:
      - "When all 4 images have the same gap, use prompt_edit (85% success vs 45% for Vary)"
      - "When batch_avg > 0.8 with single weak dimension, use vary_subtle on best image"

4.7. **Evaluate research-assisted sessions.** For sessions tagged `research-assisted`:

   a. **Identify which research findings were incorporated into prompts.**
      Check approach_rationale for research notes and compare prompt text across iterations:
      ```sql
      SELECT s.id, s.approach_rationale, s.tags,
        i.iteration_number, i.prompt, i.what_worked, i.what_failed, i.success,
        i.result_assessment
      FROM sessions s
      JOIN iterations i ON s.id = i.session_id
      WHERE json_extract(s.tags, '$') LIKE '%research-assisted%'
        AND s.reflected = 0
      ORDER BY s.id, i.iteration_number
      ```

   b. **For each research finding tried:**
      - Present in successful iterations (success=1 or avg score > 0.75)? → Candidate for pattern creation
      - Present in failed iterations then removed in subsequent prompts? → Note as ineffective
      - Modified before working? → The modification is the real pattern, not the original finding

   c. **Graduate validated findings to patterns** at `confidence: low`:
      ```sql
      INSERT INTO patterns (id, category, problem, solution, confidence,
        auto_extracted, is_reviewed, is_active, notes)
      VALUES (?, ?, ?, ?, 'low', 1, 1, 1,
        'Originally from community research. First validated in session ' || ?)
      ```

   d. **Include in reflection report:**
      - "Research findings tried: N"
      - "Research findings validated: M (graduated to low-confidence patterns)"
      - "Research findings ineffective: P"

5. **Contrastive refinement (success vs. failure comparison).** This is the highest-value analysis step — inspired by MACLA's contrastive refinement technique. For each pattern or emerging theme:

   a. Pull iterations where the technique/keyword **succeeded**:
      ```sql
      SELECT i.prompt, i.parameters, i.result_assessment, i.what_worked, s.intent, s.reference_analysis
      FROM iterations i JOIN sessions s ON i.session_id = s.id
      WHERE i.success = 1 AND i.what_worked LIKE '%...relevant technique...%'
      ```

   b. Pull iterations where a similar technique **failed**:
      ```sql
      SELECT i.prompt, i.parameters, i.result_assessment, i.what_failed, i.gap_analysis, s.intent, s.reference_analysis
      FROM iterations i JOIN sessions s ON i.session_id = s.id
      WHERE i.success = 0 AND i.what_failed LIKE '%...relevant technique...%'
      ```

   c. **Compare the two sets.** Look for differentiating factors:
      - What was different about the prompts? (word order, specificity, supporting keywords)
      - What was different about the parameters? (--s value, --ar, --style, MJ version)
      - What was different about the intent/context? (subject type, complexity, style)
      - Were there conflicting keywords in the failures that weren't present in successes?

   d. **Produce conditional pattern descriptions.** Don't just say "technique X works." Say "technique X works *when* [conditions from successes] but *not when* [conditions from failures]." This transforms vague patterns into actionable, context-aware rules.

   Example output: Instead of "subsurface scattering improves translucent materials" → "subsurface scattering improves translucent materials *when the subject is organic or glass-like* but *fails when combined with metallic descriptors* — the renderer seems to average the material properties."

6. **Check existing patterns against new evidence:**
   - Query all active patterns
   - For each, check if new sessions provide supporting or contradicting evidence
   - Insert into `pattern_evidence` table
   - Update `times_tested`, `times_succeeded`, and `success_rate` on the pattern

7. **Propose new patterns** when you identify:
   - A technique that worked in 2+ sessions
   - A failure mode that appeared in 2+ sessions
   - A keyword that consistently produced (or failed to produce) a specific effect

   For each proposed pattern, present it to the user for approval before inserting.

8. **Integration pass (deduplication and merging).** Before inserting new patterns, run an integration check — inspired by BREW's Integrator Agent:

   a. **Check for duplicates.** Query existing active patterns and compare each proposed new pattern:
      ```sql
      SELECT id, category, problem, solution, confidence FROM patterns WHERE is_active = 1 AND category = ?
      ```
      If a proposed pattern describes the same problem/solution as an existing one (even in different words), don't create a duplicate — instead update the existing pattern's evidence and optionally refine its wording.

   b. **Check for subsumption.** Does a proposed pattern cover a subset of an existing, broader pattern? Or does it generalize multiple existing narrow patterns? If so:
      - If the new pattern is more specific: add it as a `specific` specificity level linked to the broader `general` pattern (note the relationship in `notes`).
      - If the new pattern generalizes existing ones: propose upgrading to `general` and marking the narrow ones as subsumed.

   c. **Check for contradictions with existing patterns.** If a new pattern's solution directly contradicts an existing pattern's solution for the same problem:
      - Do NOT silently pick one. Present both to the user with their supporting evidence counts.
      - Often the resolution is a conditional: "Pattern A works in context X, Pattern B works in context Y." This produces the most valuable knowledge.
      - If genuinely contradictory (same context, opposite advice), use contrastive refinement (step 5) to determine which has stronger evidence.

   d. **Merge related keywords.** If keyword effectiveness data shows multiple keywords with similar intended effects, note which are synonyms vs. which produce subtly different results. Group them in the keyword effectiveness markdown.

9. **Update confidence levels:**
   - 0-2 tests: low
   - 3-5 tests with >70% success: medium
   - 6+ tests with >80% success: high
   - Not validated in 60+ days: decay one level

10. **Check for contradictions:** If new evidence contradicts an existing high-confidence pattern, flag it explicitly for the user rather than auto-updating.

11. **Regenerate knowledge base files:**
    - Read all active patterns and regenerate `knowledge/learned-patterns.md`
    - Read keyword effectiveness data and regenerate `knowledge/keyword-effectiveness.md`
    - Read failure-related patterns and regenerate `knowledge/failure-modes.md`
    - Create/update reference translation files as appropriate

12. **Report to the user:**
    - How many sessions/iterations were analyzed
    - New patterns proposed and added
    - Existing patterns updated (confidence changes)
    - Patterns merged or deduplicated
    - Any contradictions found (with contrastive analysis)
    - Conditional refinements added to existing patterns
    - Current state of the knowledge base

## User input: $ARGUMENTS
