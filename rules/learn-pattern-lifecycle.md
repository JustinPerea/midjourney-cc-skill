---
title: "Pattern Lifecycle & Knowledge Generation"
impact: "high"
tags: ["confidence", "graduation", "decay", "scope"]
---

# Pattern Lifecycle & Knowledge Generation

How patterns are created, how confidence graduates with evidence, how decay works, scope rules, and how the knowledge base markdown files are regenerated.

## Pattern Lifecycle

```
Observed in 1 session → logged as pattern (confidence: low)
                              ↓
Confirmed in 2-3 more sessions → confidence: medium
                              ↓
Confirmed in 5+ sessions with >80% success → confidence: high
                              ↓
Contradicted by new evidence → flagged for review
                              ↓
Not validated in 60+ days → confidence decays one level
                              ↓
Explicitly invalidated → is_active = 0
```

## Confidence Thresholds

| Level | Criteria |
|-------|----------|
| low | 0-2 tests |
| medium | 3-5 tests with >70% success |
| high | 6+ tests with >80% success |
| decay | Not validated in 60+ days → drop one level |

## Auto-Graduation Queries

After inserting new patterns and updating evidence, run confidence graduation on ALL active patterns:

```sql
-- Graduate to medium: 3+ tests with >70% success
UPDATE patterns SET confidence = 'medium'
WHERE is_active = 1 AND confidence = 'low'
  AND times_tested >= 3 AND success_rate > 0.7;

-- Graduate to high: 6+ tests with >80% success
UPDATE patterns SET confidence = 'high'
WHERE is_active = 1 AND confidence = 'medium'
  AND times_tested >= 6 AND success_rate > 0.8;

-- Decay: not validated in 60+ days
UPDATE patterns SET confidence = 'medium'
WHERE is_active = 1 AND confidence = 'high'
  AND last_validated < datetime('now', '-60 days');
UPDATE patterns SET confidence = 'low'
WHERE is_active = 1 AND confidence = 'medium'
  AND last_validated < datetime('now', '-60 days');
```

## Knowledge Scope

All patterns are Midjourney V7-specific. The `specificity` field uses these values:

- `universal` — Applies across all MJ V7 prompts (e.g., prompt structure rules, parameter defaults)
- `general` — Applies when the category matches (e.g., lighting techniques for any lit scene)
- `specific` — Only applies in exact context (e.g., "subsurface scattering for organic translucent subjects")
- `user-preference` — Personal style preferences, not transferable

"This feels universal" is a hypothesis until tested across diverse sessions. Store patterns with evidence, not assumptions.

If other tools are added later, they get separate knowledge bases starting from zero. Cross-tool patterns require independent evidence from each tool before any shared knowledge base is created.

## Knowledge Base Generation

After every reflection (automatic or manual), regenerate all three files from current DB state:

a. **`knowledge/learned-patterns.md`** — Query all active patterns, group by category, sort by confidence:
   ```sql
   SELECT * FROM patterns WHERE is_active = 1 ORDER BY category, confidence DESC, success_rate DESC
   ```

b. **`knowledge/keyword-effectiveness.md`** — Query all keyword data:
   ```sql
   SELECT * FROM keyword_effectiveness ORDER BY intended_effect, effectiveness DESC
   ```

c. **`knowledge/failure-modes.md`** — Preserve the static diagnostic sections at the top of the file, then replace the "Session-Learned Failure Modes" section with current DB data:
   ```sql
   SELECT id, problem, solution, example_bad, example_good, confidence, success_rate, times_tested
   FROM patterns WHERE is_active = 1 AND category = 'failure-mode'
   ORDER BY confidence DESC, times_tested DESC
   ```
   Write each pattern under the `## Session-Learned Failure Modes` heading using this format:
   ```
   ### {problem} ({id})
   **Fix:** {solution}
   **Bad:** `{example_bad}` → **Good:** `{example_good}`
   **Confidence:** {confidence} ({times_tested} tests, {success_rate}% success)
   ```

Write each file with current timestamp. This ensures the human-readable knowledge layer always matches the database.

## Related Rules

- `learn-data-model` — Defines the database tables patterns are stored in
- `learn-reflection` — The process that creates and updates patterns
