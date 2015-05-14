module Jeckle
  class Request
    attr_reader :api, :body, :headers, :method, :params, :response, :endpoint

    def initialize(api, endpoint, options = {})
      @api = api

      @method  = options.delete(:method) || :get
      @body    = options.delete(:body) if %w(post put patch).include?(method.to_s)
      @headers = options.delete(:headers)

      if options[:params].nil? && options.size > 0
        warn %([DEPRECATION] Sending URL params mixed with options hash is deprecated.
        Instead of doing this:
          run_request 'cars/search', id: id, method: :get
        Do this:
          run_request 'cars/search', params: { id: id }, method: :get)

        @params = options
      else
        @params = options.delete(:params) || {}
      end

      @endpoint = endpoint

      @response = perform_api_request
    end

    def self.run(*args)
      new *args
    end

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
