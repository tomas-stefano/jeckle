# frozen_string_literal: true

module Jeckle
  # REST action methods for Jeckle resources.
  module RESTActions
    # Collection-level CRUD operations extended onto resource classes.
    # Includes all individual operation modules for full CRUD support.
    #
    # For fine-grained control, extend individual {Jeckle::Operations} modules instead.
    module Collection
      include Jeckle::Operations::Find
      include Jeckle::Operations::List
      include Jeckle::Operations::Create
      include Jeckle::Operations::Update
      include Jeckle::Operations::Delete
    end
  end
end
