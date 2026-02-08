-- Midjourney Prompt Learning System - Database Schema
-- Run: sqlite3 mydatabase.db < schema.sql

-- Sessions: Each prompt engineering session tracking intent, reference, and outcome
CREATE TABLE sessions (
  id TEXT PRIMARY KEY,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  intent TEXT NOT NULL,
  reference_description TEXT,
  reference_analysis TEXT, -- JSON: subject, lighting, colors, material, mood, style
  status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('active', 'success', 'abandoned')),
  final_successful_prompt TEXT,
  total_iterations INTEGER DEFAULT 0,
  tags TEXT, -- JSON array of tags (e.g., "research-assisted")
  reflected INTEGER DEFAULT 0,
  reference_image_path TEXT, -- JSON array of paths (e.g. '["sessions/ab12/reference-1.png"]'). Legacy: bare string = single image.
  approach_rationale TEXT DEFAULT NULL -- "learning" vs "efficiency" vs "hybrid"
);

-- Iterations: Each generation attempt within a session
CREATE TABLE iterations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id TEXT NOT NULL REFERENCES sessions(id),
  iteration_number INTEGER NOT NULL,
  prompt TEXT NOT NULL,
  parameters TEXT, -- JSON: ar, s, style, weird, etc.
  mj_version TEXT,
  result_assessment TEXT, -- JSON: subject, lighting, color, mood, composition, material, spatial scores
  user_feedback TEXT,
  gap_analysis TEXT, -- JSON: core (missing/wrong/unexpected/hypothesis), delta, action_decision
  success INTEGER DEFAULT 0,
  what_worked TEXT, -- JSON array of things that worked
  what_failed TEXT, -- JSON array of things that failed
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  screenshot_dir TEXT, -- Path to iteration image directory
  action_type TEXT DEFAULT 'prompt_edit', -- initial, prompt_edit, vary_subtle, vary_strong, rerun, upscale_subtle, upscale_creative
  parent_image INTEGER DEFAULT NULL, -- Which image (1-4) this was derived from
  scores_validated INTEGER DEFAULT 0, -- 1 if user confirmed scores before logging
  UNIQUE(session_id, iteration_number)
);

-- Patterns: Extracted knowledge with evidence and confidence levels
CREATE TABLE patterns (
  id TEXT PRIMARY KEY,
  category TEXT NOT NULL, -- keyword, technique, failure-mode, parameters, workflow, etc.
  subcategory TEXT,
  problem TEXT NOT NULL,
  solution TEXT NOT NULL,
  example_bad TEXT,
  example_good TEXT,
  confidence TEXT NOT NULL DEFAULT 'low' CHECK(confidence IN ('low', 'medium', 'high')),
  specificity TEXT NOT NULL DEFAULT 'general' CHECK(specificity IN ('universal', 'general', 'specific', 'user-preference')),
  times_tested INTEGER DEFAULT 0,
  times_succeeded INTEGER DEFAULT 0,
  success_rate REAL DEFAULT 0.0,
  tags TEXT, -- JSON array
  mj_version_discovered TEXT,
  mj_version_last_validated TEXT,
  discovered_at TEXT NOT NULL DEFAULT (datetime('now')),
  last_validated_at TEXT,
  last_failed_at TEXT,
  is_active INTEGER DEFAULT 1,
  notes TEXT,
  auto_extracted INTEGER DEFAULT 0, -- 1 if auto-extracted during reflection
  is_reviewed INTEGER DEFAULT 1 -- 1 = active for use. Auto-extracted patterns set this to 1 on insert.
);

-- Pattern Evidence: Links patterns to supporting/contradicting sessions
CREATE TABLE pattern_evidence (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  pattern_id TEXT NOT NULL REFERENCES patterns(id),
  session_id TEXT NOT NULL REFERENCES sessions(id),
  iteration_id INTEGER REFERENCES iterations(id),
  outcome TEXT NOT NULL CHECK(outcome IN ('supported', 'contradicted', 'neutral')),
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Keyword Effectiveness: Tracks which keywords reliably produce specific effects
CREATE TABLE keyword_effectiveness (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  keyword TEXT NOT NULL,
  intended_effect TEXT NOT NULL,
  actual_effect TEXT,
  effectiveness TEXT CHECK(effectiveness IN ('excellent', 'good', 'moderate', 'poor', 'counterproductive')),
  better_alternative TEXT,
  context TEXT, -- When does this keyword work well
  mj_version TEXT,
  times_used INTEGER DEFAULT 0,
  times_effective INTEGER DEFAULT 0,
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  last_used_at TEXT
);

-- View: Pattern summary with evidence counts and health status (used by /show-knowledge)
-- health_status classifies each pattern for triage:
--   untested: times_tested=0, no data (not a failure)
--   anti-pattern: documents a failure mode or pitfall (0% success is expected)
--   healthy: 70%+ success rate
--   mixed: 40-70% success, context-dependent
--   failing: <40% success with real test data (needs investigation)
CREATE VIEW IF NOT EXISTS v_pattern_summary AS
SELECT
  p.*,
  CASE
    WHEN p.times_tested = 0 THEN 'untested'
    WHEN p.notes LIKE '%ANTI-PATTERN%' OR p.category = 'failure-mode' THEN 'anti-pattern'
    WHEN p.success_rate >= 0.7 THEN 'healthy'
    WHEN p.success_rate >= 0.4 THEN 'mixed'
    ELSE 'failing'
  END AS health_status,
  COALESCE(SUM(CASE WHEN pe.outcome = 'supported' THEN 1 ELSE 0 END), 0) AS evidence_supporting,
  COALESCE(SUM(CASE WHEN pe.outcome = 'contradicted' THEN 1 ELSE 0 END), 0) AS evidence_contradicting,
  COALESCE(SUM(CASE WHEN pe.outcome = 'neutral' THEN 1 ELSE 0 END), 0) AS evidence_neutral,
  COUNT(pe.id) AS evidence_total
FROM patterns p
LEFT JOIN pattern_evidence pe ON p.id = pe.pattern_id
GROUP BY p.id;

-- Session Patterns Applied: Tracks which patterns were used in each session (for validation)
CREATE TABLE session_patterns_applied (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id TEXT NOT NULL REFERENCES sessions(id),
  pattern_id TEXT NOT NULL REFERENCES patterns(id),
  applied_at TEXT NOT NULL DEFAULT (datetime('now')),
  was_effective INTEGER -- 1 = yes, 0 = no, NULL = unknown
);

-- Indexes for query performance
CREATE INDEX IF NOT EXISTS idx_iterations_session ON iterations(session_id);
CREATE INDEX IF NOT EXISTS idx_patterns_active_conf ON patterns(is_active, confidence);
CREATE INDEX IF NOT EXISTS idx_sessions_status ON sessions(status);
CREATE INDEX IF NOT EXISTS idx_pattern_evidence_pattern ON pattern_evidence(pattern_id);
CREATE INDEX IF NOT EXISTS idx_session_patterns_session ON session_patterns_applied(session_id);
