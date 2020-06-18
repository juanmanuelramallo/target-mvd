# frozen_string_literal: true

class MessageSerializer < ApplicationSerializer
  attributes :text, :created_at

  belongs_to :conversation
  belongs_to :user
end
