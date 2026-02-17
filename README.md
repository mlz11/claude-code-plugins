# mlz11-cc-marketplace

Claude Code plugin marketplace by [mlz11](https://github.com/mlz11).

## Quick Start

### 1. Add the marketplace

```
/plugin marketplace add mlz11/claude-code-plugins
```

### 2. Install a plugin

```
/plugin install swimlanes@mlz11-cc-marketplace
```

### 3. Use it

```
/swimlanes user login flow with OAuth2
```

## Available Plugins

| Plugin | Platform | Description |
|---|---|---|
| **swimlanes** | Claude Code | Generate sequence diagrams from natural language using [Swimlanes.io](https://swimlanes.io) syntax |

## Local Development

Test the marketplace locally:

```
/plugin marketplace add ./path/to/claude-code-plugins
/plugin install swimlanes@mlz11-cc-marketplace
```

## Contributing

Open a PR with your plugin in `plugins/your-plugin-name/` following the [Claude Code plugin structure](https://code.claude.com/docs/en/plugins).

## License

MIT
