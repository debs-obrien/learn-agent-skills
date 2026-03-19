#!/usr/bin/env bash
# scan_project.sh — Scan a project directory and output JSON metadata for README generation.
# Usage: bash scan_project.sh /path/to/project

set -euo pipefail

PROJECT_DIR="${1:-.}"

if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "Error: '$PROJECT_DIR' is not a directory" >&2
  exit 1
fi

cd "$PROJECT_DIR"

# ---------- helpers ----------

json_escape() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\t'/\\t}"
  printf '%s' "$s"
}

# ---------- project name & description ----------

PROJECT_NAME=""
DESCRIPTION=""

if [[ -f package.json ]]; then
  PROJECT_NAME=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' package.json | head -1 | sed 's/"name"[[:space:]]*:[[:space:]]*"//;s/"$//')
  DESCRIPTION=$(grep -o '"description"[[:space:]]*:[[:space:]]*"[^"]*"' package.json | head -1 | sed 's/"description"[[:space:]]*:[[:space:]]*"//;s/"$//')
elif [[ -f Cargo.toml ]]; then
  PROJECT_NAME=$(grep -m1 '^name' Cargo.toml | sed 's/name[[:space:]]*=[[:space:]]*"//;s/"$//')
  DESCRIPTION=$(grep -m1 '^description' Cargo.toml | sed 's/description[[:space:]]*=[[:space:]]*"//;s/"$//')
elif [[ -f pyproject.toml ]]; then
  PROJECT_NAME=$(grep -m1 '^name' pyproject.toml | sed 's/name[[:space:]]*=[[:space:]]*"//;s/"$//')
  DESCRIPTION=$(grep -m1 '^description' pyproject.toml | sed 's/description[[:space:]]*=[[:space:]]*"//;s/"$//')
elif [[ -f go.mod ]]; then
  # Go module name is the module path; use the last segment as project name
  MODULE_PATH=$(grep -m1 '^module' go.mod | sed 's/module[[:space:]]*//')
  PROJECT_NAME=$(basename "$MODULE_PATH")
fi

# Fallback: use directory name
if [[ -z "$PROJECT_NAME" ]]; then
  PROJECT_NAME=$(basename "$PWD")
fi

# ---------- license ----------

LICENSE=""
for f in LICENSE LICENSE.md LICENSE.txt; do
  if [[ -f "$f" ]]; then
    # Try to detect the license type from the first few lines
    LICENSE_CONTENT=$(head -5 "$f")
    if echo "$LICENSE_CONTENT" | grep -qi "MIT"; then
      LICENSE="MIT"
    elif echo "$LICENSE_CONTENT" | grep -qi "Apache"; then
      LICENSE="Apache-2.0"
    elif echo "$LICENSE_CONTENT" | grep -qi "GPL"; then
      LICENSE="GPL"
    elif echo "$LICENSE_CONTENT" | grep -qi "BSD"; then
      LICENSE="BSD"
    elif echo "$LICENSE_CONTENT" | grep -qi "ISC"; then
      LICENSE="ISC"
    else
      LICENSE="Found ($f)"
    fi
    break
  fi
done

# ---------- git remote (owner/repo) ----------

OWNER=""
REPO=""

