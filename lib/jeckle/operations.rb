# frozen_string_literal: true

require 'jeckle/operations/find'
require 'jeckle/operations/list'
require 'jeckle/operations/create'
require 'jeckle/operations/update'
require 'jeckle/operations/delete'
require 'jeckle/operations/instance'

module Jeckle
  # Composable operation modules that can be individually extended onto
  # resource classes for fine-grained control over available CRUD actions.
  #
  # @example Opt-in to specific operations
  #   class ReadOnlyResource < Jeckle::Resource
  #     extend Jeckle::Operations::Find
  #     extend Jeckle::Operations::List
  #   end
  #
  # @see Jeckle::Operations::Find
  # @see Jeckle::Operations::List
  # @see Jeckle::Operations::Create
  # @see Jeckle::Operations::Update
  # @see Jeckle::Operations::Delete
  module Operations
  end
end
