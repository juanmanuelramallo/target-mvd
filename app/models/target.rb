# frozen_string_literal: true

class Target < ApplicationRecord
  acts_as_mappable

  belongs_to :topic
  belongs_to :user

  validates :title, :lat, :lng, presence: true
  validates :area_length, numericality: { greater_than: 0 }
  validate :user_must_have_less_than_maximum_targets

  def compatible_targets
    Target.where(topic_id: topic_id)
          .where.not(user: user)
          .merge(Target.within(area_length, origin: self))
  end

  private

  def user_must_have_less_than_maximum_targets
    return unless user && user.targets.count >= User::MAXIMUM_TARGETS

    errors.add :base,
               I18n.t('.user_must_have_less_than_maximum_targets', max: User::MAXIMUM_TARGETS)
  end
end
