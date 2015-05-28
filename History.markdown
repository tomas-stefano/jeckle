## v.0.4.0

* Now params should be received by `run_request` through a `:params` option, instead of
being mixed with the options hash (`:method`, `:headers` and `:body`)
* Added support for `PATCH` method on `Jeckle::Request`
* Added definition of attribute aliases. Example: `attribute :firstName, String, as: :first_name`

## v.0.3.0

* Change `Jeckle::Resource.default_api` to `Jeckle::Resource.api`

## v.0.2.1

* Fix bug when APIs includes root in json responses

## v.0.2.0

* Add Jeckle middlewares
