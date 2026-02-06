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
  reference_image_path TEXT,
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
  is_reviewed INTEGER DEFAULT 0 -- 1 if reviewed (auto-extracted patterns are auto-reviewed)
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

-- Session Patterns Applied: Tracks which patterns were used in each session (for validation)
CREATE TABLE session_patterns_applied (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id TEXT NOT NULL REFERENCES sessions(id),
  pattern_id TEXT NOT NULL REFERENCES patterns(id),
  applied_at TEXT NOT NULL DEFAULT (datetime('now')),
  was_effective INTEGER -- 1 = yes, 0 = no, NULL = unknown
);
