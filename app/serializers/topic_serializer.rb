# frozen_string_literal: true

class TopicSerializer < ApplicationSerializer
  attributes :id, :name

  has_many :targets
end
