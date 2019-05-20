# frozen_string_literal: true

module Auth
  class PasswordsController < DeviseTokenAuth::PasswordsController
    protected

    def render_update_error
      render_resource_invalid(@resource)
    end
  end
end
