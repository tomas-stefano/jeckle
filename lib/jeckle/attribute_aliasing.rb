# frozen_string_literal: true

module Jeckle
  # Allows API attribute names to be aliased to more idiomatic Ruby names.
  #
  # @example
  #   class Shot < Jeckle::Resource
  #     attribute :imageUrl, Jeckle::Types::String, as: :image_url
  #   end
  #
  #   shot.imageUrl   #=> "http://..."
  #   shot.image_url  #=> "http://..."
  module AttributeAliasing
    # Define an attribute with optional aliasing via the :as option.
    #
    # @param name [Symbol] the original attribute name (from the API)
    # @param type [Dry::Types::Type, nil] the dry-types type
    # @param options [Hash] additional options
    # @option options [Symbol] :as the Ruby-friendly alias name
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
