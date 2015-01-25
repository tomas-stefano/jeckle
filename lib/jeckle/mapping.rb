module Jeckle
  module Mapping
    class CustomAttributeMapping
      def initialize(resource)
        @resource = resource
      end

      def attribute(resource_attribute, api_attribute)
        raise Jeckle::InvalidAttributeMappingError,
        { class_name: @resource.name, resource_attribute: resource_attribute,
          api_attribute: api_attribute
        } unless @resource.attribute_set.map(&:name).include? resource_attribute

        @resource.send :define_method, api_attribute do
          send(resource_attribute)
        end

        @resource.send :define_method, "#{api_attribute}=" do |value|
          send("#{resource_attribute}=", value)
        end
      end
    end

    def mapping(&block)
      @mapping ||= CustomAttributeMapping.new(self)

      @mapping.instance_eval(&block) if block.present?
    end
  end
end
