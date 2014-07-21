module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.include HTTParty

      base.include Virtus.model

      base.include ActiveModel::Validations
      base.include ActiveModel::Naming

      base.class_eval do
        attribute :response
      end
    end

    module ClassMethods
      def resource_name
        model_name.element
      end

      def all
        get(resource_name)
      end

      def find(id)
        get(resource_action(id))
      end

      def resource_action(id)
        "#{resource_name}/#{id}"
      end
    end

    def save
      request(:post)
    end

    def update
      request(:put)
    end

    def headers
      {
        'Content-Type'    => 'application/json; charset="UTF-8"',
        'Accept-Encoding' => 'application/json'
      }
    end

    private

    def request(http_method)
      return false if invalid?

      @response = self.class.send(http_method, resource_name, headers: headers, body: params)

      @response.success?
    end
  end
end
