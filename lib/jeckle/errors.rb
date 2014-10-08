module Jeckle
  class ArgumentError < ::ArgumentError; end

  class NoSuchAPIError < ArgumentError
    def initialize(api)
      message = %{The API name '#{api}' doesn't exist in Jeckle definitions.

        Heckle: - Hey chum, what we can do now?
        Jeckle: - Old chap, you need to put the right API name!
        Heckle: - Hey pal, tell me the APIs then!
        Jeckle: - Deal the trays, old thing: #{Jeckle::Setup.registered_apis.keys}.
      }

      super message
    end
  end

  class NoUsernameOrPasswordError < ArgumentError
    def initialize(credentials)
      message = %{No such keys "username" and "password" on `basic_auth` definition"

        Heckle: - Hey chum, what we can do now?
        Jeckle: - Old chap, you need to define a username and a password for basic auth!
      }

      super message
    end
  end
end
