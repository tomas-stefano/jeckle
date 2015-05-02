module Jeckle
  module Resource
    module RESTfulActions
      module Index
        def self.included(base)
          base.send :extend, ClassMethods
        end

        module ClassMethods
          # @public
          #
          # Collection action that requests for the resource using the resource name
          #
          #  @example
          #
          #     Post.search({ status: 'published' }) # => posts/?status=published
          #
          def search(params = {})
            request = run_request(resource_name, params)
            response = request.response

            return [] unless response.success?

            collection = parse_response(response.body, collection_root_name)

            Array.wrap(collection).collect { |attrs| new attrs }
          end
        end
      end
    end
  end
end
