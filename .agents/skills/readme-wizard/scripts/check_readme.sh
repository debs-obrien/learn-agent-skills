#!/usr/bin/env bash
# check_readme.sh — Validate a generated README has all expected sections.
# Usage: bash check_readme.sh /path/to/README.md

set -euo pipefail

README="${1:-}"

if [[ -z "$README" ]]; then
  echo "Usage: check_readme.sh <path-to-README.md>"
  exit 1
fi

if [[ ! -f "$README" ]]; then
  echo "Error: '$README' not found"
  exit 1
fi

CONTENT=$(cat "$README")
PASS=0
FAIL=0

check() {
  local label="$1"
  local pattern="$2"

  if echo "$CONTENT" | grep -qiE "$pattern"; then
    echo "  ✅ $label"
    PASS=$((PASS + 1))
  else
    echo "  ❌ $label"
    FAIL=$((FAIL + 1))
  fi
}

echo ""
echo "📋 README Validation Report"
echo "   File: $README"
echo "   ────────────────────────────"
echo ""

echo "Headings:"
check "Project title (H1)"          "^#[^#]"
check "What is this / About"        "^##.*([Ww]hat is|[Aa]bout)"
check "Quick Start / Getting Started" "^##.*(Quick Start|Getting Started|Installation|Setup)"
check "Project Structure"           "^##.*([Pp]roject [Ss]tructure|[Ff]older [Ss]tructure)"
check "Documentation"               "^##.*[Dd]ocumentation"
check "Contributing"                "^##.*[Cc]ontributing"
check "License"                     "^##.*[Ll]icense"
echo ""

echo "Badges:"
check "shields.io badges"           "img\.shields\.io"
check "for-the-badge style"         "style=for-the-badge"
echo ""

echo "Code blocks:"
check "Code blocks present"         '```'
echo ""

echo "Project structure:"
check "File tree (├ or └)"          "[├└│]"
echo ""

echo "Docs table:"
check "Markdown table"              "\|.*\|"
echo ""

echo "Contributing:"
check "contrib.rocks avatars"       "contrib\.rocks"
echo ""

echo "Social links:"
# Social links are optional — only check if at least one social badge/link is present
if echo "$CONTENT" | grep -qiE "(youtube|discord|twitter|x\.com|linkedin|bluesky|twitch)"; then
  check "Social badges or links"      "(youtube|discord|twitter|x\.com|linkedin|bluesky|twitch)"
else
  echo "  ⏭️  No social links (skipped — this is fine if the project has none)"
fi
echo ""

echo "Footer:"
check "Star history chart"          "star-history"
echo ""

TOTAL=$((PASS + FAIL))
echo "   ────────────────────────────"
echo "   Results: $PASS/$TOTAL passed"
echo ""

if [[ $FAIL -eq 0 ]]; then
  echo "   🎉 All checks passed!"
else
  echo "   ⚠️  $FAIL check(s) failed"
fi
echo ""

exit $FAIL
