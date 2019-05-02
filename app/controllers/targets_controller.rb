class TargetsController < ApplicationController
  before_action :authenticate_user!

  def create
    target = Target.new target_params.merge(user_id: current_user.id)

    if target.save
      render json: target, status: :created
    else
      render json: { errors: target.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def target_params
    params.require(:target).permit(:area_length, :lat, :lng, :title, :topic_id)
  end
end
