# frozen_string_literal: true

module Auth
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    protected

    def render_create_error
      render_resource_invalid(@resource)
    end

    def render_create_success
      render jsonapi: @resource, status: :created
    end

    def render_update_error
      render_resource_invalid(@resource)
    end

    def render_update_success
      render jsonapi: @resource, status: :ok
    end
  end
end
