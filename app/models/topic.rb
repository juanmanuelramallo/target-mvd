# frozen_string_literal: true

class Topic < ApplicationRecord
  has_many :targets, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
