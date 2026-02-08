# Forget Pattern

Deactivate a pattern that is no longer valid (e.g., after MJ version updates).

## Instructions

0. **Verify database access.** Run `SELECT COUNT(*) FROM sessions` via sqlite-simple MCP. If the query fails, tell the user: "Database not available. Run `claude mcp add sqlite-simple -- npx @anthropic-ai/sqlite-simple-mcp mydatabase.db` then restart Claude Code." Do not proceed without database access.

1. **Identify the pattern.** The user may provide:
   - A pattern ID directly
   - A description to search for
   - If unclear, show patterns and let them choose:
     ```sql
     SELECT id, category, problem, solution, confidence, mj_version_discovered FROM patterns WHERE is_active = 1 ORDER BY category
     ```

2. **Show the pattern details** before deactivating:
   ```sql
   SELECT p.*, COUNT(pe.id) as evidence_count
   FROM patterns p
   LEFT JOIN pattern_evidence pe ON p.id = pe.pattern_id
   WHERE p.id = ?
   GROUP BY p.id
   ```

3. **Confirm with the user** that they want to deactivate this pattern. Show:
   - The pattern problem/solution
   - How much evidence supports it
   - When it was last validated
   - Ask for a reason (MJ update, was always wrong, too specific, etc.)

4. **Deactivate** (don't delete - keep for historical reference):
   ```sql
   UPDATE patterns SET is_active = 0, notes = COALESCE(notes || ' | ', '') || 'Deactivated: ' || ? WHERE id = ?
   ```

5. **Optionally**, if the pattern is being replaced by a more accurate one, ask the user if they want to create the replacement pattern now.

6. **Report** confirmation of deactivation.

## User input: $ARGUMENTS
