# Midjourney Prompt Learning System

A Claude Code skill that teaches itself Midjourney prompt engineering. It starts with a structured understanding of Midjourney built from the [official documentation](https://docs.midjourney.com) — V7 parameters, prompt syntax, reference systems (`--sref`, `--oref`), style codes, and a visual-quality-to-keyword translation framework. Then it learns by doing: each session feeds a loop where patterns are extracted from successes and failures, keywords are ranked by effectiveness, and failure modes are cataloged. Over time, first-attempt quality improves as the system applies accumulated craft knowledge on top of its documentation foundation.

> **19 sessions, 93 iterations, 94 patterns, 124 tracked keywords** — and growing.

## How It Works

### 0. Start with documentation knowledge

The system ships with static knowledge files distilled from Midjourney's official docs: every V7 parameter and its behavior, prompt structure rules, reference system syntax (`--sref`, `--oref`, `--iref`), style codes, and translation tables that map visual qualities (e.g., "light from behind subject") to effective prompt keywords (e.g., "backlighting, rim light, silhouette"). This is the baseline — the system understands Midjourney's tools before it ever generates an image.

### 1. Analyze the target

You provide a reference image, a text description, or both. The system breaks down the target into 7 visual dimensions — subject, lighting, colors, material/texture, composition, mood, and rendering style — and maps each quality to prompt language. When multiple reference images are provided, it identifies which qualities are shared across all of them (the target aesthetic) vs. which vary (subject-specific, not style-defining).

### 2. Choose an approach

Not every session uses the same tools. The system evaluates the target and recommends one of several approaches:

- **Prompt-only** — Reverse-engineer the look through keywords alone. Harder, but produces transferable knowledge that works without any reference.
- **`--sref` (style reference)** — Upload a reference image or use a style code to transfer aesthetic qualities MJ can't easily get from words: specific color grades, grain character, rendering style.
- **`--sref` with style codes** — Apply curated aesthetics from MJ's style library using numeric codes. Supports blending multiple codes with weighted ratios.
- **Hybrid** — Use `--sref` for the hardest-to-describe qualities while prompting explicitly for everything else. The system tracks which aspects came from the reference vs. the prompt.

### 3. Apply accumulated knowledge

Before writing a single word of the prompt, the system queries its database — 94 patterns, 121 tracked keywords, 15 cataloged failure modes — and scores each for relevance to the current task. If internal knowledge coverage is low (novel subject or technique), it automatically runs community research to fill gaps, clearly labeling findings as unvalidated.

### 4. Generate, score, iterate

The prompt is submitted to Midjourney via browser automation (or pasted manually). All 4 output images are scored on 7 dimensions against the reference or session intent, and gap analysis determines the next action: Vary Subtle, Vary Strong, prompt rewrite, add `--sref`, editor inpainting, or animate. Each iteration is logged with what changed and what effect it had.

### 5. Extract and compound

When a session closes, the system extracts patterns from what worked and what didn't. Keyword effectiveness is updated, new failure modes are cataloged, and action decision data accumulates. The next session starts with everything the previous sessions learned.

## What It Learns

Real numbers from the database after 18 sessions:

| What | Count | How It's Used |
|------|-------|---------------|
| **Patterns** | 94 across 14 categories | Applied to new prompts before generation. Each has a problem/solution pair with evidence chain |
| **Keywords** | 124 tracked | Ranked by effectiveness. Bad keywords actively avoided |
| **Failure modes** | 15 cataloged | Diagnostic trees organized by scoring dimension. System checks for known traps before constructing prompts |
| **Action decisions** | 93 logged | Which action (Vary, prompt edit, sref, editor, animate) works best for which gap type |

<details>
<summary>Example pattern card (from database)</summary>

```
Pattern: raw-grain-lighting-tradeoff
Category: technique | Confidence: medium | Success rate: 33% (1/3)

Problem: Need both heavy film grain and flat even lighting in the same image.
         --style raw increases grain but darkens. Removing raw brightens but
         reduces grain.

Solution: Accept the balanced result (with --raw at moderate sref weight)
          rather than trying to maximize both. Alternatively, use editor edit
          to fix lighting regionally, accepting some texture mismatch.

Evidence: Session 17bbeab3 — 3 A/B comparisons across iter 9-14.
          raw+grain sref: grain 0.93, lighting 0.74
          no raw: grain 0.84, lighting 0.85
          balanced: grain 0.85, lighting 0.84 (best overall at 0.90)
```

</details>

## See It In Action

### Surreal B&W Film Portrait — Tradeoff Discovery

**Goal:** A surreal headless figure with lilies growing from the neck, heavy B&W film grain, flat even lighting on a seamless gray backdrop. Match a specific reference photo's grain character and deadpan mood. Target: 0.93 score.

| Reference | Iteration 1 (0.85) | Iteration 4 — Peak (0.90) | Iteration 9 — Grain Breakthrough |
|:-:|:-:|:-:|:-:|
| ![Reference](docs/examples/flower-head/reference.jpg) | ![Iter 1](docs/examples/flower-head/iter-01-best.png) | ![Iter 4](docs/examples/flower-head/iter-04-best.png) | ![Iter 9](docs/examples/flower-head/iter-09-grain.png) |

#### Setup decisions

The system analyzed the reference image and made three upfront choices before generating anything:

1. **Hybrid approach** — Use `--sref` with the reference for grain/mood transfer (hard to describe in words) while prompting explicitly for the surreal subject (headless figure, lilies). Log which aspects come from sref vs. prompt so reflection can learn from both.
2. **Second sref for grain** — The reference's film grain was the hardest quality to reproduce. The system found a dedicated grain reference photo and blended it as a weighted secondary sref (`grain::2 flower::1`), targeting the specific dimension where prompt keywords have the weakest control.
3. **Knowledge application** — Queried 88 patterns before writing the prompt. Applied "front-load critical details" (V7 weights prompt beginning), checked keyword effectiveness for B&W film descriptors, and avoided known failure modes like "clean" + "sharp" co-occurring with film grain intent.

#### What happened: 15 iterations across 6 approaches

**Rapid convergence (iter 1-4).** The knowledge-informed first prompt scored 0.85 — subject, mood, and color were strong immediately. Three iterations of prompt refinement (adding "flat overcast softbox lighting," expanding the `--no` list) pushed the best image to **0.90** by iteration 4. The system recommended Vary Subtle to polish rather than prompt edit, following the "fragile equilibria above 0.80" pattern.

**Pushing for 0.93 revealed a fundamental tradeoff.** Grain and lighting couldn't be maximized simultaneously — they pulled in opposite directions:

| Approach | Iters | Best Score | Grain | Lighting | What It Proved |
|----------|-------|-----------|-------|----------|---------------|
| Balanced (prompt + dual sref) | 1-4 | **0.90** | 0.85 | 0.84 | Best overall, but neither dimension maxed |
| Vary Subtle | 5, 7, 10 | 0.887 | 0.87 | 0.80 | Maintains structure, regresses lighting |
| Grain-only sref | 9 | 0.879 | **0.93** | 0.74 | Grain breakthrough — but too dark |
| Flat lighting prompt | 8 | 0.884 | 0.82 | **0.88** | Lighting +0.06 — but grain drops |
| `--raw` toggle | 12 | 0.871 | 0.84 | 0.85 | Confirmed: raw = grain + dark |
| **Editor inpainting** | 13 | 0.860 | 0.86 | 0.79 | New approach — see below |

**Key pivot (iter 8):** Adding "flat shadowless studio lighting" + "completely even soft illumination" and putting `dramatic lighting, side lighting, rim light` in `--no` improved lighting by **+0.06** — the single biggest dimension jump in the session. But the grain sref fought back: it transfers dark, contrasty lighting alongside the grain texture.

#### Editor inpainting — a new tool

After exhausting prompt-level approaches, the system tried MJ's built-in editor to selectively regenerate only the background while preserving the figure's grain:

| Editor mask (background erased) | Editor result (iter 13) |
|:-:|:-:|
| ![Editor mask](docs/examples/flower-head/editor-mask.png) | ![Editor result](docs/examples/flower-head/iter-13-editor.png) |

Smart Select segmented the background cleanly. The prompt was updated to emphasize flat gray backdrop with `--raw` and `--sw` removed. But the regenerated background introduced **walls and corners** instead of flat gray — the preserved figure implied a physical space, so MJ filled in environmental context. A new failure mode was discovered and cataloged.

#### Patterns extracted

The session produced 3 new patterns added to the database:

- **`--raw` = grain vs. lighting toggle** (medium confidence, 3 A/B tests): `--style raw` increases grain fidelity but darkens the image. No single-prompt solution exists for maximizing both.
- **Editor environmental intrusion** (low confidence, 1 test): MJ's inpainting adds walls/surfaces when regenerating backgrounds around a preserved figure, even when the prompt says "seamless backdrop."
- **Editor grain mismatch** (low confidence, 1 test): Regenerated areas have different grain character than sref-assisted preserved areas, creating a visible texture split.

**Final result:** Session closed at **0.90** (iter 4, img-1). The 0.93 target was identified as unreachable with current techniques — the grain-vs-lighting tradeoff is a real ceiling for this subject/reference combination, not a prompt problem to solve. That honest identification is itself valuable: future sessions with similar tradeoffs can skip 10 iterations of dead ends.

---

### Album Cover Aesthetic — Self-Referencing Sref Breakthrough

**Goal:** Reproduce the Tame Impala *Currents* album cover aesthetic — a chrome sphere on a plane of warped parallel lines with op-art moiré, deep amethyst purple palette, and a bold coral-to-orange diagonal streak. The style involves precise mathematical linework, specific color relationships, and compositional choices that are hard to describe in words alone. This session was designed to demonstrate that prompt-only engineering has a ceiling, and `--sref` with tuned parameters breaks through it.

| Reference | Iter 1 — First Attempt (0.65) | Iter 3 — Prompt Ceiling (0.69) | Iter 4 — Sref Fail (0.55) | Iter 6 — Breakthrough (0.75) |
|:-:|:-:|:-:|:-:|:-:|
| ![Reference](docs/examples/album-cover/reference.jpg) | ![Iter 1](docs/examples/album-cover/iter-01-best.png) | ![Iter 3](docs/examples/album-cover/iter-03-best.png) | ![Iter 4](docs/examples/album-cover/iter-04-sref-fail.png) | ![Iter 6](docs/examples/album-cover/iter-06-best.png) |

#### Phase 1: Prompt-only (iter 1-3) — establishing the ceiling

The system queried the knowledge base and constructed a prompt using effective keywords: "op-art moiré," "hairline-thin parallel lines," "deep amethyst purple," `--style raw` for precision. Three iterations of refinement:

- **Iter 1 (0.60):** Core concept captured — sphere, lines, streak — but lines too thick, color too red-orange, too much 3D landscape depth instead of flat illustration.
- **Iter 2 (0.56):** Added "flat vector illustration" and "ultra-fine hairline-thin" — lines dramatically finer (+0.20 material) and purple more dominant (+0.10 color), but MJ lost the ground plane entirely (-0.30 composition). "Flat vector" + "sphere" = isolated globe floating in space.
- **Iter 3 (0.67):** Merged best of both. Kept "hairline-thin" for fineness, restored ground plane with "resting on an infinite flat plane" + "receding to a distant horizon." **Prompt-only ceiling established at 0.67.**

The problem: every word added to fix one dimension destabilized another. Fixing line fineness broke composition. Adding spatial context diluted the color palette. Words alone couldn't hold all 7 dimensions simultaneously.

#### Phase 2: Sref experiments (iter 4-7) — failure, pivot, breakthrough

**Iter 4 — Album cover as sref (0.53):** Uploaded the Currents album cover as `--sref`, added `--sw 100`. **Major regression.** MJ produced photorealistic 3D renders — chrome balls on marble surfaces. The album cover's professional production quality (text overlays, polish, commercial packaging) signaled "high production value" to MJ, which it interpreted as photorealism. The illustration content was ignored.

**Iter 5 — Higher sw (0.47):** Increased `--sw 200` hoping to force more style transfer. Even worse — higher style weight amplified the wrong signal.

**Iter 6 — Self-referencing sref (0.75): THE BREAKTHROUGH.** Instead of the album cover, the system used its own best output (iter 3 img 3) as `--sref`. Clicked "Style" on the image detail page to set it as a style reference. Combined with `--style raw` and `--sw 100`.

Result: **All 7 dimensions improved simultaneously.** Batch average jumped from 0.67 to 0.72, best image hit 0.75. The self-generated sref transferred exactly the right qualities — illustration style, line character, color palette — because it already had them.

**Iter 7 — Vary Subtle (0.73):** Confirmed the plateau. Vary Subtle maintained quality but didn't push further. Session closed.

| Phase | Iters | Best Score | Batch Avg | What It Proved |
|-------|-------|-----------|-----------|----------------|
| Prompt-only | 1-3 | 0.69 | 0.67 | Ceiling — words can't hold all 7 dimensions |
| Album cover sref | 4-5 | 0.55 | 0.50 | Professional images trigger photorealism trap |
| **Self-referencing sref** | 6-7 | **0.75** | **0.72** | Use your own best output as sref |

#### The key insight: sref source matters more than sref weight

The album cover and the best prompt-only output depicted the *same aesthetic*. But MJ read them completely differently:

- **Album cover** → "professional commercial product" → photorealism
- **Own generated output** → "illustration with these specific qualities" → illustration enhanced

`--sw` amplified whatever the source signaled. Higher weight on a bad source made things worse. The fix wasn't parameter tuning — it was changing the source.

#### Patterns extracted

The session produced 4 new patterns added to the database:

- **Self-referencing sref** (low confidence, 1 session): When the original reference pushes MJ toward the wrong style, use your own best generated output as `--sref` instead. It transfers exactly the qualities you've already achieved.
- **Professional image sref trap** (low confidence, 1 session): Album covers, magazine spreads, and other commercially-produced images signal "high production value" → photorealism, even when their visual content is illustration or graphic design.
- **`--style raw` + `--sref` interaction is source-dependent** (low confidence, 1 session): `--raw` blocks MJ's interpretive layer. This hurts when sref needs interpretation (album cover → lost the illustration style) but helps when sref already has the right qualities (self-reference → blocked photorealistic tendencies).
- **Prompt-only ceiling for complex illustration** (low confidence, 1 session): Styles requiring precision across multiple dimensions (linework, color, composition) hit ~0.65-0.70 with words alone. Each keyword addition destabilizes other dimensions.

**Final result:** Session closed at **0.75** (iter 6, img-3). The self-referencing sref technique — a feedback loop where your own best output becomes the style reference for the next attempt — was the session's primary contribution to the knowledge base.

---

### Style Code Exploration — Same Prompt, Different Worlds

**Goal:** Demonstrate how `--sref random` and style code blending transform a single portrait prompt into radically different aesthetics. The prompt stays constant — the style code is the only variable. This session is about discovery and cataloging, not iterative refinement.

| Code `4255542556` | Code `3738472169` | Code `3406712833` | Blend `4255::2 3738::1` |
|:-:|:-:|:-:|:-:|
| ![Dark graphic novel](docs/examples/portrait-codes/code-4255542556.png) | ![Fashion editorial](docs/examples/portrait-codes/code-3738472169.png) | ![B&W gothic](docs/examples/portrait-codes/code-3406712833.png) | ![Hybrid blend](docs/examples/portrait-codes/blend-result.png) |
| Dark graphic novel | Bright fashion editorial | High-contrast B&W gothic | Illustrated-photographic hybrid |

**The prompt (identical across all 4):**
```
Cinematic close-up portrait of a woman with sharp cheekbones, dramatic side lighting,
looking directly at camera, moody atmosphere --ar 2:3 --sref [code] --stylize 75
```

#### How `--sref random` works

Each generation with `--sref random` assigns a unique numeric style code. MJ draws from its internal style space — you don't choose the aesthetic, you discover it. The code is permanent and reusable: once you find one you like, you can apply it to any future prompt.

Three random rolls produced three completely different aesthetics from the same words:

| Code | Aesthetic | Key Characteristics |
|------|-----------|-------------------|
| `4255542556` | Dark graphic novel | Heavy ink outlines, desaturated palette, comic-book shading, visible crosshatching |
| `3738472169` | Fashion editorial | Vivid teal-orange color grade, luminous skin, editorial lighting, magazine quality |
| `3406712833` | B&W gothic film | High-contrast monochrome, heavy film grain, noir atmosphere, textured grain overlay |

#### Blending codes with weights

Style codes can be combined with weighted ratios. `--sref 4255542556::2 3738472169::1` blends the graphic novel aesthetic (2x weight) with the fashion editorial look (1x weight):

- The ink-line quality from the graphic novel code survived but softened
- The fashion editorial's teal-orange tones warmed the palette
- Skin rendering split the difference — more detailed than pure comic art, more stylized than pure editorial
- The result was a hybrid that neither code would produce alone

#### What the system cataloged

Each style code was recorded in the keyword effectiveness database with its aesthetic profile, suggested use cases, and `--sw` recommendations. Future sessions can query this catalog:

```sql
SELECT keyword, actual_effect, notes FROM keyword_effectiveness
WHERE context = 'style-code' AND effectiveness = 'excellent'
```

This is a different kind of learning — not "which keywords work" but "which aesthetic spaces exist." The system builds a palette of reusable style codes alongside its keyword and pattern knowledge, giving it three tools for prompt construction: words, patterns, and codes.

**Final result:** 4 iterations, 3 new style codes cataloged, 1 blend tested. No single "best score" — each code produced a valid interpretation. The session's value was breadth of discovery, not depth of refinement.

---

### Looping Animation — What Survives Motion

**Goal:** Generate an abstract form optimized for seamless looping animation, then test MJ's Loop animation with both Low and High Motion to discover what makes a good animation source image. This was the system's first animation session — everything about the workflow had to be figured out live.

| Source Image (0.91) | Alternate (Orbital Bands) | Loop Low Motion | Loop High Motion |
|:-:|:-:|:-:|:-:|
| ![Plasma torus](docs/examples/animation/source-torus.png) | ![Orbital bands](docs/examples/animation/source-orbital.png) | ![Low motion](docs/examples/animation/loop-low-motion.png) | ![High motion](docs/examples/animation/loop-high-motion.png) |

**The prompt:**
```
luminous abstract organic torus, smooth flowing form with radial symmetry,
soft iridescent surface catching light, glowing from within, centered on
pure black void, hypnotic meditative energy
--ar 1:1 --s 100 --style raw
--no text, subject, person, figure, landscape, horizon, background detail,
    ground, floor, texture, grain, noise, pattern
```

#### Why this prompt structure works for animation

The system had zero animation patterns in its database — coverage score was 0.18. Community research filled the gap: symmetrical forms on clean backgrounds loop best, internal glow gives MJ something to animate, and heavy `--no` lists prevent background detail that creates jarring motion artifacts.

Key design choices:
- **Radial symmetry** — the start and end frames of a loop need to match. Symmetric forms have more "paths back" to their starting state.
- **Pure black void** — no background detail means no background to warp. The form floats in darkness, and only the form moves.
- **`--style raw`** — prevents MJ from adding its own aesthetic interpretation, keeping the source clean and predictable.
- **Heavy `--no` list** — 14 excluded terms. Every excluded element is one less thing that could create distracting motion.

#### The animation comparison

The batch scored 0.894 average across all 4 images — unusually high for a first attempt, because the knowledge base already had strong abstract/lighting/composition patterns even though animation-specific data was missing. Image 1 (plasma torus, 0.911) was selected for animation testing.

| Setting | What Happened | Form Preserved? |
|---------|--------------|-----------------|
| **Loop Low Motion** | Plasma filaments flow gently, inner glow pulses, torus shape stays completely intact | Yes — identical silhouette throughout |
| **Loop High Motion** | Torus stretched, warped, and partially dissolved. Original form barely recognizable | No — dramatic deformation |

**Low Motion** treats the source image as a constraint: "animate this, but keep it." The torus breathes — plasma filaments drift, light shifts — but the circular form never breaks. Perfect for loops where shape identity matters.

**High Motion** treats the source as a starting suggestion: "start here, then go wherever." The torus is pulled apart, stretched into ribbons, reformed into something different. Visually dramatic, but the loop seam is visible because start and end states diverge too far.

#### What the system learned (first animation patterns)

Three patterns were extracted and added to the database — the beginning of an animation knowledge category:

- **Loop Low Motion = form-preserving** — Ideal for abstract loops, geometric subjects, brand animations. The source shape is a hard constraint.
- **Loop High Motion = dramatic deformation** — Better for cinematic one-shots or abstract art where transformation is the point. Not for seamless loops.
- **Animation source image recipe** — Radial symmetry + clean black background + internal glow + centered composition + heavy `--no` list + `--style raw`. This combination scored 0.911 as a still and produced excellent animation.

**Other discoveries:** Animation generates 4 video variations (index 0-3), costs ~8x a regular generation, and produces 5-second clips. The video polling workflow (navigate to job page, check for `<video>` element) was documented in `rules/auto-core-workflows.md` for future sessions.

---

### Multi-Reference Particles — Folder of Animation Frames to Still Image

**Goal:** Reproduce the aesthetic of a website hero animation from 4 reference screenshots — not a single image, but a folder of frames showing the same organic particle form in different states. Tests composite reference analysis (shared vs. variable qualities) and whether MJ can render particle-constructed forms rather than solid surfaces.

| Reference (1 of 4) | Iter 1 — Warm (0.87) | Iter 2 — Color Fix (0.91) | Iter 3 — Final (0.92) |
|:-:|:-:|:-:|:-:|
| ![Reference](docs/examples/hero-particles/reference-composite.png) | ![Iter 1](docs/examples/hero-particles/iter1-warm-gold.png) | ![Iter 2](docs/examples/hero-particles/iter2-color-corrected.png) | ![Iter 3](docs/examples/hero-particles/iter3-final.png) |

#### The multi-reference challenge

The 4 references were screenshots from the Auros website hero — an animated particle visualization cycling through different forms: concentric contour lines, a swirling particle vortex, flowing smoke tendrils, and a translucent membrane. No single frame captures the target. The system had to identify what was *shared* across all 4 (the aesthetic) vs. what *varied* (the animation state):

| Shared (target aesthetic) | Variable (animation states) |
|---------------------------|----------------------------|
| Pure black background | Contour lines vs. particle cloud vs. smoke vs. membrane |
| Centered circular/spherical form | Sparse vs. dense vs. flowing vs. solid |
| Monochrome white/gray palette | Flat 2D vs. volumetric 3D |
| Particle/filament construction, never solid surfaces | Subtle vs. noticeable warm gold accents |
| Self-luminous, dark center void | |

#### What happened: 3 iterations, one targeted fix

**Iter 1 (0.873 batch avg):** The composite analysis translated directly to a prompt-only approach using tested patterns — "pure black canvas," "high contrast," heavy `--no` list, "3D particle simulation render" as style anchor. MJ produced particle-constructed spheres with dark center voids on first attempt. But the prompt's "subtle warm gold edge highlights" was over-delivered — all 4 images had too much amber/gold vs. the neutral white references.

**Iter 2 (0.896 batch avg):** Single targeted fix. Removed the warm gold language, added "monochrome neutral white," and put `warm, amber, gold, orange, yellow` in `--no`. Color scores jumped **+0.115** across the batch. Everything else held.

**Iter 3 — Vary Subtle (0.904 batch avg):** Polished the best image. An orbital ring structure emerged in one variation, adding structural depth that bridged between the reference frames. Best single image: **0.917**.

#### Why multi-reference worked

The composite reference analysis correctly distilled 4 diverse frames into a single target aesthetic. The shared qualities became the prompt's backbone; the variable qualities were ignored (they're animation states, not style). The prompt-only approach was sufficient — no `--sref` needed — because the shared qualities (particles on black, self-luminous, center void) mapped cleanly to keywords with known effectiveness data from previous abstract sessions.

