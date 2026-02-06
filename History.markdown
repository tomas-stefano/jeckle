## v.1.0.0

* Add CRUD operations: `create`, `update`, `destroy`
* Add `bearer_token` authentication
* Add `api_key` authentication (header-based or query param-based)
* Add `Jeckle::Collection` with lazy offset-based pagination
* Add `list_each` method for paginated enumeration
* Add `yard` for API documentation generation
* Add YARD documentation to all public classes and methods

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
