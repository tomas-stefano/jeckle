module Jeckle
  class Request
    attr_accessor :response
    attr_reader :api, :body, :method

    def initialize(api, options)
      @api = api

      @method = options.delete(:method) || :get
      @body = options.delete(:body) if %w(post put).include?(method.to_s)
    end

    def self.run_request(api, endpoint, options = {})
      new(api, options).tap do |jeckle_request|
        jeckle_request.response = api.connection.public_send jeckle_request.method do |api_request|
          api_request.url endpoint
          api_request.params = options
          api_request.body = jeckle_request.body if jeckle_request.body
        end
      end
    end
  end
end
