# frozen_string_literal: true

module Concerns
  module SerializeConcern
    extend ActiveSupport::Concern

    def serialize_collection(collection, serializer, options = {})
      serializer.new(collection, options.merge(is_collection: true, include: permitted_include))
    end

    def serialize_resource(resource, serializer, options = {})
      serializer.new(resource, options.merge(include: permitted_include))
    end
  end
end
