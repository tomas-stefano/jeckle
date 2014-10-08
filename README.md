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

### For Rails applications

We recommend to create a initializer:

```ruby
# config/initializers/jeckle.rb

Jeckle.configure do |config|
  config.register :some_service do |api|
    api.base_uri = 'http://api.someservice.com'
    api.headers = {
      'Accept' => 'application/json'
    }
    api.namespaces = { prefix: 'api', version: 'v1' }
    api.logger = Rails.logger
  end
end
```

And then put your API stuff scoped inside a `services` folder:

```ruby
# app/services/some_service/models/my_resource.rb

module SomeService
  module Models
    class MyResource
      include Jeckle::Resource

      default_api :some_service

      attribute :id
    end
  end
end
```
