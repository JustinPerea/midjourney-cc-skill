#!/usr/bin/env bash
# Compiles rules/ directory into AGENTS.md
# Usage: ./scripts/build.sh

set -euo pipefail

RULES_DIR="$(dirname "$0")/../rules"
OUTPUT="$(dirname "$0")/../AGENTS.md"

# Section order and headers
declare -a SECTIONS=(
  "core:Core Prompt Engineering"
  "learn:Learning & Reflection"
  "auto:Browser Automation"
)

{
  echo "# Midjourney Prompt Learning System — Complete Reference"
  echo ""
  echo "> Auto-generated from rules/ directory. Do not edit directly."
  echo "> Regenerate with: ./scripts/build.sh"
  echo ""
  echo "---"

  for section in "${SECTIONS[@]}"; do
    prefix="${section%%:*}"
    header="${section#*:}"

    echo ""
    echo "# ${header}"
    echo ""

    # Process rule files in alphabetical order within each section
    for rule_file in "${RULES_DIR}/${prefix}-"*.md; do
      [ -f "$rule_file" ] || continue

      # Strip YAML frontmatter (everything between first --- and second ---)
      awk '
        BEGIN { in_frontmatter=0; frontmatter_done=0; first_line=1 }
        /^---$/ && first_line { in_frontmatter=1; first_line=0; next }
        /^---$/ && in_frontmatter { in_frontmatter=0; frontmatter_done=1; next }
        in_frontmatter { next }
        frontmatter_done || !first_line { first_line=0; print }
      ' "$rule_file"

      echo ""
      echo "---"
    done
  done
} > "$OUTPUT"

echo "Generated $(wc -l < "$OUTPUT" | tr -d ' ') lines → $OUTPUT"
