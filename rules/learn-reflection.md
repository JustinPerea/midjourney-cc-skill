---
title: "Reflection & Session Lifecycle"
impact: "high"
tags: ["reflection", "contrastive", "auto-reflection", "subagent"]
---

# Reflection & Session Lifecycle

How sessions are closed, how automatic reflection extracts patterns, the reflection subagent, and the role of the `/reflect` command for deeper cross-session analysis.

## Session Lifecycle & Automatic Reflection

### Session Close Detection

When the user signals session completion, the agent should:
1. Update the session status
2. Trigger automatic reflection (inline or via subagent)
3. Confirm to the user that patterns were captured

**Recognition signals — the agent should detect these naturally:**

| User Signal | Session Status | Action |
|-------------|---------------|--------|
| "Perfect", "That works", "I'm happy with this" | `success` | Mark success + trigger reflection |
| "Good enough", "Let's move on" | `success` | Mark success + trigger reflection |
| "This isn't working", "Let's try something else" | `abandoned` | Mark abandoned + trigger reflection |
| "Start fresh", "New session" | Close current as `abandoned` | Trigger reflection + start new |
| Starting `/new-session` with active session | Depends on user response | Ask, then trigger reflection |

### Automatic Reflection Flow

When a session is closed (success or abandoned), run this extraction:

1. **Query all iterations for the session:**
   ```sql
   SELECT * FROM iterations WHERE session_id = ? ORDER BY iteration_number
   ```

2. **Identify successes and failures:**
   - Successes: iterations where `success = 1` OR `result_assessment` average > 0.75
   - Failures: iterations where `success = 0` AND average < 0.65

3. **Extract keyword patterns:**
   - Parse prompts from all iterations
   - For each keyword, record: context, success/failure, score
   - Upsert into `keyword_effectiveness` (increment `times_used`, `times_effective`)

4. **Extract technique patterns:**
   - Parse `what_worked` and `what_failed` JSON arrays from all iterations
   - Count frequency of each technique
   - If a technique appears 2+ times in `what_worked`: create candidate pattern (use category matching the technique type: `keyword`, `technique`, `parameters`, etc.)
   - If a technique appears 2+ times in `what_failed`: create candidate pattern with `category = 'failure-mode'`. This exact category value is required for failure-modes.md generation.

4.5. **Extract action decision patterns:**
   - For each iteration with `action_type` set, compare its scores to the previous iteration
   - Record whether the action improved, maintained, or degraded the result
   - If a pattern emerges (e.g., "vary_strong improved scores when batch_avg > 0.8"), create a `workflow` category candidate pattern

5. **Write patterns with low confidence, auto-extracted:**
   ```sql
   INSERT INTO patterns (id, category, problem, solution, confidence, auto_extracted, is_reviewed, is_active, discovered_at)
   VALUES (?, ?, ?, ?, 'low', 1, 1, 1, datetime('now'))
   ```
   No manual review gate — patterns are active and reviewed on insertion. Confidence graduates automatically based on `times_tested` and `success_rate`.

6. **Check for duplicates** against existing active patterns before inserting. Skip if the same problem/solution already exists.

7. **Auto-graduate pattern confidence.** After inserting new patterns and updating evidence, run confidence graduation on ALL active patterns (see `rules/learn-pattern-lifecycle.md`).

8. **Mark session as reflected:**
   ```sql
   UPDATE sessions SET reflected = 1 WHERE id = ?
   ```

9. **Regenerate knowledge base markdown files** (see `rules/learn-pattern-lifecycle.md`).

## Reflection Subagent

For background processing, spawn a general-purpose subagent:

```
Task(
  subagent_type="general-purpose",
  run_in_background=true,
  prompt="You are the reflection subagent for the Midjourney learning system.
    Database: mydatabase.db (via sqlite-simple MCP)
    Session ID: {session_id}

    1. Query all iterations for this session
    2. Extract patterns from what_worked/what_failed
    3. Insert new patterns with confidence='low', auto_extracted=1, is_reviewed=1
    4. Update keyword_effectiveness for keywords used
    5. Auto-graduate pattern confidence (see thresholds in rules/learn-pattern-lifecycle.md)
    6. Mark session reflected=1
    7. Regenerate knowledge base markdown files (learned-patterns.md, keyword-effectiveness.md, failure-modes.md)

    No manual review needed. Extract, write, regenerate."
)
```

**Important:** If MCP tools aren't available to subagents, fall back to inline reflection (the main agent runs steps 1-9 directly). Test MCP access first.

## Reflection Techniques

The reflection process incorporates three research-informed techniques:

- **Contrastive refinement** (from MACLA): Compare successes against failures to produce conditional patterns ("works when X, fails when Y") instead of unconditional rules.
- **Integration pass** (from BREW): Deduplicate, merge, and resolve contradictions before adding new patterns. Prevents knowledge base bloat and conflicting advice.
- **Relevance context** (from BREW/MACLA): Patterns should carry enough context to determine when they apply, not just what they recommend.

## `/reflect` Command (Updated Role)

`/reflect` is no longer the primary pattern extraction mechanism. Its new role:
- **Run contrastive analysis:** The deeper analysis (success vs failure comparison) that auto-extraction skips
- **Handle cross-session patterns:** Compare patterns across multiple sessions
- **Resolve contradictions:** When patterns conflict, do contrastive refinement to produce conditional rules
- **Force full regeneration:** Re-run markdown generation if needed

## Related Rules

- `learn-data-model` — Database schema and query patterns
- `learn-pattern-lifecycle` — Confidence graduation and knowledge generation
- `core-assessment-scoring` — Produces the scores reflection analyzes
