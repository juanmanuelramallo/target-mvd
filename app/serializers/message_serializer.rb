# frozen_string_literal: true

class MessageSerializer < ActiveModel::Serializer
  attributes :text, :created_at
end
