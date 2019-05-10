# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from Exception,                           with: :render_error
  rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid,         with: :render_record_invalid
  rescue_from ActionController::RoutingError,      with: :render_not_found
  rescue_from AbstractController::ActionNotFound,  with: :render_not_found
  rescue_from ActionController::ParameterMissing,  with: :render_parameter_missing

  private

  def render_error(exception)
    raise exception if Rails.env.test?

    render json: { errors: [I18n.t('errors.server'), exception.message] },
           status: :internal_server_error
  end

  def render_not_found(exception)
    render json: { errors: [I18n.t('errors.not_found'), exception.message] }, status: :not_found
  end

  def render_record_invalid(exception)
    render json: { errors: exception.record.errors.as_json }, status: :bad_request
  end

  def render_parameter_missing(exception)
    render json: { errors: [I18n.t('errors.missing_param'), exception.message] },
           status: :unprocessable_entity
  end
end
