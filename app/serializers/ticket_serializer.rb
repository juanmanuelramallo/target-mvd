# frozen_string_literal: true

class TicketSerializer < ActiveModel::Serializer
  attributes :value

  def value
    object.encode
  end
end
