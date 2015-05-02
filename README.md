# Jeckle

[![Build Status](https://travis-ci.org/tomas-stefano/jeckle.svg?branch=master)](https://travis-ci.org/tomas-stefano/jeckle)
[![Code Climate](https://codeclimate.com/github/tomas-stefano/jeckle.png)](https://codeclimate.com/github/tomas-stefano/jeckle)
[![Test Coverage](https://codeclimate.com/github/tomas-stefano/jeckle/coverage.png)](https://codeclimate.com/github/tomas-stefano/jeckle)

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
class Shot
  include Jeckle::Resource

  api :dribbble

  attribute :id, Integer
  attribute :name, String
  attribute :url, String
  attribute :image_url, String
end
```

### Fetching data

The resource class allows us to search shots through HTTP requests to the API, based on the provided information. For example, we can find a specific shot by providing its id to the `find` method:

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

You can also look for many shots matching one or more attributes, by using the `search` method:

```ruby
# GET http://api.dribbble.com/shots?name=avengers
shots = Shot.search name: 'avengers'
```

### Attribute Aliasing

Sometimes you want to call the API's attributes something else, either because their names aren't very concise or because they're out of you app's convention. If that's the case, you can add an `as` option:

```ruby
attribute :thumbnailSize, String, as: :thumbnail_size
```

Both mapping will work:

```ruby
shot.thumbnailSize
=> "50x50"

shot.thumbnail_size
=> "50x50"
```

We're all set! Now we can expand the mapping of our API, e.g to add ability to search Dribbble Designer directory by adding Designer class, or we can expand the original mapping of Shot class to include more attributes, such as tags or comments.

## Examples

You can see more examples here: [https://github.com/tomas-stefano/jeckle/tree/master/examples](https://github.com/tomas-stefano/jeckle/tree/master/examples)

## Roadmap

Follow [GitHub's milestones](https://github.com/tomas-stefano/jeckle/milestones)
