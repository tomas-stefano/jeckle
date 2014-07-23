module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.send :include, Virtus.model
      base.send :include, ActiveModel::Naming
      base.send :include, ActiveModel::Validations

      base.class_eval do
        attr_reader :response
      end
    end

    module ClassMethods
      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def resource_name
        model_name.element
      end

      def api
        @api ||= Faraday.new(url: 'http://myapi.com').tap do |request|
          request.headers = headers
        end
      end
    end
  end
end
module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.send :include, Virtus.model
      base.send :include, ActiveModel::Naming
      base.send :include, ActiveModel::Validations

      base.class_eval do
        attr_reader :response
      end
    end

    module ClassMethods
      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def resource_name
        model_name.element
      end

      def api
        @api ||= Faraday.new(url: 'http://myapi.com').tap do |request|
          request.headers = headers
        end
      end
    end
  end
end
module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.send :include, Virtus.model
      base.send :include, ActiveModel::Naming
      base.send :include, ActiveModel::Validations

      base.class_eval do
        attr_reader :response
      end
    end

    module ClassMethods
      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def resource_name
        model_name.element
      end

      def api
        @api ||= Faraday.new(url: 'http://myapi.com').tap do |request|
          request.headers = headers
        end
      end
    end
  end
end
module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.send :include, Virtus.model
      base.send :include, ActiveModel::Naming
      base.send :include, ActiveModel::Validations

      base.class_eval do
        attr_reader :response
      end
    end

    module ClassMethods
      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def resource_name
        model_name.element
      end

      def api
        @api ||= Faraday.new(url: 'http://myapi.com').tap do |request|
          request.headers = headers
        end
      end
    end
  end
end
module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.send :include, Virtus.model
      base.send :include, ActiveModel::Naming
      base.send :include, ActiveModel::Validations

      base.class_eval do
        attr_reader :response
      end
    end

    module ClassMethods
      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def resource_name
        model_name.element
      end

      def api
        @api ||= Faraday.new(url: 'http://myapi.com').tap do |request|
          request.headers = headers
        end
      end
    end
  end
end
module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.send :include, Virtus.model
      base.send :include, ActiveModel::Naming
      base.send :include, ActiveModel::Validations

      base.class_eval do
        attr_reader :response
      end
    end

    module ClassMethods
      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def resource_name
        model_name.element
      end

      def api
        @api ||= Faraday.new(url: 'http://myapi.com').tap do |request|
          request.headers = headers
        end
      end
    end
  end
end
module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.send :include, Virtus.model
      base.send :include, ActiveModel::Naming
      base.send :include, ActiveModel::Validations

      base.class_eval do
        attr_reader :response
      end
    end

    module ClassMethods
      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def resource_name
        model_name.element
      end

      def api
        @api ||= Faraday.new(url: 'http://myapi.com').tap do |request|
          request.headers = headers
        end
      end
    end
  end
end
module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.send :include, Virtus.model
      base.send :include, ActiveModel::Naming
      base.send :include, ActiveModel::Validations

      base.class_eval do
        attr_reader :response
      end
    end

    module ClassMethods
      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def resource_name
        model_name.element
      end

      def api
        @api ||= Faraday.new(url: 'http://myapi.com').tap do |request|
          request.headers = headers
        end
      end
    end
  end
end
module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.send :include, Virtus.model
      base.send :include, ActiveModel::Naming
      base.send :include, ActiveModel::Validations

      base.class_eval do
        attr_reader :response
      end
    end

    module ClassMethods
      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def resource_name
        model_name.element
      end

      def api
        @api ||= Faraday.new(url: 'http://myapi.com').tap do |request|
          request.headers = headers
        end
      end
    end
  end
end
module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.send :include, Virtus.model
      base.send :include, ActiveModel::Naming
      base.send :include, ActiveModel::Validations

      base.class_eval do
        attr_reader :response
      end
    end

    module ClassMethods
      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def resource_name
        model_name.element
      end

      def api
        @api ||= Faraday.new(url: 'http://myapi.com').tap do |request|
          request.headers = headers
        end
      end
    end
  end
end
module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.send :include, Virtus.model
      base.send :include, ActiveModel::Naming
      base.send :include, ActiveModel::Validations

      base.class_eval do
        attr_reader :response
      end
    end

    module ClassMethods
      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def resource_name
        model_name.element
      end

      def api
        @api ||= Faraday.new(url: 'http://myapi.com').tap do |request|
          request.headers = headers
        end
      end
    end
  end
end
module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.send :include, Virtus.model
      base.send :include, ActiveModel::Naming
      base.send :include, ActiveModel::Validations

      base.class_eval do
        attr_reader :response
      end
    end

    module ClassMethods
      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def resource_name
        model_name.element
      end

      def api
        @api ||= Faraday.new(url: 'http://myapi.com').tap do |request|
          request.headers = headers
        end
      end
    end
  end
end
module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.send :include, Virtus.model
      base.send :include, ActiveModel::Naming
      base.send :include, ActiveModel::Validations

      base.class_eval do
        attr_reader :response
      end
    end

    module ClassMethods
      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def resource_name
        model_name.element
      end

      def api
        @api ||= Faraday.new(url: 'http://myapi.com').tap do |request|
          request.headers = headers
        end
      end
    end
  end
end
module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.send :include, Virtus.model
      base.send :include, ActiveModel::Naming
      base.send :include, ActiveModel::Validations

      base.class_eval do
        attr_reader :response
      end
    end

    module ClassMethods
      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def resource_name
        model_name.element
      end

      def api
        @api ||= Faraday.new(url: 'http://myapi.com').tap do |request|
          request.headers = headers
        end
      end
    end
  end
end
module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.send :include, Virtus.model
      base.send :include, ActiveModel::Naming
      base.send :include, ActiveModel::Validations

      base.class_eval do
        attr_reader :response
      end
    end

    module ClassMethods
      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def resource_name
        model_name.element
      end

      def api
        @api ||= Faraday.new(url: 'http://myapi.com').tap do |request|
          request.headers = headers
        end
      end
    end
  end
end
