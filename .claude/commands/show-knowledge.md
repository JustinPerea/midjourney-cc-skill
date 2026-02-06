# Show Knowledge

Display the current state of learned knowledge, optionally filtered by category.

## Instructions

1. **Parse the optional category filter** from user input. Valid categories:
   - lighting, materials, forms, parameters, prompt-structure, color, composition, style, mood, v7, failure-modes, keywords
   - If no category specified, show an overview of all.

2. **If showing overview** (no category filter):
   ```sql
   SELECT category, COUNT(*) as pattern_count,
     SUM(CASE WHEN confidence = 'high' THEN 1 ELSE 0 END) as high_confidence,
     SUM(CASE WHEN confidence = 'medium' THEN 1 ELSE 0 END) as medium_confidence,
     SUM(CASE WHEN confidence = 'low' THEN 1 ELSE 0 END) as low_confidence
   FROM patterns WHERE is_active = 1
   GROUP BY category
   ORDER BY pattern_count DESC
   ```

   Also show:
   ```sql
   SELECT COUNT(*) as total_sessions, SUM(total_iterations) as total_iterations,
     SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) as successful_sessions
   FROM sessions
   ```

   And:
   ```sql
   SELECT COUNT(*) as total_keywords FROM keyword_effectiveness
   ```

3. **If showing a specific category:**
   ```sql
   SELECT * FROM v_pattern_summary WHERE category = ? AND is_active = 1 ORDER BY confidence DESC, success_rate DESC
   ```

   For each pattern, display:
   - Problem / Solution
   - Example bad / Example good
   - Confidence level and success rate
   - Evidence count (supporting vs contradicting)
   - When it was discovered and last validated

4. **If category is 'keywords':**
   ```sql
   SELECT * FROM keyword_effectiveness ORDER BY effectiveness DESC, times_used DESC
   ```

5. **If category is 'failure-modes':** Read and display `knowledge/failure-modes.md`.

6. **Format the output** in a clear, readable way with headers and sections.

## User input: $ARGUMENTS
