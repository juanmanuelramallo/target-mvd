# frozen_string_literal: true

module FrontendUrlService
  def self.confirmed_url
    # FIXME: Use actual confirmation url in the frontend
    "#{ENV.fetch('FRONTEND_HOST')}/users/confirmed"
  end
end
