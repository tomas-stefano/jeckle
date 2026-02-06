# frozen_string_literal: true

module Jeckle
  # Mixin that adds `_response` accessor to resource instances for
  # accessing the raw Faraday response after API calls.
  #
  # @example
  #   shot = Shot.find(123)
  #   shot._response.status      #=> 200
  #   shot._response.headers     #=> { 'X-Request-Id' => '...' }
  module ResponseInspector
    # @return [Faraday::Response, nil] the raw HTTP response
    def _response
      @_response
    end

    # @api private
    def _response=(response)
      @_response = response
    end
  end
end
