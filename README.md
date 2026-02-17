# Swimlanes.io — Claude Code Plugin Marketplace

Official [Swimlanes.io](https://swimlanes.io) plugins for [Claude Code](https://code.claude.com).

## Quick Start

### 1. Add the marketplace

```
/plugin marketplace add swimlanes-io/claude-code-plugins
```

### 2. Install the plugin

```
/plugin install swimlanes@swimlanes-marketplace
```

### 3. Use it

```
/swimlanes user login flow with OAuth2
```

Claude generates valid Swimlanes.io syntax you can paste directly at [swimlanes.io](https://swimlanes.io) to render.

## Available Plugins

| Plugin | Description |
|---|---|
| **swimlanes** | Generate sequence diagrams using Swimlanes.io syntax |

## Example

```
> /swimlanes API request with retry and circuit breaker

title: API Request with Retry & Circuit Breaker

Client -> CircuitBreaker: send request
if: Circuit OPEN
  CircuitBreaker -x Client: fail fast
else: Circuit CLOSED
  CircuitBreaker -> API: forward request
  if: Success
    API -> CircuitBreaker: 200 OK
    CircuitBreaker -> Client: response
  else: Failure (retry)
    API -x CircuitBreaker: 500 Error
    CircuitBreaker -> API: retry request
    if: Retry succeeds
      API -> CircuitBreaker: 200 OK
      CircuitBreaker -> Client: response
    else: Retry fails
      API -x CircuitBreaker: 500 Error
      note: Circuit transitions to OPEN
      CircuitBreaker -x Client: service unavailable
    end
  end
end
```

Paste the output at [swimlanes.io](https://swimlanes.io) to get a rendered diagram.

## Local Development

Test the marketplace locally before installing:

```bash
cc --plugin-dir ./plugins/swimlanes
```

Or add the local marketplace:

```
/plugin marketplace add ./path/to/claude-code-plugins
/plugin install swimlanes@swimlanes-marketplace
```

## Contributing

Want to add a plugin to this marketplace? Open a PR with your plugin in `plugins/your-plugin-name/` following the [Claude Code plugin structure](https://code.claude.com/docs/en/plugins).

## License

MIT
