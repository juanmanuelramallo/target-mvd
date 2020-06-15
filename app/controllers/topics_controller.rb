# frozen_string_literal: true

class TopicsController < ApplicationController
  before_action :authenticate_user!

  def index
    render jsonapi: Topic.all, include: permitted_include
  end

  private

  def permitted_inclusions
    ['targets']
  end
end
