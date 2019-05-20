# frozen_string_literal: true

class DisableConversationsJob < ApplicationJob
  queue_as :default

  def perform(conversation_ids)
    Conversation.transaction do
      Conversation.where(id: conversation_ids).active.find_each(&:disabled!)
    end
  end
end
