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
      def action(action_name, options = {})
        action_on = options.delete(:on) || :member
        action_params = options.delete(:params) || {}

        case action_on
        when :collection
          define_singleton_method action_name do |params = {}|
            if action_params.is_a? Proc
              params.merge! instance_exec(&action_params)
            else
              params.merge!(action_params)
            end

            collection = run_collection_request(action_name, params, options)

            Array.wrap(collection).collect { |attrs| new attrs }
          end
        when :member
          define_method action_name do |params = {}|
            if action_params.is_a? Proc
              params.merge! instance_exec(&action_params)
            else
              params.merge!(action_params)
            end

            options[:key] = public_send options.fetch(:key, :id)

            self.attributes = self.class.run_member_request action_name, params, options
          end
        else
          raise Jeckle::ArgumentError, %(Invalid value for :on option.
            Expected: member|collection
            Got: #{action_on})
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

      private

      def parse_response(body)
        body.kind_of?(Array) ? body : body[resource_name]
      end
    end
  end
end
