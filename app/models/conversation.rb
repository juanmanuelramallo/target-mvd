# frozen_string_literal: true

class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy

  belongs_to :target
  belongs_to :initiator, class_name: 'User'

  validates :target, uniqueness: { scope: :initiator_id }
  validate :status_must_be_active
  validate :target_must_be_compatible_with_initiator

  enum status: %i[active disabled]

  def unread?(user)
    messages.last&.user != user && unread
  end

  private

  def status_must_be_active
    return if active? || status_was == 'active'

    errors.add :base, I18n.t('errors.models.conversation.status_must_be_active')
  end

  def target_must_be_compatible_with_initiator
    return if initiator&.compatible_targets&.include?(target) || disabled?

    errors.add :target, I18n.t(
      'errors.models.conversation.target_must_be_compatible_with_initiator'
    )
  end
end
