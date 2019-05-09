# frozen_string_literal: true

class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy

  belongs_to :target
  belongs_to :initiator, class_name: 'User'

  validate :target_must_be_compatible_with_initiator

  def unread?(user)
    messages.last&.user != user && unread
  end

  private

  def target_must_be_compatible_with_initiator
    return if initiator&.compatible_targets&.include?(target)

    errors.add :target, I18n.t('.target_must_be_compatible_with_initiator')
  end
end
