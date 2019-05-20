# frozen_string_literal: true

class Target < ApplicationRecord
  acts_as_mappable

  belongs_to :topic
  belongs_to :user

  has_many :conversations, dependent: :nullify

  validates :title, :lat, :lng, presence: true
  validates :area_length, numericality: { greater_than: 0 }
  validate :user_must_have_less_than_maximum_targets

  after_create :broadcast_to_compatible_users
  after_update :update_conversations_status
  before_destroy :disable_conversations, prepend: true

  def compatible_targets
    Target.where(topic_id: topic_id)
          .where.not(user: user)
          .merge(Target.within(area_length, origin: self))
  end

  def compatible_users
    User.where(id: compatible_targets.pluck(:user_id))
  end

  private

  def broadcast_to_compatible_users
    BroadcastCompatibleTargetsJob.perform_later(self)
  end

  def disable_conversations
    DisableConversationsJob.perform_later(conversations.pluck(:id))
  end

  def update_conversations_status
    UpdateConversationsStatusJob.perform_later(self)
  end

  def user_must_have_less_than_maximum_targets
    return unless user && user.targets.count >= User::MAXIMUM_TARGETS

    errors.add :base,
               I18n.t('.user_must_have_less_than_maximum_targets', max: User::MAXIMUM_TARGETS)
  end
end
