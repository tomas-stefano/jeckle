# frozen_string_literal: true

module Jeckle
  module Auth
    # OAuth 2.0 client credentials authentication.
    # Automatically fetches and caches access tokens.
    #
    # @example
    #   api.oauth2 = {
    #     client_id: 'id',
    #     client_secret: 'secret',
    #     token_url: 'https://auth.example.com/oauth/token'
    #   }
    class OAuth2
      # @return [String] the current access token
      attr_reader :access_token

      # @param client_id [String] OAuth 2.0 client ID
      # @param client_secret [String] OAuth 2.0 client secret
      # @param token_url [String] URL to request access tokens
      # @param scope [String, nil] requested scope
      def initialize(client_id:, client_secret:, token_url:, scope: nil)
        @client_id = client_id
        @client_secret = client_secret
        @token_url = token_url
        @scope = scope
        @access_token = nil
        @expires_at = nil
      end

      # Get a valid access token, refreshing if expired.
      #
      # @return [String] access token
      def token
        refresh! if expired?
        @access_token
      end

      # Force a token refresh.
      #
      # @return [String] new access token
      def refresh!
        response = Faraday.post(@token_url) do |req|
          req.body = token_params
          req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        end

        body = JSON.parse(response.body)
        @access_token = body['access_token']
        @expires_at = body['expires_in'] ? Time.now + body['expires_in'].to_i : nil
        @access_token
      end

      # Check if the current token is expired.
      #
      # @return [Boolean]
      def expired?
        @access_token.nil? || (@expires_at && Time.now >= @expires_at)
      end

      private

      def token_params
        params = {
          grant_type: 'client_credentials',
          client_id: @client_id,
          client_secret: @client_secret
        }
        params[:scope] = @scope if @scope
        params
      end
    end
  end
end
