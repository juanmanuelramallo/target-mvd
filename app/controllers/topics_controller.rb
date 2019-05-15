# frozen_string_literal: true

class TopicsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: Topic.all
  end
end
