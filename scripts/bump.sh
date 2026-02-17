#!/usr/bin/env bash
set -euo pipefail

# bump.sh - Bump a plugin version in both plugin.json and marketplace.json, then create a git tag.
#
# Usage:
#   ./scripts/bump.sh <plugin-name> <major|minor|patch|x.y.z>
#
# Examples:
#   ./scripts/bump.sh swimlanes patch        # 1.0.0 -> 1.0.1
#   ./scripts/bump.sh swimlanes minor        # 1.0.0 -> 1.1.0
#   ./scripts/bump.sh swimlanes major        # 1.0.0 -> 2.0.0
#   ./scripts/bump.sh swimlanes 2.3.1        # set explicit version

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MARKETPLACE="$REPO_ROOT/.claude-plugin/marketplace.json"

usage() {
  echo "Usage: $0 <plugin-name> <major|minor|patch|x.y.z>"
  echo ""
  echo "Examples:"
  echo "  $0 swimlanes patch"
  echo "  $0 swimlanes 2.3.1"
  exit 1
}

if [ $# -ne 2 ]; then
  usage
fi

PLUGIN_NAME="$1"
BUMP="$2"
PLUGIN_DIR="$REPO_ROOT/plugins/$PLUGIN_NAME"
PLUGIN_JSON="$PLUGIN_DIR/.claude-plugin/plugin.json"

# Validate plugin exists
if [ ! -f "$PLUGIN_JSON" ]; then
  echo "Error: plugin.json not found at $PLUGIN_JSON"
  echo "Available plugins:"
  ls "$REPO_ROOT/plugins/" 2>/dev/null || echo "  (none)"
  exit 1
fi

# Read current version from plugin.json (source of truth)
CURRENT_VERSION=$(python3 -c "
import json, sys
with open('$PLUGIN_JSON') as f:
    data = json.load(f)
print(data.get('version', '0.0.0'))
")

echo "Plugin:          $PLUGIN_NAME"
echo "Current version: $CURRENT_VERSION"

# Compute new version
if [[ "$BUMP" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  NEW_VERSION="$BUMP"
else
  IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"
  case "$BUMP" in
    major) NEW_VERSION="$((MAJOR + 1)).0.0" ;;
    minor) NEW_VERSION="$MAJOR.$((MINOR + 1)).0" ;;
    patch) NEW_VERSION="$MAJOR.$MINOR.$((PATCH + 1))" ;;
    *)
      echo "Error: bump must be 'major', 'minor', 'patch', or an explicit version (x.y.z)"
      exit 1
      ;;
  esac
fi

echo "New version:     $NEW_VERSION"

# Prevent no-op bump
if [ "$CURRENT_VERSION" = "$NEW_VERSION" ]; then
  echo "Error: new version is the same as current version"
  exit 1
fi

TAG_NAME="$PLUGIN_NAME/v$NEW_VERSION"

# Check tag doesn't already exist
if git -C "$REPO_ROOT" tag -l "$TAG_NAME" | grep -q .; then
  echo "Error: tag '$TAG_NAME' already exists"
  exit 1
fi

# Check for uncommitted changes (warn, don't block)
if ! git -C "$REPO_ROOT" diff --quiet HEAD 2>/dev/null; then
  echo ""
  echo "Warning: you have uncommitted changes. The bump commit will include them."
  echo "Press Enter to continue or Ctrl+C to abort."
  read -r
fi

# Update plugin.json
python3 -c "
import json
with open('$PLUGIN_JSON', 'r') as f:
    data = json.load(f)
data['version'] = '$NEW_VERSION'
with open('$PLUGIN_JSON', 'w') as f:
    json.dump(data, f, indent=2)
    f.write('\n')
"

# Update marketplace.json
python3 -c "
import json, sys
with open('$MARKETPLACE', 'r') as f:
    data = json.load(f)
found = False
for plugin in data.get('plugins', []):
    if plugin.get('name') == '$PLUGIN_NAME':
        plugin['version'] = '$NEW_VERSION'
        found = True
        break
if not found:
    print('Error: plugin \"$PLUGIN_NAME\" not found in marketplace.json', file=sys.stderr)
    sys.exit(1)
with open('$MARKETPLACE', 'w') as f:
    json.dump(data, f, indent=2)
    f.write('\n')
"

echo ""
echo "Updated:"
echo "  - $PLUGIN_JSON"
echo "  - $MARKETPLACE"

# Stage, commit, and tag
git -C "$REPO_ROOT" add "$PLUGIN_JSON" "$MARKETPLACE"
git -C "$REPO_ROOT" commit -m "chore($PLUGIN_NAME): bump version to $NEW_VERSION"
git -C "$REPO_ROOT" tag -a "$TAG_NAME" -m "$PLUGIN_NAME v$NEW_VERSION"

echo ""
echo "Committed and tagged: $TAG_NAME"
echo ""
echo "To push:"
echo "  git push origin main $TAG_NAME"
