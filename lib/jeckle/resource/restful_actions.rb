require_relative 'restful_actions/index'
require_relative 'restful_actions/show'

module Jeckle
  module Resource
    module RESTfulActions
      def self.included(base)
        base.send :extend, ClassMethods
        base.send :include, Jeckle::Resource::RESTfulActions::Index
        base.send :include, Jeckle::Resource::RESTfulActions::Show
      end

      module ClassMethods
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
end
