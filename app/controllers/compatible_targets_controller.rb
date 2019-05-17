# frozen_string_literal: true

class CompatibleTargetsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user.compatible_targets, include: permitted_include
  end

  private

  def permitted_inclusions
    %w[topic user]
  end
end
