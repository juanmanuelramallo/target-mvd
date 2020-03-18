# frozen_string_literal: true

class TargetsController < ApplicationController
  before_action :authenticate_user!

  def create
    target = Target.new target_params.merge(user_id: current_user.id)

    render json: serialize_resource(target, TargetSerializer), status: :created if target.save!
  end

  def destroy
    render json: serialize_resource(target.destroy, TargetSerializer)
  end

  def index
    render json: serialize_collection(current_user.targets, TargetSerializer)
  end

  def update
    return unless target.update!(target_params)

    render json: serialize_resource(target, TargetSerializer), status: :accepted
  end

  private

  def target
    @target ||= current_user.targets.find params[:id]
  end

  def target_params
    params.require(:target).permit(:area_length, :lat, :lng, :title, :topic_id)
  end

  def permitted_inclusions
    %w[topic user]
  end
end
