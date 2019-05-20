# frozen_string_literal: true

class TargetSerializer < ActiveModel::Serializer
  attributes :area_length, :id, :lat, :lng, :title

  belongs_to :topic
  belongs_to :user
end
