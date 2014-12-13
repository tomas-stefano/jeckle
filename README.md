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

    gem 'jeckle'

And then execute:

    $ bundle

## Adding new APIs

As an example, let's imagine we'd like to connect our app to Dribbble.com - a community of designers sharing screenshots of their work, process, and projects.

First, we need to configure our API:

``` ruby

Jeckle.configure do |config|
  config.register :dribbble do |api|
    api.base_uri = 'http://api.dribbble.com'
  end
end

```

After we're done with configuration, it's time to do the mapping. Dribbble.com consists of pieces of web designers work called "Shots". Each shot has ID, name, url and corresponding image or gif. Let's imagine we want to do the API that would allow us to search Dribbble shots.

Here is how we would map the Shot class and its attributes:

``` ruby

class Shot
  include Jeckle::Resource

  api :dribbble

  attribute :id, Integer
  attribute :name, String
  attribute :url, String
  attribute :image_url, String
end

```

This allows us to run requests to search Dribbble.com Shots directory based on different attributes of the shot. For example, we can find a specific shot by providing its ID:

``` ruby

shot = Shot.find 1600459

```

Now we can ask the API to return any of the attributes of the shot, such as its name or URL, so we can use them in our app:

``` ruby

shot.id
# => 1600459

shot.name
# => Daryl Heckle And Jeckle Oates

shot.image_url
# => https://d13yacurqjgara.cloudfront.net/users/85699/screenshots/1600459/daryl_heckle_and_jeckle_oates-dribble.jpg

``` 

We're all set! Now we can expand the mapping of our API, e.g to add ability to search Dribbble Designer directory by adding Designer class, or we can expand the original mapping of Shot class to include more attributes, such as tags or comments.



## Roadmap

- Faraday middleware abstraction
- Per action API
- Comprehensive restful actions
- Testability
