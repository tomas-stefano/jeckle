# frozen_string_literal: true

module Jeckle
  module AttributeAliasing
    def attribute(name, type = nil, **options)
      if (custom_name = options.delete(:as))
        original_name = name

        if type
          super(custom_name, type)
        else
          super(custom_name)
        end

        define_method(original_name) { public_send(custom_name) }

        transform_keys do |key|
          key = key.to_sym
          key == original_name ? custom_name : key
        end
      elsif type
        super(name, type)
      else
        super(name)
      end
    end
  end
end
