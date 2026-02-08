---
title: "Research Phase"
impact: "critical"
tags: ["research", "coverage", "community", "websearch"]
---

# Research Phase

When the internal knowledge base has low coverage for a new type of generation request, the system can research community techniques to inform the first attempt. This avoids wasting iterations rediscovering techniques the community already knows.

**Status:** Phase: Testing

## Coverage Assessment

After applying knowledge (step 5 in `/new-session`), compute a coverage score:

| Signal | Weight | Calculation |
|--------|--------|-------------|
| Pattern matches | 0.40 | `min(1.0, (strong_matches * 3 + likely_relevant * 2 + worth_trying) / 6)` |
| Keyword data | 0.30 | `descriptors_with_good_data / total_key_descriptors` |
| Similar sessions | 0.30 | `min(1.0, similar_successful_sessions / 2)` |

**Auto-trigger threshold:** coverage < 0.3

Always present the coverage summary to the user regardless of score.

## Research Workflow

**Budget:** Max 3 WebSearch queries + 2 WebFetch page extractions (~30s wall time)

**Query templates** (pick 3-5 most relevant to the intent):
1. Core technique: `"midjourney v7" "{primary_concept}" prompt`
2. Reddit community: `site:reddit.com/r/midjourney "{concept}" tips`
3. Failure-specific: `"midjourney" "{hard_aspect}" how to`
4. Parameter-specific: `"midjourney v7" --style raw "{concept}"`
5. Prompt examples: `"midjourney prompt" "{concept}" example`

**Extraction prompt for WebFetch:**
> Extract Midjourney prompt techniques for [CONCEPT]. For each: specific keywords, parameters, source context, caveats. Focus on actionable V7 techniques, ignore general advice.

## Presentation Rules

Internal knowledge and research findings must always be presented separately:
- **Internal knowledge** = "battle-tested" (has logged evidence from real iterations)
- **Research findings** = "community techniques (unvalidated)" (no local evidence yet)

In prompt construction, internal knowledge forms the backbone. Research findings are layered as experimental additions. Each element should be annotated with its source so the user and reflection system can track what came from where.

## Session Tagging

Research-assisted sessions are tagged for reflection tracking:
```sql
UPDATE sessions SET tags = json_insert(COALESCE(tags, '[]'), '$[#]', 'research-assisted') WHERE id = ?
```

## Related Rules

- `core-prompt-construction` — Uses research findings to supplement prompt construction
- `learn-reflection` — Evaluates research-assisted sessions during reflection
