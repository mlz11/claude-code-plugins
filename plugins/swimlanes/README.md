# Swimlanes

Generate sequence diagrams using [Swimlanes.io](https://swimlanes.io) syntax directly from Claude Code.

## Install

```
/plugin marketplace add mlz11/claude-code-plugins
/plugin install swimlanes@mlz11-cc-marketplace
```

## Usage

```
/swimlanes user authentication flow with JWT
```

Claude generates valid Swimlanes.io syntax. Paste it at [swimlanes.io](https://swimlanes.io) to render.

## Syntax Quick Reference

| Syntax | Description |
|---|---|
| `A -> B: msg` | Solid arrow |
| `A ->> B: msg` | Open arrow |
| `A -x B: msg` | Lost message |
| `A <-> B: msg` | Bi-directional |
| `A --> B: msg` | Dashed line |
| `A => B: msg` | Bold line |
| `A -> A: msg` | Self (loop) |
| `note:` | Add a note |
| `if: / else: / end` | Conditional |
| `group: / end` | Group |
| `title:` | Diagram title |
| `autonumber` | Auto-number messages |
| `...:` | Delay indicator |
| `order: C, B, A` | Actor ordering |

Notes and dividers support markdown formatting. Font Awesome icons: `{fas-icon}`.

Full syntax reference: [swimlanes.io](https://swimlanes.io)
