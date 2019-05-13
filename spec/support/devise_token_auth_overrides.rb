# frozen_string_literal: true

module DeviseTokenAuth
  module Concerns
    module User
      def create_token(client_id: nil, token: nil, expiry: nil, **token_extras)
        client_id ||= 'abcdefghijklmnopqrstuv'
        token     ||= '1234567890123456789012'
        expiry    ||= (Time.zone.now + token_lifespan).to_i

        tokens[client_id] = {
          token: BCrypt::Password.create(token),
          expiry: expiry
        }.merge!(token_extras)

        clean_old_tokens

        [client_id, token, expiry]
      end
    end
  end
end
