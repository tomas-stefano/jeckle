# Jeckle

[![CI](https://github.com/tomas-stefano/jeckle/actions/workflows/ci.yml/badge.svg)](https://github.com/tomas-stefano/jeckle/actions/workflows/ci.yml)

Wrap APIs with easiness and flexibility.

<img src="http://www.toonopedia.com/hekljekl.jpg" alt="Jeckle" />

> Heckle usually refers to Jeckle familiarly, as "chum" or "pal", while Jeckle
often calls Heckle "old chap", "old thing", "old boy" or "old featherhead",
indicating a close friendship between them.

<small>*[Extracted from Wikipedia](http://en.wikipedia.org/wiki/Heckle_and_Jeckle)*</small>

Let third party APIs be Heckle for your app's Jeckle.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jeckle'
```

And then execute:

```sh
$ bundle
```

## Quick Start

```ruby
# 1. Configure the API
Jeckle.configure do |config|
  config.register :dribbble do |api|
    api.base_uri = 'http://api.dribbble.com'
    api.bearer_token = ENV['DRIBBBLE_TOKEN']
    api.middlewares do
      response :json
      response :jeckle_raise_error
    end
  end
end

# 2. Define a resource
class Shot < Jeckle::Resource
  api :dribbble

  attribute :id, Jeckle::Types::Integer
  attribute :name, Jeckle::Types::String
  attribute :url, Jeckle::Types::String
end

# 3. Use it
shot = Shot.find(1600459)
shots = Shot.list(name: 'avengers')
```

## API Configuration

### Basic Auth

```ruby
Jeckle.configure do |config|
  config.register :my_api do |api|
    api.base_uri = 'https://api.example.com'
    api.basic_auth = { username: 'user', password: 'pass' }
  end
end
```

### Bearer Token

```ruby
config.register :my_api do |api|
  api.base_uri = 'https://api.example.com'
  api.bearer_token = 'my-oauth-token'
end
```

### API Key (Header)

```ruby
config.register :my_api do |api|
  api.base_uri = 'https://api.example.com'
  api.api_key = { value: 'secret', header: 'X-Api-Key' }
end
```

### API Key (Query Param)

```ruby
config.register :my_api do |api|
  api.base_uri = 'https://api.example.com'
  api.api_key = { value: 'secret', param: 'api_key' }
end
```

### Other Options

```ruby
config.register :my_api do |api|
  api.base_uri = 'https://api.example.com'
  api.namespaces = { prefix: 'api', version: 'v2' }
  api.headers = { 'Content-Type' => 'application/json' }
  api.params = { locale: 'en' }
  api.open_timeout = 2
  api.read_timeout = 5
  api.logger = Rails.logger

  api.middlewares do
    request :json
    response :json
    response :jeckle_raise_error
  end
end
```

## Defining Resources

Resources inherit from `Jeckle::Resource` and use `Jeckle::Types` for attribute definitions:

```ruby
class Shot < Jeckle::Resource
  api :dribbble

  attribute :id, Jeckle::Types::Integer
  attribute :name, Jeckle::Types::String
  attribute :url, Jeckle::Types::String
  attribute :score, Jeckle::Types::Float
end
```

Available types: `Jeckle::Types::Integer`, `String`, `Float`, `Bool`, `Array`, `Hash`, and any [dry-types](https://dry-rb.org/gems/dry-types/) type.

## CRUD Operations

### Find

```ruby
# GET /shots/1600459
shot = Shot.find(1600459)
shot.name #=> "Daryl Heckle And Jeckle Oates"
```

### List

```ruby
# GET /shots?name=avengers
shots = Shot.list(name: 'avengers')
```

### Create

```ruby
# POST /shots
shot = Shot.create(name: 'New Shot', url: 'http://example.com')
```

### Update

```ruby
# PATCH /shots/123
shot = Shot.update(123, name: 'Updated Name')
```

### Destroy

```ruby
# DELETE /shots/123
Shot.destroy(123) #=> true
```

## Attribute Aliasing

Map API attribute names to Ruby-friendly names:

```ruby
class Shot < Jeckle::Resource
  api :dribbble
  attribute :thumbnailSize, Jeckle::Types::String, as: :thumbnail_size
end

shot.thumbnailSize  #=> "50x50"
shot.thumbnail_size #=> "50x50"
```

## Error Handling

Enable the error middleware to get typed exceptions:

```ruby
api.middlewares do
  response :json
  response :jeckle_raise_error
end
```

Then rescue specific errors:

```ruby
begin
  Shot.find(999)
rescue Jeckle::NotFoundError => e
  puts "Not found: #{e.message} (status: #{e.status})"
rescue Jeckle::ClientError => e
  puts "Client error: #{e.status}"
rescue Jeckle::ServerError => e
  puts "Server error: #{e.status}"
end
```

Error hierarchy:

- `Jeckle::Error` — base error
  - `Jeckle::ConnectionError` — network errors
  - `Jeckle::TimeoutError` — timeout errors
  - `Jeckle::HTTPError` — HTTP errors (`status`, `body`)
    - `Jeckle::ClientError` — 4xx
      - `BadRequestError` (400), `UnauthorizedError` (401), `ForbiddenError` (403), `NotFoundError` (404), `UnprocessableEntityError` (422), `TooManyRequestsError` (429)
    - `Jeckle::ServerError` — 5xx
      - `InternalServerError` (500), `ServiceUnavailableError` (503)

## Pagination

Use `list_each` for lazy, offset-based pagination:

```ruby
# Fetches pages on demand, 25 items per page by default
Shot.list_each(per_page: 10).each do |shot|
  puts shot.name
end

# Works with Enumerable methods
Shot.list_each(per_page: 50).first(5)
Shot.list_each(per_page: 50, status: 'active').select { |s| s.score > 90 }
```

## Migration from 0.4.x

### Resource definition

Resources now use class inheritance instead of module inclusion:

```ruby
# Before (0.4.x)
class Shot
  include Jeckle::Resource
  attribute :id, Integer
end

# After (1.0.0)
class Shot < Jeckle::Resource
  attribute :id, Jeckle::Types::Integer
end
```

### Attribute types

Use `Jeckle::Types::*` instead of Ruby constants:

| Before | After |
|--------|-------|
| `Integer` | `Jeckle::Types::Integer` |
| `String` | `Jeckle::Types::String` |
| `Float` | `Jeckle::Types::Float` |
| `Boolean` | `Jeckle::Types::Bool` |

### Collection method

The `search` method has been renamed to `list`:

```ruby
# Before
Shot.search name: 'avengers'

# After
Shot.list name: 'avengers'
```

## Examples

You can see more examples here: [https://github.com/tomas-stefano/jeckle/tree/master/examples](https://github.com/tomas-stefano/jeckle/tree/master/examples)

## Roadmap

Follow [GitHub's milestones](https://github.com/tomas-stefano/jeckle/milestones)
