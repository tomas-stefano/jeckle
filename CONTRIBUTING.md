# Contributing

1. ...
2. ...

## Tips & Tricks

...

### Rubinius

...

#### Debugging

```ruby
class Toast
  attr_accessor :setting

  def initialize
    # We need to manually require since we does not load it automatically
    require 'rubinius/debugger'

    # Start debugging
    Rubinius::Debugger.start

    @setting = :brown
  end
end

# In debugging console
p Toast.new.setting # We need to explicitly use `p`
n # Calls next line
```

Further reading:

- http://rubini.us/doc/en/tools/debugger
