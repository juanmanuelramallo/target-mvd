# frozen_string_literal: true

module Concerns
  module IncludeConcern
    extend ActiveSupport::Concern

    def permitted_include
      return '' unless permitted_inclusions && include_params[:include]

      include_params[:include].split(',') & permitted_inclusions
    end

    private

    def include_params
      params.permit(:include)
    end
  end
end
