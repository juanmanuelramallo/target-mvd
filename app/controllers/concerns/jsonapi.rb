# frozen_string_literal: true

module Concerns
  module Jsonapi
    extend ActiveSupport::Concern

    include JSONAPI::Pagination
    include JSONAPI::Deserialization

    private

    def jsonapi_serializer_params
      {
        current_user: current_user
      }
    end

    # def jsonapi_serializer_class(resource, is_collection)
    #   JSONAPI::Rails.serializer_class(resource, is_collection)
    # rescue NameError

    # end
  end
end
