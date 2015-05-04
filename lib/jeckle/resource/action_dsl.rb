module Jeckle
  module Resource
    module ActionDSL
      # @example
      #  action :create, method: :post, serializer: ShotCreateSerializer
      #  action :touch, method: :get, path: '/some/path'
      #
      # @args
      #  +action_name+
      #  +options[Hash]+
      #    - method [get|post|put|patch|delete]
      #    - on     [member|collection]
      #    - path
      def action(action_name, options)
        act_on = options.delete(:on) || :member

        case act_on
        when :collection
          define_collection_action(action_name, options)
        when :member
          # TODO
        else
          raise Jeckle::ArgumentError, %(Invalid value for :on option.
            Expected: member|collection
            Got: #{on})
        end
      end

      private

      def define_collection_action(action_name, options)
        path = options.delete(:path) || action_name

        define_singleton_method(action_name) do |params|
          url = "#{resource_name}/#{path}"
          request = run_request(url, params.merge(options))
          response = request.response

          return [] unless response.success?

          collection = parse_response(response.body)

          Array(collection).collect { |attrs| new attrs }
        end
      end

      def parse_response(response)
        response.kind_of?(Array) ? response : response[resource_name]
      end
    end
  end
end
