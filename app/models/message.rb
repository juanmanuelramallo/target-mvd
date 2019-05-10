# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :text, presence: true

  after_create :broadcast_to_conversation

  private

  def broadcast_to_conversation
    BroadcastNewMessageJob.perform_later(self)
  end
end
