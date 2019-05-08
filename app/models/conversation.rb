# frozen_string_literal: true

class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy

  belongs_to :target
  belongs_to :initiator, class_name: 'User'
end
