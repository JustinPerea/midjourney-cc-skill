# Learning & Pattern Tracking
> Part of the Midjourney Prompt Learning System
> Dependencies: sqlite MCP (pointed at `mydatabase.db`, created from `schema.sql`)

This module handles the persistent knowledge layer: pattern extraction, confidence tracking, keyword effectiveness, and knowledge base generation. It turns iteration data into accumulated craft knowledge that improves over time.

For database schema details, see `schema.sql`.

---

## System Components

### Database (SQLite via MCP)

The database at `mydatabase.db` contains:

- **sessions**: Each prompt engineering session (intent, reference analysis, status, final prompt)
- **iterations**: Each attempt within a session (prompt, parameters, assessment, feedback, gap analysis)
- **patterns**: Extracted knowledge (problem/solution pairs with evidence and confidence)
- **pattern_evidence**: Links patterns to the sessions/iterations that support or contradict them
- **keyword_effectiveness**: Tracks which keywords reliably produce specific effects
- **session_patterns_applied**: Tracks which patterns were applied in each session (for validation)

### Knowledge Base (Markdown files)

Human-readable files in `knowledge/`:

- `learned-patterns.md` - All active patterns organized by category
- `keyword-effectiveness.md` - Keyword effectiveness ratings
- `failure-modes.md` - Diagnostic framework, common problems, quick fixes, and session-learned failure modes
- `v7-parameters.md` - Complete Midjourney V7 parameter reference (aspect ratios, stylize, chaos, weird, references, video/animation)
- `translation-tables.md` - Visual quality to prompt keyword mappings (lighting, mood, material, style, composition)
- `prompt-templates/` - Ready-to-use prompt templates by category:
  - `hero-backgrounds.md` - Website hero sections (cosmic, nature, abstract 3D, gradient, surreal, tech)
  - `3d-abstract.md` - CGI-style renders (glass, matte, metallic, particle, geometric forms)
  - `product-photography.md` - Commercial product shots by category
- `reference-translations/` - Specific visual concept to prompt mappings from sessions

---

## Core Data Workflows

### Prompt Construction Queries

When constructing a prompt (see `skill.md` for the full workflow):

1. **Query relevant patterns**:
   ```sql
   SELECT * FROM patterns WHERE is_active = 1 AND category IN (...relevant categories...) ORDER BY confidence DESC, success_rate DESC
   ```
2. **Check keyword effectiveness**:
   ```sql
   SELECT * FROM keyword_effectiveness WHERE intended_effect LIKE '%...%' ORDER BY effectiveness
   ```
3. **Check failure modes**: Read `knowledge/failure-modes.md` for known pitfalls
4. **Log which patterns were applied**:
   ```sql
   INSERT INTO session_patterns_applied (session_id, pattern_id) VALUES (...)
   ```

### Iteration Logging

After each generation attempt, log the iteration:

1. Create a session if one doesn't exist:
   ```sql
   INSERT INTO sessions (id, intent, reference_description, reference_analysis, status)
   VALUES (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(2)) || '-' || hex(randomblob(6))), ?, ?, ?, 'active')
   ```

2. Log each iteration:
   ```sql
   INSERT INTO iterations (session_id, iteration_number, prompt, parameters, mj_version, result_assessment, user_feedback, gap_analysis, success, what_worked, what_failed)
   VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
   ```

3. Update session iteration count:
   ```sql
   UPDATE sessions SET total_iterations = total_iterations + 1 WHERE id = ?
   ```

4. On success, update the session:
   ```sql
   UPDATE sessions SET status = 'success', final_successful_prompt = ? WHERE id = ?
   ```

---

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

### Confidence Thresholds

| Level | Criteria |
|-------|----------|
| low | 0-2 tests |
| medium | 3-5 tests with >70% success |
| high | 6+ tests with >80% success |
| decay | Not validated in 60+ days → drop one level |

---

## Reflection (Pattern Extraction)

When running reflection, analyze logged data to extract or update patterns. The reflection process incorporates three research-informed techniques:

- **Contrastive refinement** (from MACLA): Compare successes against failures to produce conditional patterns ("works when X, fails when Y") instead of unconditional rules.
- **Integration pass** (from BREW): Deduplicate, merge, and resolve contradictions before adding new patterns. Prevents knowledge base bloat and conflicting advice.
- **Relevance context** (from BREW/MACLA): Patterns should carry enough context to determine when they apply, not just what they recommend.

