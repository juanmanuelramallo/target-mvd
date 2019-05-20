# frozen_string_literal: true

class Conversation < ApplicationRecord
  enum status: %i[active disabled]

  belongs_to :target
  belongs_to :initiator, class_name: 'User'

  has_many :messages, dependent: :destroy

  validates :target, uniqueness: { scope: :initiator_id }
  validate :status_must_be_active
  validate :target_must_be_compatible_with_initiator
  validate :target_must_not_belong_to_initiator

  def unread?(user)
    messages.last&.user != user && unread
  end

  private

  def status_must_be_active
    return if active? || status_was == 'active'

    errors.add(:base, I18n.t('errors.models.conversation.status_must_be_active'))
  end

  def target_must_be_compatible_with_initiator
    return if initiator&.compatible_targets&.include?(target) || disabled?

    errors.add :target, I18n.t(
      'errors.models.conversation.target_must_be_compatible_with_initiator'
    )
  end

  def target_must_not_belong_to_initiator
    return unless initiator&.targets&.include?(target)

    errors.add(:target, I18n.t('errors.models.conversation.target_must_not_belong_to_initiator'))
  end
end
