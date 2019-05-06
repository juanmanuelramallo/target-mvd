# frozen_string_literal: true

class TargetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_target, only: :destroy

  def create
    target = Target.new target_params.merge(user_id: current_user.id)

    if target.save
      render json: target, status: :created
    else
      render json: { errors: target.errors.messages }, status: :unprocessable_entity
    end
  end

  def index
    render json: current_user.targets
  end

  def destroy
    render json: @target.destroy
  end

  private

  def set_target
    @target = current_user.targets.find params[:id]
  end

  def target_params
    params.require(:target).permit(:area_length, :lat, :lng, :title, :topic_id)
  end
end
