module Jeckle
  module Errors
    class NoUsernameOrPasswordError < ArgumentError
      def initialize(credentials)
        message = %{No such keys "username" and "password" on `basic_auth` definition"

          Heckle: - Hey chum, what we can do now?
          Jeckle: - Old chap, you need to define a username and a password for basic auth!
        }

        super(message)
      end
    end
  end
end
