# frozen_string_literal: true

class TargetsController < ApplicationController
  before_action :authenticate_user!

  def create
    target = Target.new target_params.merge(user_id: current_user.id)

    render jsonapi: target, status: :created if target.save!
  end

  def destroy
    render jsonapi: target.destroy
  end

  def index
    render jsonapi: current_user.targets, include: permitted_include
  end

  def update
    render jsonapi: target, status: :accepted if target.update!(target_params)
  end

  private

  def target
    @target ||= current_user.targets.find params[:id]
  end

  def target_params
    jsonapi_deserialize(params, only: %i[area_length lat lng title topic])
  end

  def permitted_inclusions
    %w[topic user]
  end
end
