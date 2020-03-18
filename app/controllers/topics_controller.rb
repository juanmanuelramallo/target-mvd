# frozen_string_literal: true

class TopicsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: serialize_collection(Topic.all, TopicSerializer)
  end

  private

  def permitted_inclusions
    ['targets']
  end
end
