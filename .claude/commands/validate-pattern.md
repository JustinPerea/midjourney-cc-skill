# Validate Pattern

Mark a pattern as validated (worked again) or contradicted (failed) based on new evidence.

## Instructions

1. **Identify the pattern.** The user may provide:
   - A pattern ID directly
   - A description of the pattern
   - If unclear, show active patterns and let them pick:
     ```sql
     SELECT id, category, problem, solution, confidence FROM patterns WHERE is_active = 1 ORDER BY category, confidence DESC
     ```

2. **Ask for the outcome:**
   - Did the pattern work as expected? (supported)
   - Did it fail or produce wrong results? (contradicted)
   - Was it not clearly relevant? (neutral)

3. **Get context:** Ask which session this relates to, or if it's a general observation.

4. **Record the evidence:**
   ```sql
   INSERT INTO pattern_evidence (pattern_id, session_id, iteration_id, outcome, notes) VALUES (?, ?, ?, ?, ?)
   ```

5. **Update the pattern stats:**
   ```sql
   UPDATE patterns SET
     times_tested = times_tested + 1,
     times_succeeded = times_succeeded + CASE WHEN ? = 'supported' THEN 1 ELSE 0 END,
     success_rate = CAST(times_succeeded AS REAL) / times_tested,
     last_validated_at = CASE WHEN ? = 'supported' THEN datetime('now') ELSE last_validated_at END,
     last_failed_at = CASE WHEN ? = 'contradicted' THEN datetime('now') ELSE last_failed_at END
   WHERE id = ?
   ```

6. **Update confidence if warranted:**
   - If success_rate drops below threshold for current confidence, lower it
   - If enough new tests support it, raise it
   - Apply the confidence rules from the skill guide

7. **If contradicted**, flag for attention:
   - Show the user the contradiction
   - Ask if the pattern should be updated, kept as-is, or deactivated
   - If the contradiction reveals a more nuanced pattern (works in context A but not B), suggest splitting the pattern

8. **Report** the updated pattern state to the user.

## User input: $ARGUMENTS