if [[ -d .git ]] || git rev-parse --git-dir &>/dev/null; then
  REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
  if [[ -n "$REMOTE_URL" ]]; then
    # Handle SSH: git@github.com:owner/repo.git
    if [[ "$REMOTE_URL" == git@* ]]; then
      OWNER_REPO=$(echo "$REMOTE_URL" | sed 's/.*://;s/\.git$//')
    # Handle HTTPS: https://github.com/owner/repo.git
    elif [[ "$REMOTE_URL" == https://* ]] || [[ "$REMOTE_URL" == http://* ]]; then
      # Strip protocol and host, then .git suffix
      OWNER_REPO=$(echo "$REMOTE_URL" | sed -E 's|https?://[^/]+/||;s/\.git$//')
    else
      OWNER_REPO=""
    fi

    if [[ -n "$OWNER_REPO" ]]; then
      OWNER=$(echo "$OWNER_REPO" | cut -d'/' -f1)
      REPO=$(echo "$OWNER_REPO" | cut -d'/' -f2)
    fi
  fi
fi

# ---------- package manager ----------

PACKAGE_MANAGER=""
if [[ -f pnpm-lock.yaml ]]; then
  PACKAGE_MANAGER="pnpm"
elif [[ -f yarn.lock ]]; then
  PACKAGE_MANAGER="yarn"
elif [[ -f package-lock.json ]]; then
  PACKAGE_MANAGER="npm"
elif [[ -f bun.lockb ]] || [[ -f bun.lock ]]; then
  PACKAGE_MANAGER="bun"
elif [[ -f Cargo.lock ]]; then
  PACKAGE_MANAGER="cargo"
elif [[ -f Pipfile.lock ]]; then
  PACKAGE_MANAGER="pipenv"
elif [[ -f poetry.lock ]]; then
  PACKAGE_MANAGER="poetry"
elif [[ -f requirements.txt ]]; then
  PACKAGE_MANAGER="pip"
elif [[ -f go.sum ]]; then
  PACKAGE_MANAGER="go"
elif [[ -f go.mod ]]; then
  PACKAGE_MANAGER="go"
elif [[ -f build.gradle ]] || [[ -f build.gradle.kts ]]; then
  PACKAGE_MANAGER="gradle"
elif [[ -f deno.json ]] || [[ -f deno.jsonc ]]; then
  PACKAGE_MANAGER="deno"
fi

# ---------- CI setup ----------

CI_PROVIDER=""
CI_WORKFLOWS="[]"

if [[ -d .github/workflows ]]; then
  CI_PROVIDER="github-actions"
  WORKFLOWS=$(find .github/workflows -name '*.yml' -o -name '*.yaml' 2>/dev/null | sort)
  CI_WORKFLOWS="["
  FIRST=true
  for wf in $WORKFLOWS; do
    if [[ "$FIRST" == true ]]; then
      FIRST=false
    else
      CI_WORKFLOWS+=","
    fi
    CI_WORKFLOWS+="\"$(basename "$wf")\""
  done
  CI_WORKFLOWS+="]"
elif [[ -f .circleci/config.yml ]]; then
  CI_PROVIDER="circleci"
elif [[ -f .travis.yml ]]; then
  CI_PROVIDER="travis"
elif [[ -f .gitlab-ci.yml ]]; then
  CI_PROVIDER="gitlab"
elif [[ -f Jenkinsfile ]]; then
  CI_PROVIDER="jenkins"
fi

# ---------- social links ----------

collect_social_links() {
  local YOUTUBE="" DISCORD="" TWITTER="" LINKEDIN="" BLUESKY="" TWITCH=""

  # Search common files for social URLs
  local SEARCH_FILES=""
  for f in README.md README.rst README readme.md package.json; do
    [[ -f "$f" ]] && SEARCH_FILES+=" $f"
  done

  if [[ -n "$SEARCH_FILES" ]]; then
    YOUTUBE=$(grep -ohiE 'https?://(www\.)?(youtube\.com|youtu\.be)/([@/a-zA-Z0-9_-]+)' $SEARCH_FILES 2>/dev/null | head -1 || echo "")
    DISCORD=$(grep -ohiE 'https?://(www\.)?discord\.(gg|com/invite)/[a-zA-Z0-9_-]+' $SEARCH_FILES 2>/dev/null | head -1 || echo "")
    TWITTER=$(grep -ohiE 'https?://(www\.)?(twitter\.com|x\.com)/[a-zA-Z0-9_]+' $SEARCH_FILES 2>/dev/null | head -1 || echo "")
    LINKEDIN=$(grep -ohiE 'https?://(www\.)?linkedin\.com/(in|company)/[a-zA-Z0-9_-]+' $SEARCH_FILES 2>/dev/null | head -1 || echo "")
    BLUESKY=$(grep -ohiE 'https?://bsky\.app/profile/[a-zA-Z0-9._-]+' $SEARCH_FILES 2>/dev/null | head -1 || echo "")
    TWITCH=$(grep -ohiE 'https?://(www\.)?twitch\.tv/[a-zA-Z0-9_]+' $SEARCH_FILES 2>/dev/null | head -1 || echo "")
  fi

  # Try GitHub API for homepage URL, then crawl for social links
  if [[ -n "$OWNER" && -n "$REPO" ]]; then
    HOMEPAGE=$(curl -sf "https://api.github.com/repos/$OWNER/$REPO" 2>/dev/null | grep -o '"homepage"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"homepage"[[:space:]]*:[[:space:]]*"//;s/"$//' || echo "")

    if [[ -n "$HOMEPAGE" && "$HOMEPAGE" != "null" ]]; then
      HOMEPAGE_CONTENT=$(curl -sf -L --max-time 10 "$HOMEPAGE" 2>/dev/null || echo "")
      if [[ -n "$HOMEPAGE_CONTENT" ]]; then
        [[ -z "$YOUTUBE" ]] && YOUTUBE=$(echo "$HOMEPAGE_CONTENT" | grep -ohiE 'https?://(www\.)?(youtube\.com|youtu\.be)/([@/a-zA-Z0-9_-]+)' | head -1 || echo "")
        [[ -z "$DISCORD" ]] && DISCORD=$(echo "$HOMEPAGE_CONTENT" | grep -ohiE 'https?://(www\.)?discord\.(gg|com/invite)/[a-zA-Z0-9_-]+' | head -1 || echo "")
        [[ -z "$TWITTER" ]] && TWITTER=$(echo "$HOMEPAGE_CONTENT" | grep -ohiE 'https?://(www\.)?(twitter\.com|x\.com)/[a-zA-Z0-9_]+' | head -1 || echo "")
        [[ -z "$LINKEDIN" ]] && LINKEDIN=$(echo "$HOMEPAGE_CONTENT" | grep -ohiE 'https?://(www\.)?linkedin\.com/(in|company)/[a-zA-Z0-9_-]+' | head -1 || echo "")
        [[ -z "$BLUESKY" ]] && BLUESKY=$(echo "$HOMEPAGE_CONTENT" | grep -ohiE 'https?://bsky\.app/profile/[a-zA-Z0-9._-]+' | head -1 || echo "")
        [[ -z "$TWITCH" ]] && TWITCH=$(echo "$HOMEPAGE_CONTENT" | grep -ohiE 'https?://(www\.)?twitch\.tv/[a-zA-Z0-9_]+' | head -1 || echo "")
      fi
    fi
  fi

  # Build JSON object
  local SOCIAL="{"
  local HAS_ANY=false

  for pair in "youtube:$YOUTUBE" "discord:$DISCORD" "twitter:$TWITTER" "linkedin:$LINKEDIN" "bluesky:$BLUESKY" "twitch:$TWITCH"; do
    local key="${pair%%:*}"
    local val="${pair#*:}"
    if [[ -n "$val" ]]; then
      [[ "$HAS_ANY" == true ]] && SOCIAL+=","
      SOCIAL+="\"$key\":\"$(json_escape "$val")\""
      HAS_ANY=true
    fi
  done

  SOCIAL+="}"
  echo "$SOCIAL"
}

SOCIAL_LINKS=$(collect_social_links)

# ---------- directory structure (top 2 levels, skip hidden dirs & node_modules) ----------

DIR_STRUCTURE=$(find . -maxdepth 2 \
  -not -path '*/\.*' \
  -not -path './node_modules/*' \
  -not -path './dist/*' \
  -not -path './build/*' \
  -not -path './.next/*' \
  -not -path './target/*' \
  -not -path './__pycache__/*' \
  -not -path './venv/*' \
  -not -path './.venv/*' \
  -not -name '*.pyc' \
  | sort \
  | head -50 \
  | sed 's|^\./||' \
  || echo "")

# ---------- output JSON ----------

cat <<EOF
{
  "project_name": "$(json_escape "$PROJECT_NAME")",
  "description": "$(json_escape "$DESCRIPTION")",
  "license": "$(json_escape "$LICENSE")",
  "owner": "$(json_escape "$OWNER")",
  "repo": "$(json_escape "$REPO")",
  "package_manager": "$(json_escape "$PACKAGE_MANAGER")",
  "ci": {
    "provider": "$(json_escape "$CI_PROVIDER")",
    "workflows": $CI_WORKFLOWS
  },
  "social_links": $SOCIAL_LINKS,
  "directory_structure": "$(json_escape "$DIR_STRUCTURE")"
}
EOF
