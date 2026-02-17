#!/usr/bin/env bash
set -euo pipefail

# validate-versions.sh - Verify that plugin.json and marketplace.json versions are in sync.
#
# Usage:
#   ./scripts/validate-versions.sh           # validate all plugins
#   ./scripts/validate-versions.sh swimlanes # validate one plugin
#
# Exit codes:
#   0 - all versions match
#   1 - mismatch or missing plugin found

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MARKETPLACE="$REPO_ROOT/.claude-plugin/marketplace.json"
ERRORS=0

validate_plugin() {
  local name="$1"
  local plugin_json="$REPO_ROOT/plugins/$name/.claude-plugin/plugin.json"

  # Check plugin.json exists
  if [ ! -f "$plugin_json" ]; then
    echo "FAIL  $name - plugin.json not found at plugins/$name/.claude-plugin/plugin.json"
    return 1
  fi

  # Read version from plugin.json
  local plugin_version
  plugin_version=$(python3 -c "
import json
with open('$plugin_json') as f:
    data = json.load(f)
v = data.get('version')
if not v:
    print('MISSING')
else:
    print(v)
")

  # Read version from marketplace.json
  local marketplace_version
  marketplace_version=$(python3 -c "
import json
with open('$MARKETPLACE') as f:
    data = json.load(f)
for p in data.get('plugins', []):
    if p.get('name') == '$name':
        v = p.get('version')
        print(v if v else 'MISSING')
        exit()
print('NOT_FOUND')
")

  # Validate
  if [ "$plugin_version" = "MISSING" ]; then
    echo "FAIL  $name - version missing from plugin.json"
    return 1
  fi

  if [ "$marketplace_version" = "NOT_FOUND" ]; then
    echo "FAIL  $name - not listed in marketplace.json"
    return 1
  fi

  if [ "$marketplace_version" = "MISSING" ]; then
    echo "FAIL  $name - version missing from marketplace.json entry"
    return 1
  fi

  if [ "$plugin_version" != "$marketplace_version" ]; then
    echo "FAIL  $name - version mismatch: plugin.json=$plugin_version, marketplace.json=$marketplace_version"
    return 1
  fi

  # Validate semver format
  if ! echo "$plugin_version" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    echo "FAIL  $name - version '$plugin_version' is not valid semver (x.y.z)"
    return 1
  fi

  echo "OK    $name @ $plugin_version"
  return 0
}

# If a specific plugin is given, validate just that one
if [ $# -ge 1 ]; then
  validate_plugin "$1" || exit 1
  exit 0
fi

# Otherwise validate all plugins listed in marketplace.json
PLUGIN_NAMES=$(python3 -c "
import json
with open('$MARKETPLACE') as f:
    data = json.load(f)
for p in data.get('plugins', []):
    print(p['name'])
")

if [ -z "$PLUGIN_NAMES" ]; then
  echo "No plugins found in marketplace.json"
  exit 0
fi

while IFS= read -r name; do
  validate_plugin "$name" || ERRORS=$((ERRORS + 1))
done <<< "$PLUGIN_NAMES"

# Also check for plugin dirs not listed in marketplace.json
for dir in "$REPO_ROOT"/plugins/*/; do
  dir_name=$(basename "$dir")
  if [ -f "$dir/.claude-plugin/plugin.json" ]; then
    if ! echo "$PLUGIN_NAMES" | grep -qx "$dir_name"; then
      echo "WARN  $dir_name - has plugin.json but is not listed in marketplace.json"
    fi
  fi
done

echo ""
if [ "$ERRORS" -gt 0 ]; then
  echo "$ERRORS plugin(s) failed validation"
  exit 1
else
  echo "All plugins validated"
  exit 0
fi
