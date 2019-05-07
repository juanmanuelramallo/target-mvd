# frozen_string_literal: true

class CompatibleTargetsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user.compatible_targets
  end
end
