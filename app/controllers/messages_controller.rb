# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    message = conversation.messages.new(message_params.merge(user_id: current_user.id))

    if message.save
      render json: message, status: :created
    else
      render json: { errors: message.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def conversation
    @conversation ||= current_user.conversations.find params[:conversation_id]
  end

  def message_params
    params.require(:message).permit(:text)
  end
end
