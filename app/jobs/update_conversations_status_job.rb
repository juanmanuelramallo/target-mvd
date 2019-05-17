# frozen_string_literal: true

class UpdateConversationsStatusJob < ApplicationJob
  queue_as :default

  def perform(target)
    compatible_users = target.compatible_users

    Conversation.transaction do
      target.conversations.active.find_each do |conversation|
        conversation.disabled! unless compatible_users.include?(conversation.initiator)
      end
    end
  end
end
