# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def create
    conversation = Conversation.first_or_initialize conversation_params

    if conversation.save
      render json: conversation, status: :created
    else
      render json: { errors: conversation.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:target_id, :initiator_id)
  end
end
