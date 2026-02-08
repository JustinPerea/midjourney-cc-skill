# Official Midjourney Documentation Reference

*Last verified: February 7, 2026*

## Purpose

This file maps official Midjourney documentation to our internal knowledge files. Use it to:

- **Check sources** when uncertain about a feature — navigate to the URL if Playwright is available
- **Identify gaps** in our coverage (marked with `GAP` below)
- **Detect staleness** after MJ updates — compare doc content to our knowledge files
- **Direct users** to official docs for features outside our scope

## How to Use

1. Find the relevant topic below
2. Check "Our Coverage" to see which internal file covers it
3. If coverage is missing or you're unsure our info is current, open the URL via Playwright
4. If the official docs differ from our knowledge, update the internal file and bump "Last verified" above

## Documentation Map

Base URL: `https://docs.midjourney.com/hc/en-us/articles/`

### Prompting Basics

| Page | Article ID | Our Coverage | Status |
|------|-----------|-------------|--------|
| Prompt Basics | [32023408776205](https://docs.midjourney.com/hc/en-us/articles/32023408776205) | knowledge/v7-parameters.md (Prompt Structure) | Covered |
| Modifying Your Creations | [33329329805581](https://docs.midjourney.com/hc/en-us/articles/33329329805581) | knowledge/v7-parameters.md (Variations, Upscalers) | Covered |
| Aspect Ratio | [31894244298125](https://docs.midjourney.com/hc/en-us/articles/31894244298125) | knowledge/v7-parameters.md (--ar) | Covered |
| Image Size & Resolution | [33329374594957](https://docs.midjourney.com/hc/en-us/articles/33329374594957) | knowledge/v7-parameters.md (Upscalers) | Partial |
| Art of Prompting | [32835253061645](https://docs.midjourney.com/hc/en-us/articles/32835253061645) | rules/core-prompt-construction.md | `GAP` — may contain prompt techniques we haven't captured |

### Using Your Own Images

| Page | Article ID | Our Coverage | Status |
|------|-----------|-------------|--------|
| Video | [37460773864589](https://docs.midjourney.com/hc/en-us/articles/37460773864589) | knowledge/v7-parameters.md (Video/Animation) | Covered |
| Image Prompts | [32040250122381](https://docs.midjourney.com/hc/en-us/articles/32040250122381) | knowledge/v7-parameters.md (Image Prompts) | Covered |
| Style Reference | [32180011136653](https://docs.midjourney.com/hc/en-us/articles/32180011136653) | knowledge/v7-parameters.md + rules/core-prompt-construction.md (Style Codes) | Covered |
| Omni Reference | [36285124473997](https://docs.midjourney.com/hc/en-us/articles/36285124473997) | knowledge/v7-parameters.md (--oref) | Covered |
| Character Reference | [32162917505293](https://docs.midjourney.com/hc/en-us/articles/32162917505293) | knowledge/v7-parameters.md (noted as deprecated) | Covered — legacy only |
| Describe | [32497889043981](https://docs.midjourney.com/hc/en-us/articles/32497889043981) | knowledge/v7-parameters.md (Describe) | Covered |
| Editor | [32764383466893](https://docs.midjourney.com/hc/en-us/articles/32764383466893) | knowledge/v7-parameters.md (Editor) | Covered |
| Managing Image Uploads | [33329380893325](https://docs.midjourney.com/hc/en-us/articles/33329380893325) | — | `GAP` — upload management, lock icon, image panel |

### Using the Website

| Page | Article ID | Our Coverage | Status |
|------|-----------|-------------|--------|
| Website Overview | [33329460426765](https://docs.midjourney.com/hc/en-us/articles/33329460426765) | — | Not needed for prompting |
| Creating on Web | [33390732264589](https://docs.midjourney.com/hc/en-us/articles/33390732264589) | rules/auto-core-workflows.md | Partial — we automate web creation |
| Organizing Your Creations | [33329462451469](https://docs.midjourney.com/hc/en-us/articles/33329462451469) | — | Not needed for prompting |
| Using Folders | [34580542725645](https://docs.midjourney.com/hc/en-us/articles/34580542725645) | — | Not needed for prompting |
| Draft & Conversational Modes | [35577175650957](https://docs.midjourney.com/hc/en-us/articles/35577175650957) | knowledge/v7-parameters.md (Draft Mode) | Partial — `GAP` on Conversational Mode |
| Personalization | [32433330574221](https://docs.midjourney.com/hc/en-us/articles/32433330574221) | knowledge/v7-parameters.md (--p, Profiles) | Covered |
| Moodboards | [39193335040013](https://docs.midjourney.com/hc/en-us/articles/39193335040013) | — | `GAP` — curated style collections, incompatible with --sw and --sv |
| Style Creator | [41308374558221](https://docs.midjourney.com/hc/en-us/articles/41308374558221) | — | `GAP` — tool for creating custom style codes |
| Profiles | [41117938447629](https://docs.midjourney.com/hc/en-us/articles/41117938447629) | — | `GAP` — V7 vs V6 profiles, profile codes |
| Complete Tasks | [33390759197197](https://docs.midjourney.com/hc/en-us/articles/33390759197197) | — | Not needed for prompting |
| Transitioning to Web | [41268334793613](https://docs.midjourney.com/hc/en-us/articles/41268334793613) | — | Not needed (Discord migration guide) |

### Midjourney Controls (Parameters)

| Page | Article ID | Our Coverage | Status |
|------|-----------|-------------|--------|
| Parameter List | [32859204029709](https://docs.midjourney.com/hc/en-us/articles/32859204029709) | knowledge/v7-parameters.md | Covered |
| Chaos / Variety | [32099348346765](https://docs.midjourney.com/hc/en-us/articles/32099348346765) | knowledge/v7-parameters.md (--c) | Covered |
| Legacy Features | [33329788681101](https://docs.midjourney.com/hc/en-us/articles/33329788681101) | — | Low priority — deprecated features |
| Multi-Prompts & Weights | [32658968492557](https://docs.midjourney.com/hc/en-us/articles/32658968492557) | knowledge/v7-parameters.md (noted as V7-incompatible) | Covered |
| No | [32173351982093](https://docs.midjourney.com/hc/en-us/articles/32173351982093) | knowledge/v7-parameters.md (--no) | Covered |
| Pan | [32570788043405](https://docs.midjourney.com/hc/en-us/articles/32570788043405) | knowledge/v7-parameters.md (Pan) | Covered |
| Permutations | [32761322355597](https://docs.midjourney.com/hc/en-us/articles/32761322355597) | knowledge/v7-parameters.md (Permutations) | Covered |
| Quality | [32176522101773](https://docs.midjourney.com/hc/en-us/articles/32176522101773) | knowledge/v7-parameters.md (--q) | Covered |
| Raw Mode | [32634113811853](https://docs.midjourney.com/hc/en-us/articles/32634113811853) | knowledge/v7-parameters.md (--style raw) | Covered |
| Remix | [32799074515213](https://docs.midjourney.com/hc/en-us/articles/32799074515213) | knowledge/v7-parameters.md (Remix Mode) | Partial |
| Repeat | [32757107922061](https://docs.midjourney.com/hc/en-us/articles/32757107922061) | knowledge/v7-parameters.md (--repeat) | Covered |
| Seeds | [32604356340877](https://docs.midjourney.com/hc/en-us/articles/32604356340877) | knowledge/v7-parameters.md (--seed) | Covered |
| Stylize | [32196176868109](https://docs.midjourney.com/hc/en-us/articles/32196176868109) | knowledge/v7-parameters.md (--s) | Covered |
| Text Generation | [32502277092109](https://docs.midjourney.com/hc/en-us/articles/32502277092109) | knowledge/v7-parameters.md (Text Generation) | Covered |
| Tile | [32197978340109](https://docs.midjourney.com/hc/en-us/articles/32197978340109) | knowledge/v7-parameters.md (--tile) | Covered |
| Upscalers | [32804058614669](https://docs.midjourney.com/hc/en-us/articles/32804058614669) | knowledge/v7-parameters.md (Upscalers) | Covered |
| Variations | [32692978437005](https://docs.midjourney.com/hc/en-us/articles/32692978437005) | knowledge/v7-parameters.md (Variations) | Covered |
| Version | [32199405667853](https://docs.midjourney.com/hc/en-us/articles/32199405667853) | knowledge/v7-parameters.md (Version) | Covered |
| Weird | [32390120435085](https://docs.midjourney.com/hc/en-us/articles/32390120435085) | knowledge/v7-parameters.md (--weird) | Covered |
| Zoom Out | [32595476770957](https://docs.midjourney.com/hc/en-us/articles/32595476770957) | knowledge/v7-parameters.md (Zoom Out) | Covered |

## Other Official Resources

| Resource | URL | Relevance |
|----------|-----|-----------|
| Style Explorer | https://www.midjourney.com/explore?tab=styles | Browse/discover style codes |
| Explore Page | https://www.midjourney.com/explore | Community images, trending styles |
| Personalize Page | https://www.midjourney.com/rank | Rank images to unlock --p |

## Gap Summary

Priority gaps to fill (features we reference but don't document well):

1. **Moodboards** — Curated image collections that define a style. Incompatible with `--sw` and `--sv`. Relevant to our style workflow.
2. **Style Creator** — Tool for creating custom style codes. Directly relevant to `/discover-styles`.
3. **Profiles** — V7 vs V6 profile system, profile codes. Interacts with personalization.
4. **Art of Prompting** — Official prompt technique guide. May contain approaches we haven't captured.
5. **Conversational Mode** — AI-assisted prompt writing. Low priority but should note it exists.

## Corrections Found (Feb 7, 2026)

From the Style Reference page, details missing from our knowledge:
- `--sw` has **more impact with sref codes than with images** in V7
- `--sw` is **not compatible with Moodboards**
- `--sv` is **not compatible with Moodboards**
- You **cannot create a style code from an uploaded image** — codes come from the Style Explorer, Style Creator, or `--sref random`
- Rerun/reroll and variations **preserve the style code** from the original prompt
- `--sref random` with permutations or repeat gives **each image a different code**
