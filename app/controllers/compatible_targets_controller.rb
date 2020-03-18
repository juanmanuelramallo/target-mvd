# frozen_string_literal: true

class CompatibleTargetsController < ApplicationController
  before_action :authenticate_user!

  def index
    _, targets = pagy(current_user.compatible_targets)

    render json: serialize_collection(targets, TargetSerializer)
  end

  private

  def permitted_inclusions
    %w[topic user]
  end
end
