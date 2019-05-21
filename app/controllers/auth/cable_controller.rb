# frozen_string_literal: true

module Auth
  class CableController < ApplicationController
    before_action :authenticate_user!

    def create
      ticket = Ticket.new(user_id: current_user.id, ip: request.remote_ip,
                          created_at: Time.now.in_time_zone)

      render json: ticket if ticket.encode!
    rescue TicketInvalidError
      render_error(:bad_request, I18n.t('errors.cable_ticket_invalid'))
    end
  end
end
