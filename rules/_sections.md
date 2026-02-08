# Sections

## 1. Core Prompt Engineering

- **Prefix:** `core-`
- **Impact:** CRITICAL
- **Dependencies:** None
- **Description:** Reference analysis, prompt construction, research, scoring, and iteration strategy. These rules form the foundation of the prompt engineering workflow and work standalone without any MCP servers.

## 2. Learning & Reflection

- **Prefix:** `learn-`
- **Impact:** HIGH
- **Dependencies:** sqlite-simple MCP server
- **Description:** Database schema, pattern lifecycle, confidence tracking, and reflection workflows. These rules enable the system to remember what works across sessions and accumulate craft knowledge over time.

## 3. Browser Automation

- **Prefix:** `auto-`
- **Impact:** MEDIUM
- **Dependencies:** playwright MCP server
- **Description:** Playwright-based browser control for midjourney.com. Submit prompts, poll for generation, capture images, and perform actions (upscale, vary) without leaving Claude Code.
