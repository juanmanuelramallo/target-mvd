# frozen_string_literal: true

class User < ApplicationRecord
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include DeviseTokenAuth::Concerns::User

  MAXIMUM_TARGETS = 10

  has_many :targets, dependent: :destroy

  def compatible_targets
    targets.flat_map(&:compatible_targets).uniq
  end

  def conversations
    Conversation.where(initiator_id: id).or Conversation.where(target_id: targets.pluck(:id))
  end
end
