module Jeckle
  class Request
    attr_reader :api, :body, :headers, :method, :params, :response, :endpoint

    def initialize(api, endpoint, options = {})
      @api = api

      @method  = options.delete(:method) || :get
      @body    = options.delete(:body) if %w(post put).include?(method.to_s)
      @headers = options.delete(:headers)

      @endpoint = endpoint
      @params = options

      @response = perform_api_request
    end

    def self.run(*args)
      new *args
    end

    private_class_method :new

    private

    def perform_api_request
      api.connection.public_send method do |api_request|
        api_request.url endpoint
        api_request.params  = params
        api_request.body    = body
        api_request.headers = api_request.headers.merge(headers) if headers
      end
    end
  end
end
