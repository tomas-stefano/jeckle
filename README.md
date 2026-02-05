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

## Usage

### Configuring an API

Let's say you'd like to connect your app to Dribbble.com - a community of designers sharing screenshots of their work, process, and projects.

First, you would need to configure the API:

```ruby
Jeckle.configure do |config|
  config.register :dribbble do |api|
    api.base_uri = 'http://api.dribbble.com'
    api.middlewares do
      response :json
    end
  end
end
```

### Mapping resources

Following the previous example, Dribbble.com consists of pieces of web designers work called "Shots". Each shot has the attributes `id`, `name`, `url` and `image_url`. A Jeckle resource representing Dribbble's shots would be something like this:

```ruby
class Shot < Jeckle::Resource
  api :dribbble

  attribute :id, Jeckle::Types::Integer
  attribute :name, Jeckle::Types::String
  attribute :url, Jeckle::Types::String
  attribute :image_url, Jeckle::Types::String
end
```

### Fetching data

The resource class allows us to list shots through HTTP requests to the API, based on the provided information. For example, we can find a specific shot by providing its id to the `find` method:

```ruby
# GET http://api.dribbble.com/shots/1600459
shot = Shot.find 1600459
```

That will return a `Shot` instance, containing the shot info:

```ruby
shot.id
=> 1600459

shot.name
=> "Daryl Heckle And Jeckle Oates"

shot.image_url
=> "https://d13yacurqjgara.cloudfront.net/users/85699/screenshots/1600459/daryl_heckle_and_jeckle_oates-dribble.jpg"
```

You can also look for many shots matching one or more attributes, by using the `list` method:

```ruby
# GET http://api.dribbble.com/shots?name=avengers
shots = Shot.list name: 'avengers'
```

### Attribute Aliasing

Sometimes you want to call the API's attributes something else, either because their names aren't very concise or because they're out of you app's convention. If that's the case, you can add an `as` option:

```ruby
attribute :thumbnailSize, Jeckle::Types::String, as: :thumbnail_size
```

Both mapping will work:

```ruby
shot.thumbnailSize
=> "50x50"

shot.thumbnail_size
=> "50x50"
```

### Error Handling

Jeckle provides a built-in Faraday middleware that automatically raises typed errors for HTTP error responses. Enable it in your API configuration:

```ruby
Jeckle.configure do |config|
  config.register :dribbble do |api|
    api.base_uri = 'http://api.dribbble.com'
    api.middlewares do
      response :json
      response :jeckle_raise_error
    end
  end
end
```

Then rescue specific errors in your code:

```ruby
begin
  Shot.find 999
rescue Jeckle::NotFoundError => e
  puts "Not found: #{e.message} (status: #{e.status})"
rescue Jeckle::ClientError => e
  puts "Client error: #{e.status}"
rescue Jeckle::ServerError => e
  puts "Server error: #{e.status}"
rescue Jeckle::HTTPError => e
  puts "HTTP error: #{e.status}"
end
```

The error hierarchy:

- `Jeckle::Error` — base error
  - `Jeckle::ConnectionError` — network connectivity errors
  - `Jeckle::TimeoutError` — request timeout errors
  - `Jeckle::HTTPError` — HTTP errors (has `status` and `body` attributes)
    - `Jeckle::ClientError` — 4xx errors
      - `BadRequestError` (400), `UnauthorizedError` (401), `ForbiddenError` (403), `NotFoundError` (404), `UnprocessableEntityError` (422), `TooManyRequestsError` (429)
    - `Jeckle::ServerError` — 5xx errors
      - `InternalServerError` (500), `ServiceUnavailableError` (503)

We're all set! Now we can expand the mapping of our API, e.g to add ability to search Dribbble Designer directory by adding Designer class, or we can expand the original mapping of Shot class to include more attributes, such as tags or comments.

## Migration from 0.4.x

### Resource definition

Resources now use class inheritance instead of module inclusion:

```ruby
# Before (0.4.x)
class Shot
  include Jeckle::Resource
  attribute :id, Integer
end

# After (0.6.0+)
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
