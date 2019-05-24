# frozen_string_literal: true

class User < ApplicationRecord
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum gender: %i[unset female male]

  include DeviseTokenAuth::Concerns::User

  MAXIMUM_TARGETS = 10

  has_many :targets, dependent: :destroy

  has_one_attached :avatar

  validates :full_name, presence: true

  def avatar_url
    return unless avatar.attached?

    Rails.application.routes.url_helpers.rails_blob_url avatar
  end

  def compatible_targets
    Target.where(id: targets.flat_map(&:compatible_targets).pluck(:id))
  end

  def conversations
    Conversation.where(initiator_id: id).or Conversation.where(target_id: targets.pluck(:id))
  end
end
