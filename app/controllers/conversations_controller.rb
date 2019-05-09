# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def create
    conversation = ConversationService.call(conversation_params.merge(current_user: current_user))

    if conversation.save
      render json: conversation, status: :created
    else
      render json: { errors: conversation.errors.messages }, status: :unprocessable_entity
    end
  rescue ConversationNotAllowedError
    render json: {}, status: :not_found
  end

  def index
    render json: current_user.conversations
  end

  def show
    render json: conversation
  end

  private

  def conversation
    @conversation ||= current_user.conversations.find params[:id]
  end

  def conversation_params
    params.require(:conversation).permit(:target_id, :initiator_id)
  end
end
