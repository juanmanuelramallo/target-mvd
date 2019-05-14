# frozen_string_literal: true

class TargetsController < ApplicationController
  before_action :authenticate_user!

  def create
    target = Target.new target_params.merge(user_id: current_user.id)

    render json: target, status: :created if target.save!
  end

  def index
    render json: current_user.targets
  end

  def destroy
    render json: target.destroy
  end

  private

  def target
    @target ||= current_user.targets.find params[:id]
  end

  def target_params
    params.require(:target).permit(:area_length, :lat, :lng, :title, :topic_id)
  end
end