#### Patterns applied (from knowledge base)

- `auto-pure-black-canvas-contrast` — "pure black canvas" + "high contrast" for figure-ground
- `auto-floating-void-isolation` — isolation language for centered forms
- `auto-heavy-no-list-abstract` — 20+ term `--no` list for abstract output
- `auto-no-warm-colors-blocks-contamination` — warm color blocking in `--no` (validated again here)

**Final result:** 0.917 best score in 3 iterations. The multi-reference workflow — point at a folder, extract shared aesthetic, prompt from the composite — worked cleanly on its first real test.

---

## Getting Started

### Level 1: Core Only (no setup)

The `core-*` rules work standalone — reference analysis, prompt construction, scoring, and iteration strategy. Copy prompts to Midjourney manually.

### Level 2: Core + Learning

Add persistent pattern tracking across sessions.

```bash
# Install the sqlite MCP server
claude mcp add sqlite-simple -- npx @anthropic-ai/sqlite-simple-mcp mydatabase.db

# Initialize the database
sqlite3 mydatabase.db < schema.sql
```

### Level 3: Full Automation

Add browser control for hands-free iteration. The system submits prompts to midjourney.com, waits for generation, captures all 4 images, scores them, and recommends the next action.

```bash
# Add the playwright MCP server
claude mcp add playwright -- npx @playwright/mcp@latest --headed
```

