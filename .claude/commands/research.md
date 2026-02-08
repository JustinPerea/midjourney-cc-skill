# Research

Research community techniques for a specific Midjourney generation challenge. Usable standalone or mid-session.

## Instructions

0. **Verify database access.** Run `SELECT COUNT(*) FROM sessions` via sqlite-simple MCP. If the query fails, tell the user: "Database not available. Run `claude mcp add sqlite-simple -- npx @anthropic-ai/sqlite-simple-mcp mydatabase.db` then restart Claude Code." Do not proceed without database access.

1. **Determine context** — check for an active session:
   ```sql
   SELECT id, intent, total_iterations, approach_rationale FROM sessions WHERE status = 'active' LIMIT 1
   ```

   - **Mid-session:** The user hit a wall during iteration. Research focus comes from the gap analysis of recent failures.
   - **Standalone:** No active session. Research is exploratory — produce a brief for future sessions.

2. **Parse research focus** from user input (`$ARGUMENTS`). If empty and mid-session, derive focus from the last 3 iterations:
   ```sql
   SELECT iteration_number, what_failed, gap_analysis, prompt
   FROM iterations
   WHERE session_id = ?
   ORDER BY iteration_number DESC
   LIMIT 3
   ```
   Extract the recurring failure themes and use them as the research focus.

3. **Check internal knowledge first** — what do we already know about this topic?
   ```sql
   SELECT id, category, problem, solution, confidence, success_rate
   FROM patterns
   WHERE is_active = 1
     AND (problem LIKE '%' || ? || '%' OR solution LIKE '%' || ? || '%')
   ORDER BY confidence DESC
   ```
   ```sql
   SELECT keyword, intended_effect, effectiveness, notes
   FROM keyword_effectiveness
   WHERE intended_effect LIKE '%' || ? || '%'
   ORDER BY effectiveness DESC
   ```
   Note what's available internally so research can fill the gaps rather than duplicate.

4. **Construct targeted search queries** (pick 3-5 most relevant):
   1. Core technique: `"midjourney v7" "{primary_concept}" prompt`
   2. Reddit community: `site:reddit.com/r/midjourney "{concept}" tips`
   3. Failure-specific: `"midjourney" "{hard_aspect}" how to`
   4. Parameter-specific: `"midjourney v7" --style raw "{concept}"`
   5. Prompt examples: `"midjourney prompt" "{concept}" example`

   If mid-session, tailor queries to the specific failure:
   - Use `what_failed` themes as search terms
   - Include the specific dimension that's lagging (e.g., "texture", "gradient smoothness")

5. **Execute searches** — budget: max 3 WebSearch queries + 2 WebFetch page extractions.
   - Use WebSearch for broad discovery
   - Use WebFetch on the top 2 most promising result pages
   - **Extraction prompt for WebFetch:** "Extract Midjourney prompt techniques for [CONCEPT]. For each: specific keywords, parameters, source context, caveats. Focus on actionable V7 techniques, ignore general advice."

6. **Synthesize findings** into structured format:
   ```
   Community Research Findings (unvalidated):

   1. TECHNIQUE: [name]
      Keywords: [specific keywords to try]
      Parameters: [if any]
      Source: [where found]
      Relevance: [how this addresses the gap]
   ```

7. **Check for conflicts with internal knowledge.** If a research finding contradicts an existing pattern:
   - Present both with evidence counts
   - Internal knowledge has higher trust (real iteration evidence) vs. community anecdote
   - Note the conflict so the user can make an informed choice

8. **If mid-session, propose a prompt revision:**
   - Show the current prompt
   - Mark which elements would change and why
   - Annotate each change as `[research]` or `[internal]` source
   - Let the user approve before submitting

9. **Tag session as research-assisted** (if mid-session):
   ```sql
   UPDATE sessions SET tags = json_insert(COALESCE(tags, '[]'), '$[#]', 'research-assisted') WHERE id = ?
   ```
   Append to approach_rationale:
   ```sql
   UPDATE sessions SET approach_rationale = COALESCE(approach_rationale, '') || ' | Research-assisted (manual): ' || ? WHERE id = ?
   ```

10. **If standalone** (no active session), present findings as a research brief:
    - Summary of techniques discovered
    - Suggested prompt structures
    - Parameters to try
    - Note: "These findings are unvalidated. Start a `/new-session` to test them — they'll be tracked and graduated to patterns if effective."

## User input: $ARGUMENTS
