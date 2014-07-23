module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.include Virtus.model

      base.include ActiveModel::Naming
      base.include ActiveModel::Validations

      base.class_eval do
        attr_reader :response
      end
    end

    module ClassMethods
      def headers
        {
          'Content-Type'    => 'application/json',
        }
      end

      def resource_name
        model_name.element
      end

      def api
        return @api if @api

        @api = Faraday.new(url: 'http://myapi.com').tap do |a|
          a.headers = headers
        end
      end
    end
  end
end
