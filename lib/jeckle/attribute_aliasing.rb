# frozen_string_literal: true

module Jeckle
  module AttributeAliasing
    def attribute(name, coercion, options = {})
      if (custom_name = options.delete(:as))
        super(custom_name, coercion, options)

        alias_method name, custom_name
        alias_method :"#{name}=", :"#{custom_name}="
      else
        super
      end
    end
  end
end