Log in manually on first use — cookies persist after that.

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- A Midjourney subscription
- Node.js (for MCP servers, Level 2+)
- SQLite3 CLI (for database setup, Level 2+)

## Commands

| Command | Purpose |
|---------|---------|
| `/new-session` | Start a new session with full knowledge application |
| `/log-iteration` | Log a generation attempt with scoring and gap analysis |
| `/reflect` | Cross-session pattern analysis and knowledge extraction |
| `/research [focus]` | Research community techniques for a specific challenge |
| `/show-knowledge [category]` | Display learned patterns |
| `/apply-knowledge <desc>` | Get pattern-informed prompt for a description |
| `/discover-styles` | Browse and catalog MJ style codes from the Style Explorer |
| `/validate-pattern [id]` | Mark a pattern as validated or contradicted |
| `/forget-pattern [id]` | Deactivate a pattern |

## Architecture

Compatible with the [Vercel agent-skills](https://github.com/vercel/agent-skills) format.

<details>
<summary>Repository structure</summary>

```
.
├── SKILL.md                     # Skill definition and entry point
├── CLAUDE.md                    # Claude Code router
├── AGENTS.md                    # Compiled full reference (auto-generated from rules/)
├── schema.sql                   # Database setup (6 tables)
├── rules/
│   ├── core-reference-analysis.md   # 7-element visual framework
│   ├── core-prompt-construction.md  # V7 prompt structure, keyword practices
│   ├── core-research-phase.md       # Coverage assessment, community research
│   ├── core-assessment-scoring.md   # 7-dimension scoring guide
│   ├── core-iteration-framework.md  # Gap analysis, action decisions
│   ├── learn-data-model.md          # Database schema, session structure
│   ├── learn-pattern-lifecycle.md   # Confidence graduation, decay
│   ├── learn-reflection.md          # Session lifecycle, contrastive analysis
│   ├── auto-core-workflows.md       # Browser automation sequences
│   └── auto-reference-patterns.md   # Selector strategy, error handling
├── knowledge/
│   ├── v7-parameters.md         # MJ V7 parameter reference (static)
│   ├── translation-tables.md    # Visual quality → MJ keyword mappings (static)
│   ├── failure-modes.md         # Diagnostic framework + session-learned failures
│   ├── learned-patterns.md      # Auto-generated pattern summaries
│   └── keyword-effectiveness.md # Auto-generated keyword ratings
├── scripts/build.sh             # Compiles rules/ → AGENTS.md
└── .claude/commands/            # Slash command definitions
```

</details>

<details>
<summary>Rule categories</summary>

| Section | Impact | Prefix | Rules | Dependencies |
|---------|--------|--------|-------|-------------|
| **Core Prompt Engineering** | CRITICAL | `core-` | 5 | None — works standalone |
| **Learning & Reflection** | HIGH | `learn-` | 3 | sqlite MCP server |
| **Browser Automation** | MEDIUM | `auto-` | 2 | playwright MCP server |

</details>

<details>
<summary>Knowledge files</summary>

**Static** (ships with content): `v7-parameters.md`, `translation-tables.md`, `prompt-templates/`, `official-docs.md`

**Dynamic** (populated through use): `learned-patterns.md`, `keyword-effectiveness.md`, `failure-modes.md` (bottom section)

</details>

<details>
<summary>Building AGENTS.md</summary>

```bash
./scripts/build.sh
```

Strips YAML frontmatter from each rule file and concatenates them under section headers.

</details>

## License

MIT
