module Jeckle
  module RESTActions
    def self.included(base)
      base.send :extend, Jeckle::RESTActions::Collection
    end

    module Collection
      # @public
      #
      # The root name that Jeckle will parse the <b>response</b>. Default is <b>false</b>.
      #
      # @example
      #
      #   module Dribble
      #     class Shot
      #       include Jeckle::Resource
      #       root collection: true, member: true
      #     end
      #   end
      #
      #   Shot.collection_root_name # => Will parse the root node as 'shots'
      #   Shot.member_root_name # => Will parse the root node as 'shot'
      #
      #  Sometimes that are APIs you need to fetch /projects, BUT the root node is extremely different from the resource name.
      #
      #   module OtherApi
      #     class Project
      #       include Jeckle::Resource
      #       api :my_api
      #       root collection: 'awesome-projects', member: 'awesome-project'
      #     end
      #   end
      #
      def root(options={})
        @collection_root_name = find_root_name(options[:collection], :pluralize)
        @member_root_name     = find_root_name(options[:member], :singularize)
      end

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

      # @public
      #
      # Collection action that requests for the resource using the resource name
      #
      #  @example
      #
      #     Post.search({ status: 'published' }) # => posts/?status=published
      #     Post.where({ status: 'published' }) # => posts/?status=published
      #
      def search(params = {})
        request = run_request(resource_name, params)
        response = request.response

        return [] unless response.success?

        collection = parse_response(response.body, collection_root_name)

        Array.wrap(collection).collect { |attrs| new attrs }
      end

      # @private
      #
      def parse_response(response, root_name)
        if root_name
          response[root_name]
        else
          response
        end
      end

      # @private
      #
      def find_root_name(root_name, root_method)
        return root_name if root_name.is_a?(String)

        if root_name
          model_name.element.send(root_method)
        end
      end

      # @private
      #
      def collection_root_name
        @collection_root_name
      end

      # @private
      #
      def member_root_name
        @member_root_name
      end
    end
  end
end
