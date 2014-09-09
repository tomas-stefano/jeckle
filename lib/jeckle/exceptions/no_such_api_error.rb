module Jeckle
  module Exceptions
    class NoSuchAPIError < ArgumentError
      def initialize(api)
        message = %{
          "The API name '#{api}' doesn't exist in Jeckle definitions."

          Heckle: - Hey chum, what we can do now?
          Jeckle: - Old chap, you need to put the right API name!
          Heckle: - Hey pal, tell me the APIs then!
          Jeckle: - Deal the trays, old thing: #{Jeckle::Setup.registered_apis.keys}.

        }

        super(message)
      end
    end
  end
end
