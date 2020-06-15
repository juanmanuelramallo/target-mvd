# frozen_string_literal: true

class ConversationsController < ApplicationController
  include JSONAPI::Pagination

  before_action :authenticate_user!

  def create
    conversation = Conversation.new(conversation_params.merge(initiator_id: current_user.id))

    render jsonapi: conversation, status: :created if conversation.save!
  end

  def index
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
    params.require(:conversation).permit(:target_id)
  end

  def conversation_update_params
    params.require(:conversation).permit(:unread)
  end

  def permitted_inclusions
    %w[target initiator]
  end

  def update_params
    @update_params ||= if conversation.messages.last&.user == current_user
                         conversation_update_params.except :unread
                       else
                         conversation_update_params
                       end
  end
end
