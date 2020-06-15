# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def create
    # byebug
    conversation = Conversation.new(conversation_params.merge(initiator_id: current_user.id))

    render jsonapi: conversation, status: :created if conversation.save!
  end

  def index
    # byebug
    jsonapi_paginate(current_user.conversations) do |paginated|
      render jsonapi: paginated, include: permitted_include
    end
  end

  def show
    render jsonapi: conversation, include: permitted_include
  end

  def update
    render jsonapi: conversation, status: :ok if conversation.update!(update_params)
  end

  private

  def conversation
    @conversation ||= current_user.conversations.find params[:id]
  end

  def conversation_params
    jsonapi_deserialize(params, only: [:target])
  end

  def update_params
    jsonapi_deserialize(params, only: update_params_only)
  end

  def permitted_inclusions
    %w[target initiator]
  end

  def update_params_only
    return [:unread] if conversation.messages.last&.user != current_user

    :nothing
  end
end
