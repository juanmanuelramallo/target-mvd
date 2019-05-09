# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      uid = headers['uid']
      token = headers['access-token']
      client = headers['client']
      user = User.find_by(uid: uid)

      if user&.valid_token?(token, client)
        user
      else
        reject_unauthorized_connection
      end
    end

    def headers
      @headers ||= request.headers
    end
  end
end
