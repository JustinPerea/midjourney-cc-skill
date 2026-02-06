# Visual Quality to Prompt Translation Tables

When analyzing reference images, use these tables to map what you see to effective Midjourney keywords.

---

## Lighting Translation

| What You See | Prompt Keywords |
|--------------|-----------------|
| Light from behind subject | backlighting, rim light, silhouette |
| Soft shadows, even light | soft diffused lighting, overcast, softbox |
| Hard shadows, defined edges | harsh directional light, hard light |
| Golden warm tones | golden hour, warm sunlight, amber lighting |
| Cool blue tones | blue hour, cool lighting, moonlight |
| Light from one side | side lighting, Rembrandt lighting |
| Glowing edges | rim glow, edge lighting, backlit |
| Light rays visible | volumetric lighting, god rays, light beams |
| Two-tone colored lighting | dual lighting, [color] key and [color] rim |
| Neon/artificial glow | neon lighting, artificial light, LED glow |

---

## Mood Translation

| What You Feel | Prompt Keywords |
|---------------|-----------------|
| Peaceful, calm | serene, tranquil, peaceful, calm |
| Mysterious | mysterious, enigmatic, shadowy, moody |
| Dramatic, intense | dramatic, cinematic, intense, epic |
| Dreamy, soft | ethereal, dreamy, soft, hazy |
| Dark, ominous | ominous, dark, foreboding, brooding |
| Bright, cheerful | bright, airy, cheerful, vibrant |
| Nostalgic | nostalgic, vintage, retro, memories |
| Futuristic | futuristic, sci-fi, cyberpunk, tech |
| Natural, organic | natural, organic, earthy, raw |
| Luxurious | luxurious, premium, elegant, sophisticated |

---

## Material Translation

| What You See | Prompt Keywords |
|--------------|-----------------|
| See-through, light passes through | translucent, transparent, glass-like |
| Internal glow/color | subsurface scattering, internal glow |
| Mirror-like reflection | reflective, chrome, mirror finish |
| Soft, non-shiny | matte, soft surface, non-reflective |
| Shiny but not mirror | glossy, polished, satin finish |
| Rough surface | textured, rough, tactile surface |
| Smooth surface | smooth, seamless, polished |
| Rainbow surface sheen | iridescent, oil-slick, holographic |
| Distorted view through | refractive, distortion, caustics |

---

## Style Translation

| What You See | Prompt Keywords |
|--------------|-----------------|
| Looks like a photo | photorealistic, photograph, DSLR |
| Looks like 3D software | 3D render, CGI, octane render, Cinema 4D |
| Looks like painting | oil painting, painterly, brushstrokes |
| Looks like digital art | digital art, digital illustration |
| Looks like anime | anime style, anime aesthetic, cel shaded |
| Hyper-detailed | hyperrealistic, ultra detailed, intricate |
| Simplified/minimal | minimal, simplified, clean |
| Film photography look | film photography, analog, grain |
| Studio product shot | product photography, studio lighting |

---

## Composition Translation

| What You See | Prompt Keywords |
|--------------|-----------------|
| Subject fills the frame | close-up, macro, tight framing |
| Subject small in scene | wide shot, vast landscape, epic scale |
| Subject off-center | rule of thirds, subject at [left/right] third |
| Looking down | bird's eye view, top-down, overhead |
| Looking up | low angle, worm's eye view |
| Blurry background | shallow depth of field, bokeh |
| Everything sharp | deep focus, sharp throughout |
| Lots of empty space | negative space, minimal, vast empty [area] |

---

## Dual-Tone Lighting Setups

These create depth and visual interest. Always specify both colors with directions.

| Combination | Prompt Fragment |
|-------------|-----------------|
| Purple + Orange (Classic) | cool purple key light from left, warm orange rim light from right |
| Cyan + Magenta | cyan key light, magenta accent light, neon aesthetic |
| Blue + Gold | cool blue main lighting, warm golden accent highlights |
| Teal + Coral | teal key light, coral warm accents, contemporary |
| Monochrome + Accent | white/grey lighting, single [color] accent rim light |

---

## Style Weight (`--sw`) Guidelines

| Scenario | Starting `--sw` |
|----------|-----------------|
| "Make something like this" | 250-300 |
| "This style but different subject" | 200-250 |
| "Inspired by this" | 100-150 |
| "Match this exactly" | 400+ |

### Balancing with Prompt

```
High --sw (300+) + Simple prompt = Style dominates
Low --sw (100) + Detailed prompt = Prompt dominates
Medium --sw (200) + Detailed prompt = Balanced blend
```
