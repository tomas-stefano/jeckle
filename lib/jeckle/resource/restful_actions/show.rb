module Jeckle
  module Resource
    module RESTfulActions
      module Show
        def self.included(base)
          base.send :extend, ClassMethods
        end

        module ClassMethods
          # @public
          #
          # Member action that requests for the resource using the resource name
          #
          #  @example
          #
          #     Post.find(1) # => posts/1
          #
          def find(id)
            endpoint   = "#{resource_name}/#{id}"
            response   = run_request(endpoint).response.body
            attributes = parse_response(response, member_root_name)

            new(attributes)
          end
        end
      end
    end
  end
end
