# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    message = conversation.messages.new(message_params.merge(user_id: current_user.id))

    render jsonapi: message, status: :created if message.save!
  end

  def index
    render jsonapi: paginate(conversation.messages)
  end

  private

  def conversation
    @conversation ||= current_user.conversations.find params[:conversation_id]
  end

  def message_params
    jsonapi_deserialize(params, only: [:text])
  end
end
