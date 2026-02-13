# frozen_string_literal: true

module Jeckle
  module Operations
    # Instance-level operations for resources (save, delete, reload).
    # Since dry-struct instances are immutable, these methods return new instances.
    #
    # @example
    #   shot = Shot.find(123)
    #   updated = shot.save          # PATCH /shots/123
    #   reloaded = shot.reload       # GET /shots/123
    #   shot.delete                  # DELETE /shots/123
    module Instance
      # Persist the resource. Creates (POST) if no `id`, updates (PATCH) otherwise.
      # Returns a new instance with the server response attributes.
      #
      # @return [Jeckle::Resource] a new instance from the server response
      #
      # @example
      #   shot = Shot.new(name: 'Draft')
      #   created = shot.save  # POST /shots
      #
      #   existing = Shot.find(123)
      #   updated = existing.save  # PATCH /shots/123
      def save
        if respond_to?(:id) && id
          self.class.update(id, attributes)
        else
          self.class.create(attributes)
        end
      end

      # Delete the resource via DELETE request.
      #
      # @return [true]
      # @raise [NoMethodError] if resource has no `id` attribute
      #
      # @example
      #   shot = Shot.find(123)
      #   shot.delete  # DELETE /shots/123
      def delete
        self.class.destroy(id)
      end

      # Re-fetch the resource from the API.
      # Returns a new instance with fresh attributes from the server.
      #
      # @return [Jeckle::Resource] a new instance with refreshed attributes
      # @raise [NoMethodError] if resource has no `id` attribute
      #
      # @example
      #   shot = Shot.find(123)
      #   fresh = shot.reload  # GET /shots/123
      def reload
        self.class.find(id)
      end
    end
  end
end
