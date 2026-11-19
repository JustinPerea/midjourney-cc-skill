# Midjourney V8 Parameter Reference

*Last verified: November 19, 2026 against docs.midjourney.com (Version, Parameter List, Edit Model, Quality, Stylize, Chaos, Weird, Seed, Style Reference, Personalization, Omni Reference)*

**V8.2 is the current default model.** Where this file and `v7-parameters.md` disagree, this file wins for `--v 8.1` / `--v 8.2` (the default). Use `v7-parameters.md` only when the user explicitly runs `--v 7`.

## Version Timeline

| Version | Released | Default |
|---------|----------|---------|
| V7 | April 3, 2025 | June 17, 2025 - June 9, 2026 |
| V8.0 Alpha | alpha-site only | -- |
| V8.1 | April 14, 2026 | June 10 - July 23, 2026 |
| **V8.2** | July 24, 2026 | **July 24, 2026 - present** |
| Niji 7 | January 9, 2026 | `--niji 7` (separate model, not V8) |

- **V8.1:** fastest model so far (standard jobs ~4-5x faster than earlier versions), better prompt reading, holds small details. Adds HD (2K) output. `--raw` removes default styling for extra adherence.
- **V8.2:** aesthetics, image quality and personalization update. Images are more creative/bold/edgy; fewer random low-quality results; personalization "understands" taste better. Ships the **Edit Model**.

## What Changed From V7 (Breaking)

| Area | V7 | V8.1 / V8.2 |
|------|----|-------------|
| Character / object reference | `--oref` + `--ow` | **Not supported.** Use the Edit Model (`--edit`, up to 4 reference images) |
| `--cref` | Deprecated | Still gone (Edit Model replaces it) |
| Retexture | V6.1 tool | Edit Model |
| Pan / Zoom Out / Editor (inpaint, outpaint) | Run on V6.1 | Run on the Edit Model |
| `--q` quality | 1, 2, 4 | **Not supported** |
| `--draft` | Supported | **Not supported** |
| Turbo mode | Supported | **Not supported** |
| Multi-prompt `::` | Not supported | Not supported |
| Conversational mode | Supported | Supported |
| `--exp` | Supported | Supported |
| Seeds | Seed-stable | "99% identical" |
| Max aspect ratio | 14:1 | 14:1 (**4:1 when HD**) |
| Personalization | Global V7 profile | Global V7 profile works; V8 profiles can be created; no Global V8 profile |
| `--niji` | `--niji 7` | Not available on V8 |

**Practical consequence:** do not put `--q`, `--draft`, `--oref`, `--ow` or `--cref` on a V8 prompt. Drop them or switch approach (see below).

## SD vs HD

- `--sd` -- standard resolution (1024px). `--hd` -- native 2K (2048px) with no upscaling.
- Cost: HD = 1.3 min GPU, SD = 0.8 min GPU.
- HD max aspect ratio is 4:1.
- On web, "Run batch as HD" on an SD V8.1 image re-runs the seed-locked prompt in HD.
- Inpainting/outpainting (Pan, Zoom Out, Edit/Vary Region) on an HD image **downscales the result to SD**; use Upscale to return to HD.
- Draft-then-refine workflow (V7) no longer applies. Iterate in SD, then re-run the winner with `--hd`.

## Edit Model (`--edit`)

The Edit Model is how V8.1/V8.2 does references and edits. It has three modes:

1. **Instruction edits** on an existing image ("make the sky overcast").
2. **Reference-driven generation** with up to **4** reference images (replaces Omni Reference and Character Reference).
3. **Editor** inpainting/outpainting.

Compatible with: Image Prompts, Style References (`--sref`), Moodboards, Personalization, `--hd`, `--raw`.
Not compatible with: `--tile`. Edit Model results cannot be Remixed.

### Prompting the Edit Model

