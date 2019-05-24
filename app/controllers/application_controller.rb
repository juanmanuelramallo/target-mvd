# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Concerns::CommonErrorsConcern
  include Concerns::IncludeConcern
  include Concerns::PaginationConcern
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[avatar gender full_name])
  end
end
