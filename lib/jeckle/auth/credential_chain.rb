# frozen_string_literal: true

module Jeckle
  module Auth
    # Tries multiple credential providers in order, returning the first
    # that provides a non-nil value. Inspired by AWS SDK credential chain.
    #
    # @example
    #   chain = Jeckle::Auth::CredentialChain.new(
    #     -> { ENV['MY_API_TOKEN'] },
    #     -> { File.read(File.expand_path('~/.my_api/token')).strip rescue nil },
    #     -> { 'fallback-token' }
    #   )
    #   api.bearer_token = chain.resolve
    class CredentialChain
      # @param providers [Array<#call>] callables that return a credential or nil
      def initialize(*providers)
        @providers = providers
      end

      # Resolve the first non-nil credential from the chain.
      #
      # @return [String, nil] the resolved credential
      def resolve
        @providers.each do |provider|
          value = provider.call
          return value if value
        end
        nil
      end
    end
  end
end
