# frozen_string_literal: true

module Jeckle
  class Resource < Jeckle::Model
    include ActiveModel::Naming

    extend Jeckle::HTTP::APIMapping
    extend Jeckle::RESTActions::Collection
    extend Jeckle::AttributeAliasing
  end
end
