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
        action_config = parse_action_config(options)

        case action_config[:act_on]
        when :collection
          define_singleton_method action_name do
            if action_config[:params].is_a? Proc
              action_config[:params] = instance_exec(&action_config[:params])
            end

            collection = run_collection_request(action_name, action_config[:params], options)

            Array.wrap(collection).collect { |attrs| new attrs }
          end
        when :member
          define_method action_name do
            if action_config[:params].is_a? Proc
              action_config[:params] = instance_exec(&action_config[:params])
            end

            options[:key] = public_send options.fetch(:key, :id)

            self.attributes = self.class.run_member_request action_name, action_config[:params], options
          end
        else
          raise Jeckle::ArgumentError, %(Invalid value for :on option.
            Expected: member|collection
            Got: #{action_config[:act_on]})
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

      def parse_action_config(options)
        {}.tap do |opts|
          opts[:act_on] = options.delete(:on) || :member
          opts[:params] = options.delete(:params) || {}
        end
      end

      def parse_response(body)
        body.kind_of?(Array) ? body : body[resource_name]
      end
    end
  end
end
