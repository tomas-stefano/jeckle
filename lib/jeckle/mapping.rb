module Jeckle
  module CustomAttributeMapping
    def self.included(base)
      base.send :extend, Jeckle::CustomAttributeMapping::Methods
    end

    module Methods
      def mapping(&block)
        @mapping ||= AttributeMapping.new(self)

        @mapping.instance_eval(&block) if block.present?
      end
    end

    class AttributeMapping
      def initialize(resource)
        @resource = resource
      end

      def attribute(resource_attribute, api_attribute)
        raise Jeckle::InvalidAttributeMappingError,
          { class_name: @resource.name, resource_attribute: resource_attribute,
            api_attribute: api_attribute
        } unless @resource.attribute_set.map(&:name).include? resource_attribute

        @resource.class_eval do
          alias_method api_attribute, resource_attribute
          alias_method "#{api_attribute}=", "#{resource_attribute}="
        end
      end
    end
  end
end
