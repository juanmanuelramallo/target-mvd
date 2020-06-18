# frozen_string_literal: true

class TicketSerializer < ApplicationSerializer
  attributes :id, :user_id, :ip, :created_at, :value

  attribute :value, &:encode
end
