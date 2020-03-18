# frozen_string_literal: true

class TicketSerializer < ApplicationSerializer
  attributes :id, :user_id, :ip, :created_at
  attribute :value, &:encode
end
