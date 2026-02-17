# Swimlanes

Generate sequence diagrams directly from natural language descriptions using [Swimlanes.io](https://swimlanes.io) syntax.

**Platform:** Claude Code

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

## Use Cases

<details>
<summary><strong>1. Document authentication flows</strong> - OAuth2 with token refresh and session expiry</summary>

```
/swimlanes user login with OAuth2 including token refresh and session expiry
```

```
title: OAuth2 Login with Token Refresh

User -> App: click "Sign in with Google"
App -> Google: redirect to /authorize
Google -> User: show consent screen
User -> Google: grant permission
Google -> App: authorization code
App -> Google: exchange code for tokens
Google -> App: access_token + refresh_token
App -> Database: store refresh_token
App -> User: set session cookie

...: Later - access token expires

App -> Google: refresh_token → new access_token
if: Refresh succeeds
  Google -> App: new access_token
  App -> User: continue session
else: Refresh fails
  Google -x App: 401 invalid_grant
  App -> User: redirect to login
end
```

</details>

<details>
<summary><strong>2. Map microservice communication</strong> - order processing across payment, inventory, and notifications</summary>

```
/swimlanes order processing through payment, inventory, and notification services
```

```
title: Order Processing Pipeline
autonumber

Client -> API Gateway: POST /orders
API Gateway -> Order Service: create order
Order Service -> Database: save order (status: pending)

group: Payment
  Order Service -> Payment Service: charge $amount
  Payment Service -> Stripe: create payment intent
  Stripe -> Payment Service: payment confirmed
  Payment Service -> Order Service: payment OK
end

group: Fulfillment
  Order Service -> Inventory Service: reserve items
  if: Items available
    Inventory Service -> Order Service: reserved
    Order Service -> Database: update (status: confirmed)
  else: Out of stock
    Inventory Service -x Order Service: insufficient stock
    Order Service -> Payment Service: refund
    Order Service -> Database: update (status: cancelled)
  end
end

Order Service -> Notification Service: send confirmation
Notification Service -> User: email receipt
Order Service -> API Gateway: order response
API Gateway -> Client: 201 Created
```

</details>

<details>
<summary><strong>3. Design CI/CD pipeline flows</strong> - staging deployment, approval gate, and production rollback</summary>

```
/swimlanes CI/CD pipeline with staging deployment, approval gate, and production rollback
```

```
title: CI/CD Pipeline with Rollback

Developer -> GitHub: push to feature branch
GitHub -> CI Runner: webhook trigger
CI Runner -> CI Runner: run tests + lint
if: Tests pass
  CI Runner -> Docker Registry: build & push image
  CI Runner -> Staging: deploy v2
  Staging -> CI Runner: health check OK

  note: Manual approval gate
  CI Runner -> Team Lead: request approval
  Team Lead -> CI Runner: approve

  CI Runner -> Production: deploy v2
  Production -> CI Runner: health check
  if: Healthy
    CI Runner -> Production: route traffic to v2
    CI Runner -> Slack: notify deploy success
  else: Unhealthy
    CI Runner -> Production: rollback to v1
    CI Runner -> Slack: notify rollback
    CI Runner -x Developer: deploy failed
  end
else: Tests fail
  CI Runner -x Developer: pipeline failed
  note: Fix and re-push
end
```

</details>

## More Information

For the full syntax reference, see [swimlanes.io](https://swimlanes.io).

## License

MIT
