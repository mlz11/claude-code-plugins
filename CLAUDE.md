# CLAUDE.md

This is a Claude Code plugin marketplace owned by mlz11.

## Structure

```
.claude-plugin/marketplace.json   # Marketplace catalog
plugins/<name>/                   # Each plugin is a subdirectory
  .claude-plugin/plugin.json      # Plugin manifest
  skills/<name>/SKILL.md          # Skill definitions
  README.md                       # Plugin-level docs
```

## Style

- Never use em dashes (—). Use " - " (spaced hyphen) or parentheses instead.

## Conventions

- Marketplace name: `mlz11-cc-marketplace`
- Commit messages: conventional commits (`feat:`, `fix:`, `docs:`, etc.) enforced by `.githooks/commit-msg`
- Plugin names: kebab-case
- License: MIT
- Each plugin must have its own `README.md`, `plugin.json`, and at least one skill

## Adding a Plugin

1. Create `plugins/<plugin-name>/` with the structure above
2. Add an entry to `.claude-plugin/marketplace.json` in the `plugins` array
3. Include a `README.md` with install instructions and usage examples

## Testing Locally

```bash
cc --plugin-dir ./plugins/<plugin-name>
```
