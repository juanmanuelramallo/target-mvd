# frozen_string_literal: true

class ConversationsChannel < ApplicationCable::Channel
  def subscribed
    stream_for conversation
  end

  private

  def conversation
    @conversation ||= current_user.conversations.find params[:id]
  end
end
