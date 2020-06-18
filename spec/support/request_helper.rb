# frozen_string_literal: true

module RequestHelper
  def access_token_header
    request_headers['access-token']
  end

  def client_header
    request_headers['client']
  end

  def headers
    @headers ||= user.create_new_auth_token.merge(
      'Content-Type' => 'application/vnd.api+json',
      'Accept' => 'application/vnd.api+json'
    )
  end

  def uid_header
    request_headers['uid']
  end

  alias request_headers headers
end
