# Discover Styles

Browse and catalog MJ style codes from the Style Explorer for use in sessions.

## Instructions

0. **Verify database access.** Run `SELECT COUNT(*) FROM sessions` via sqlite-simple MCP. If the query fails, tell the user the database is not available.

1. **Determine discovery mode** from user input:

   - **Browse trending:** Navigate to `midjourney.com/explore?tab=styles_top_month` (or `styles_hot`, `styles_random`)
   - **Search by keyword:** Use the Style Explorer search (e.g., "cinematic", "anime", "watercolor")
   - **Random discovery:** Use `--sref random` in a test prompt to discover serendipitous styles
   - **Test a specific code:** User provides a code they found elsewhere

2. **Browse the Style Explorer** (if Playwright MCP available):
   - Navigate to the styles page
   - Take a screenshot to show the user available styles
   - Extract style codes from the page snapshot (they appear as `--sref <code>` buttons)
   - Let the user pick which styles interest them

3. **For each selected style, catalog it:**

   a. **View the style detail page** — click the style card to see the 8-image grid showing the style applied across different subjects

   b. **Analyze the style** using the 7-element visual framework (see `rules/core-reference-analysis.md`):
      - What palette does it impose?
      - What lighting quality?
      - What material/texture feel?
      - What mood/atmosphere?
      - What composition tendencies?
      - What rendering style (photo, illustration, 3D, etc.)?
      - How strongly does it override prompt keywords vs. complement them?

   c. **Record the style** in the keyword_effectiveness table:
      ```sql
      INSERT INTO keyword_effectiveness (id, keyword, intended_effect, actual_effect, effectiveness, context, mj_version, times_used, times_effective, notes)
      VALUES (lower(hex(randomblob(4))), '--sref <code>', '<intended aesthetic>', '<observed aesthetic>', 'excellent|good|mixed|poor', 'style-code', 'v7', 1, 1, '<analysis notes>')
      ```

   d. **Present to the user:**
      - Style code
      - Visual analysis summary (2-3 sentences)
      - Suggested use cases (what subjects/scenes would work well with this style)
      - Suggested `--sw` range based on how dominant the style is
      - Any `--no` recommendations to prevent the style from introducing unwanted elements

4. **Test a style** (optional, if user wants):
   - Construct a simple test prompt with the style code
   - Submit via browser automation
   - Capture and analyze results
   - Compare output to the style's reference grid — did the code transfer as expected?

5. **Batch discovery** (for building a style library):
   - Browse multiple pages of the explorer
   - Catalog 5-10 styles per session
   - Group them by aesthetic category (cinematic, illustration, abstract, etc.)
   - Store all in keyword_effectiveness for future reference

## Quick Reference: Style Code Syntax

```
--sref <code>                    # Single style
--sref code1 code2               # Blend equal weight
--sref code1::3 code2::1         # Weighted blend
--sref random                    # Random discovery
--sw 100                         # Default style weight
--sw 200                         # Stronger style influence
--sv 4                           # Use old V7 model for legacy codes
```

## User input: $ARGUMENTS