**Step 1: Find recurring successes**
```sql
SELECT what_worked, COUNT(*) as frequency
FROM iterations
WHERE success = 1 AND what_worked IS NOT NULL
GROUP BY what_worked
ORDER BY frequency DESC
```

**Step 2: Find recurring failures**
```sql
SELECT what_failed, COUNT(*) as frequency
FROM iterations
WHERE what_failed IS NOT NULL
GROUP BY what_failed
ORDER BY frequency DESC
```

**Step 3: Analyze gap patterns**
```sql
SELECT gap_analysis FROM iterations WHERE gap_analysis IS NOT NULL
```

**Step 4: Contrastive refinement.** For each emerging pattern or technique that appears in both successes and failures, pull the successful and failed iterations and compare them directly. Identify the differentiating factors — prompt structure, parameters, context, subject type, keyword combinations. Produce conditional pattern descriptions: "technique X works *when* [success conditions] but *not when* [failure conditions]." This is the highest-value analysis step.

**Step 5: Check for patterns needing confidence updates**
```sql
SELECT p.id, p.problem, p.solution, p.confidence, p.times_tested, p.success_rate,
  SUM(CASE WHEN pe.outcome = 'supported' THEN 1 ELSE 0 END) as supported,
  SUM(CASE WHEN pe.outcome = 'contradicted' THEN 1 ELSE 0 END) as contradicted
FROM patterns p
JOIN pattern_evidence pe ON p.id = pe.pattern_id
GROUP BY p.id
HAVING contradicted > 0
```

**Step 6: Identify new patterns** from iteration data that don't match existing patterns.

**Step 7: Integration pass.** Before inserting new patterns, check for duplicates (same problem/solution in different words), subsumption (new pattern generalizes or specializes existing ones), and contradictions (new pattern's advice conflicts with existing pattern). Merge rather than duplicate. When contradictions exist, resolve through contrastive refinement or present both to the user with evidence.

**Step 8: Update confidence levels** using the thresholds above.

**Step 9: Regenerate knowledge base markdown files** from updated database (see Knowledge Base Generation below).

---

## Knowledge Scope

All patterns are Midjourney V7-specific. No "universal" or "domain-level" abstraction. The only distinction is session-specific vs. general (within MJ V7), governed by confidence levels based on evidence count.

"This feels universal" is a hypothesis. "This works in MJ V7" is a pattern. Store patterns, not hypotheses.

If other tools are added later, they get separate knowledge bases starting from zero. Cross-tool patterns require independent evidence from each tool before any shared knowledge base is created.

---

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
   - If a technique appears 2+ times in `what_worked`: create candidate pattern
   - If a technique appears 2+ times in `what_failed`: create candidate failure mode

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

7. **Auto-graduate pattern confidence.** After inserting new patterns and updating evidence, run confidence graduation on ALL active patterns:
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

8. **Mark session as reflected:**
   ```sql
   UPDATE sessions SET reflected = 1 WHERE id = ?
   ```

9. **Regenerate knowledge base markdown files** (see below).

### Reflection Subagent

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
    5. Auto-graduate pattern confidence (see thresholds in learning.md)
    6. Mark session reflected=1
    7. Regenerate knowledge base markdown files (learned-patterns.md, keyword-effectiveness.md, failure-modes.md)

    No manual review needed. Extract, write, regenerate."
)
```

**Important:** If MCP tools aren't available to subagents, fall back to inline reflection (the main agent runs steps 1-9 directly). Test MCP access first.

### `/reflect` Command (Updated Role)

`/reflect` is no longer the primary pattern extraction mechanism. Its new role:
- **Run contrastive analysis:** The deeper analysis (success vs failure comparison) that auto-extraction skips
- **Handle cross-session patterns:** Compare patterns across multiple sessions
- **Resolve contradictions:** When patterns conflict, do contrastive refinement to produce conditional rules
- **Force full regeneration:** Re-run markdown generation if needed

---

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

c. **`knowledge/failure-modes.md`** — Append session-learned failure modes from patterns with failure-related categories:
   ```sql
   SELECT * FROM patterns WHERE is_active = 1 AND (category LIKE '%failure%' OR solution LIKE '%avoid%' OR solution LIKE '%fails when%' OR solution LIKE '%don''t%')
   ```

Write each file with current timestamp. This ensures the human-readable knowledge layer always matches the database.
