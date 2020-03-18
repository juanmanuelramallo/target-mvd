# frozen_string_literal: true

class CableTicketValidationService
  attr_reader :encoded_ticket

  def self.call!(encoded_ticket)
    new(encoded_ticket).validate!
  end

  def initialize(encoded_ticket)
    @encoded_ticket = encoded_ticket
  end

  def validate!
    raise TicketInvalidError unless valid?

    Rails.cache.delete(ticket)

    user
  end

  private

  def cached_ticket
    @cached_ticket ||= Rails.cache.fetch(ticket)
  end

  def decode_ticket(enc)
    raise TicketInvalidError if enc.blank?

    parsed_json = JSON.parse(Base64.urlsafe_decode64(enc))

    Ticket.new(parsed_json.slice('user_id', 'ip', 'created_at'))
  end

  def ticket
    @ticket ||= decode_ticket(encoded_ticket)
  end

  def user
    @user ||= User.find(ticket.user_id)
  end

  def valid?
    cached_ticket.ip == ticket.ip && cached_ticket.valid?
  end
end
