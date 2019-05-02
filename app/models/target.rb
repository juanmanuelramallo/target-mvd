class Target < ApplicationRecord
  belongs_to :topic
  belongs_to :user

  validates :title, :lat, :lng, presence: true
  validates :area_length, numericality: { greater_than: 0 }
end
