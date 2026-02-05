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
