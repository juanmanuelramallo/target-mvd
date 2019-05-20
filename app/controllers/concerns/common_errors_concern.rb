# frozen_string_literal: true

module Concerns
  module CommonErrorsConcern
    extend ActiveSupport::Concern

    included do
      rescue_from Exception,                           with: :render_base_error
      rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid,         with: :render_record_invalid
      rescue_from ActionController::RoutingError,      with: :render_not_found
      rescue_from AbstractController::ActionNotFound,  with: :render_not_found
      rescue_from ActionController::ParameterMissing,  with: :render_parameter_missing
    end

    def render_base_error(exception)
      raise exception if Rails.env.test?

      render_error(:internal_server_error, [I18n.t('errors.server')])
    end

    def render_not_found(_exception)
      render_error(:not_found, [I18n.t('errors.not_found')])
    end

    def render_record_invalid(exception)
      render_resource_invalid(exception.record)
    end

    def render_parameter_missing(_exception)
      render_error(:unprocessable_entity, [I18n.t('errors.missing_param')])
    end

    def render_resource_invalid(resource)
      render json: resource, status: :unprocessable_entity,
             serializer: ActiveModel::Serializer::ErrorSerializer
    end

    def render_error(status, messages, data = nil)
      response = {
        success: false,
        errors: messages.map { |message| { detail: message } }
      }
      response = response.merge(data) if data
      render json: response, status: status
    end
  end
end
