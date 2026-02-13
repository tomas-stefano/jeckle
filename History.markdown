## v.1.0.0

### CRUD & Operations
* Add CRUD operations: `create`, `update`, `destroy`
* Add composable operation modules: `Jeckle::Operations::Find`, `List`, `Create`, `Update`, `Delete`
* Add instance-level operations: `save`, `delete`, `reload`
* Add nested resources with `belongs_to` DSL

### Authentication
* Add `bearer_token` authentication
* Add `api_key` authentication (header-based or query param-based)
* Add OAuth 2.0 client credentials flow with automatic token refresh
* Add `Jeckle::Auth::CredentialChain` for chaining credential providers

### Pagination
* Add `Jeckle::Collection` with lazy offset-based pagination
* Add `list_each` method for paginated enumeration
* Add cursor-based pagination strategy (Stripe-style)
* Add Link header pagination strategy (GitHub RFC 5988)
* Add per-API pagination configuration via `api.pagination`

### Resilience & Error Handling
* Add `faraday-retry` with configurable retry options (`api.retry=`)
* Add `request_id` tracking on HTTP errors (extracts `X-Request-Id` header)
* Add `Jeckle::RateLimit` for parsing rate limit headers on 429 errors

### Configuration
* Add thread-safe API registry with `Monitor`
* Add per-request timeout support
* Add `configure_connection` for extending Faraday defaults
* Add environment-based configuration via `Jeckle::Setup.register_from_env`
* Add `Jeckle::Client` for instance-based requests with credential overrides

### Observability
* Add `Jeckle::Middleware::Instrumentation` emitting `ActiveSupport::Notifications` events
* Add `Jeckle::Middleware::LogRedactor` for redacting sensitive headers
* Add response inspection via `_response` on resource instances

### Testing
* Add `Jeckle.test_mode!` with `Jeckle.stub_request` for test stubbing
* Add SimpleCov for test coverage reporting

### Documentation
* Add `yard` for API documentation generation
* Add YARD documentation to all public classes and methods
* Add comprehensive README with migration guide from 0.4.x

## v.0.6.0

* **BREAKING:** Replace Virtus with dry-struct (`~> 1.0`) and dry-types (`~> 1.0`)
* **BREAKING:** `Jeckle::Model` is now a class (inherits `Dry::Struct`) instead of a module
* **BREAKING:** `Jeckle::Resource` is now a class (inherits `Jeckle::Model`) instead of a module
* **BREAKING:** Rename `search` to `list` (`search` still works with deprecation warning)
* Add `Jeckle::Types` module for dry-types integration
* Use `Jeckle::Types::Integer`, `Jeckle::Types::String`, etc. for attribute types

## v.0.5.0

* Add HTTP error class hierarchy (`Jeckle::Error`, `HTTPError`, `ClientError`, `ServerError`)
* Add specific error classes for common HTTP status codes (400, 401, 403, 404, 422, 429, 500, 503)
* Add `Jeckle::Middleware::RaiseError` Faraday middleware for automatic error raising
* Register middleware as `:jeckle_raise_error` for opt-in usage

## v.0.4.0

* Upgrade Faraday to 2.x (`~> 2.0`)
* Drop support for Ruby < 3.0
* Replace Travis CI with GitHub Actions
* Add Rubocop with rubocop-rspec and rubocop-performance
* Add `frozen_string_literal: true` to all Ruby files
* Remove `faraday_middleware` dependency
* Modernize Ruby syntax (`base.include` instead of `base.send :include`)

## v.0.3.0

* Change `Jeckle::Resource.default_api` to `Jeckle::Resource.api`

## v.0.2.1

* Fix bug when APIs includes root in json responses

## v.0.2.0

* Add Jeckle middlewares
