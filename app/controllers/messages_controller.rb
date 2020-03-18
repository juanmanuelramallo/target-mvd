# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    message = conversation.messages.new(message_params.merge(user_id: current_user.id))

    render json: serialize_resource(message, MessageSerializer), status: :created if message.save!
  end

  def index
    _, messages = pagy(conversation.messages)

    render json: serialize_collection(messages, MessageSerializer)
  end

  private

  def conversation
    @conversation ||= current_user.conversations.find params[:conversation_id]
  end

  def message_params
    params.require(:message).permit(:text)
  end
end
