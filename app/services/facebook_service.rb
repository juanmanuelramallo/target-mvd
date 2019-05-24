# frozen_string_literal: true

require 'net/http'

class FacebookService
  attr_reader :access_token

  BASE_URL = 'https://graph.facebook.com'

  def self.call!(access_token)
    new(access_token).user!
  end

  def initialize(access_token)
    @access_token = access_token
  end

  def user!
    raise FacebookError, error_message if error?

    User.where(uid: response['email']).first_or_create! do |user|
      user.email = response['email']
      user.full_name = response['name']
      user.password = Devise.friendly_token[0, 20]
      user.provider = 'facebook'
      user.skip_confirmation!
    end
  end

  private

  def error?
    response['error'].present?
  end

  def error_message
    response['error']['message']
  end

  def response
    return @response if @response

    req = Net::HTTP::Get.new url.request_uri
    http = Net::HTTP.new url.host, url.port
    http.use_ssl = true
    res = http.request req
    @response = JSON.parse res.body
  end

  def url
    @url ||= URI.parse "#{BASE_URL}/me?fields=email,name&access_token=#{access_token}"
  end
end
