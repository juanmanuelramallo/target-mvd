# frozen_string_literal: true

class TopicSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :targets
end