- **Instructions are allowed.** Unlike normal prompts (describe the scene, don't give orders), Edit prompts can be imperative, like Conversational mode: `make this silver knight ride the horse of fire holding the sword of flowers`.
- **Aspect ratio** auto-matches the *first* uploaded image. Your default AR setting does not apply; add `--ar` to override.
- **Multiple characters:** if attributes bleed between characters, merge the characters into one reference image.
- **Perspective changes:** `let's see this image from behind`.
- **Retexture / restyle:** `hand drawn pencil sketch of this image --sref 2708276657`. Describe the style in the prompt as well as in `--sref`/moodboard so the aesthetic activates consistently.
- **`--raw`** reduces Midjourney's added flair so the prompt text has more influence.

### Migrating V7 reference prompts

| V7 | V8.1 / V8.2 |
|----|-------------|
| `a person walking through Tokyo --oref URL --ow 200` | Attach the person as an Edit Model reference image; write `this person walking through Tokyo`. No weight parameter |
| `--cref URL` | Edit Model reference image |
| Retexture tool | Edit Model + `--sref` / moodboard |
| Pan / Zoom Out | Edit Model / Editor |

## Parameters That Still Work

| Parameter | Range / Default | Notes |
|-----------|-----------------|-------|
| `--ar` | up to 14:1 (4:1 with HD) | Edit Model inherits first image's AR |
| `--stylize` / `--s` | 0-1000, default 100 | |
| `--chaos` / `--c` | 0-100, default 0 | Called "Variety" on web |
| `--weird` / `--w` | 0-3000, default 0 | Experimental; not fully seed-compatible |
| `--raw` | flag | Removes default styling; recommended for max prompt adherence |
| `--exp` | -- | Supported in V8.1/V8.2 |
| `--seed` | 0-4294967295 | ~99% reproducible in V8.X; avoid Turbo (unsupported in V8 anyway) |
| `--no` | comma-separated terms | Each word moderated independently (`--no modern clothing` reads as "no clothing") |
| `--tile` | flag | Single tile only; not compatible with Edit Model |
| `--sref` | URL or code | Compatible with V6+; `--sw` 0-1000, default 100; `--sv` selects version |
| `--iw` | -- | Image prompt weight; Image Prompts supported |
| `--p` | profile ID / code | See Personalization below |
| `--repeat` / `--r` | -- | Unchanged |
| `--video`, `--motion`, `--loop`, `--end`, `--bs` | -- | Video parameters (Discord) |
| `--fast`, `--relax`, `--turbo` | -- | Fast and Relax supported; Turbo **not** supported in V8.1/V8.2 |
| `--stealth`, `--public` | -- | Privacy |
| `--sd`, `--hd` | -- | V8.1+ only |
| `--edit` | -- | V8.1+ only |

Parameter placement rules (unchanged): parameters go **last**, one space before each `--`, no punctuation inside parameters, no prompt text after parameters.

## Personalization in V8

- Your **Global V7 Profile works in V8.1 and V8.2**. You may need to unlock it first.
- You can create additional **V8.X profiles**; there is no Global V8 Profile yet.
- V8 profiles are **not compatible with V7**.
- V8.2 uses a larger, improved image pool when creating profiles, and understands taste better on profiles with many ratings.
- Personalization silently biases output toward the user's taste. For reproducible prompt-engineering sessions, disable it (see `rules/auto-core-workflows.md`).

## Prompting Notes for V8

- Keep the V7 baseline: short, natural-language prompts, front-load the subject. V8.1 reads prompts and small details better; add `--raw` when you need adherence over aesthetics.
- Style references and style codes are unchanged. Keep the text prompt about *content*, not instructions, when using `--sref` on a normal (non-Edit) prompt.
- Moodboards and Remix still work (Remix not on Edit Model results).

## Unverified / Open Items

These could not be confirmed from the official docs and should be checked on a live V8.2 session before relying on them:

- Whether `--q` is truly ignored/rejected in V8 (the version chart marks it unsupported; the Quality article still documents V7 values only).
- Exact effect of `--stylize` defaults on V8.2 vs V7 (docs give 0-1000 / default 100 "with the latest versions").
- Whether V7-era `--sv` codes and the `--sw` style-code behavior note ("more impact with codes than images") still hold for V8.
- Video model parameters on V8.2 (Edit-model start frames etc.).
- The V8.1 Alpha announcement post (`updates.midjourney.com/v8-1-alpha/`) is private and could not be read.

## Sources

- Version: https://docs.midjourney.com/hc/en-us/articles/32199405667853-Version
- Parameter List: https://docs.midjourney.com/hc/en-us/articles/32859204029709-Parameter-List
- Edit Model: https://docs.midjourney.com/hc/en-us/articles/48495453462797-Edit-Model
- Personalization: https://docs.midjourney.com/hc/en-us/articles/32433330574221-Personalization
- Omni Reference (V7 only): https://docs.midjourney.com/hc/en-us/articles/36285124473997-Omni-Reference
- Version 8.2 announcement: https://www.midjourney.com/updates/version-8-2
