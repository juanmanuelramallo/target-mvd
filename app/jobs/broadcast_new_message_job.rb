# frozen_string_literal: true

class BroadcastNewMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    ConversationsChannel.broadcast_to(
      message.conversation,
      MessageSerializer.new(message).serialized_json
    )
  end
end
