# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = CableTicketValidationService.call!(ticket)
    rescue TicketInvalidError
      reject_unauthorized_connection
    end

    private

    def ticket
      request.query_parameters[:ticket]
    end
  end
end
