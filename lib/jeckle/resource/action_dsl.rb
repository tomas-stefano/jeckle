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
          define_singleton_method action_name do |params = {}|
            collection = run_collection_request(action_name, params, options)

            Array(collection).collect { |attrs| new attrs }
          end
        when :member
          define_method action_name do |params = {}|
            params = attributes.merge(params)
            options[:key] ||= :id
            options[:key] = send(options[:key])

            self.attributes = self.class.run_member_request action_name, params, options
          end
        else
          raise Jeckle::ArgumentError, %(Invalid value for :on option.
            Expected: member|collection
            Got: #{act_on})
        end
      end

      def run_collection_request(action_name, params = {}, options = {})
        path = options.delete(:path) || action_name

        endpoint = "#{resource_name}/#{path}"
        request = run_request endpoint, options.merge(params)
        response = request.response

        return [] unless response.success?

        parse_response response.body
      end

      def run_member_request(action_name, params = {}, options = {})
        path = options.delete(:path) || action_name
        key = options.delete(:key)

        endpoint = "#{resource_name}/#{key}/#{path}"
        request = run_request endpoint, options.merge(params)
        response = request.response

        parse_response response.body
      end

      def parse_response(body)
        body.kind_of?(Array) ? body : body[resource_name]
      end
    end
  end
end
