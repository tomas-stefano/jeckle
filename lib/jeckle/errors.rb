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

  class InvalidAttributeMappingError < ::StandardError
    def initialize(data)
      class_name = data[:class_name]
      resource_attribute = data[:resource_attribute]
      api_attribute = data[:api_attribute]

      message = %{Invalid attribute mapping: #{resource_attribute} => #{api_attribute}.

        Heckle: - Hey chum, what we can do now?
        Jeckle: - Old chap, you need to declare the #{resource_attribute} attribute.
        Heckle: - Hey pal, then tell me how!
        Jeckle: - Deal the trays, old thing:

        class #{class_name}
          attribute :#{resource_attribute}

          mapping do
            attribute :#{resource_attribute}, :#{api_attribute}
          end
        end
      }

      super message
    end
  end
end
