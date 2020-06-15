# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :text, presence: true
  validate :conversation_must_be_active

  after_create :broadcast_to_conversation

  private

  def broadcast_to_conversation
    BroadcastNewMessageJob.perform_later(self)
  end

  def conversation_must_be_active
    return if conversation&.active?

    errors.add(:conversation, :must_be_active)
  end
end
