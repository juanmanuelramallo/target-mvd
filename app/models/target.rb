class Target < ApplicationRecord
  belongs_to :topic
  belongs_to :user

  validates :title, :lat, :lng, presence: true
  validates :area_length, numericality: { greater_than: 0 }
  validate :user_must_have_less_than_maximum_targets

  private

  def user_must_have_less_than_maximum_targets
    return unless user && user.targets.count >= User::MAXIMUM_TARGETS

    errors.add :base,
               I18n.t('.user_must_have_less_than_maximum_targets', max: User::MAXIMUM_TARGETS)
  end
end
