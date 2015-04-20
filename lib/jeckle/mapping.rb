module Jeckle
  module CustomAttributeMapping
    def attribute(name, coercion, options = {})
      if custom_name = options.delete(:as)
        super(custom_name, coercion, options)

        alias_attribute name, custom_name
      else
        super
      end
    end
  end
end
