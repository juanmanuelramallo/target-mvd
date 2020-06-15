# frozen_string_literal: true

class Ticket
  include ActiveModel::Model
  def initialize(args)
    super(args)
  end

  def cache_key
    "users/#{user_id}/cable_ticket"
  end

  def encode!
    raise TicketInvalidError unless valid?

    encode
  end

  def encode
    Rails.cache.fetch(self, expires_in: 5.minutes) do
      self
    end

    Base64.urlsafe_encode64({ user_id: user_id, ip: ip, created_at: created_at }.to_json)
  end

  private

  def created_at_must_be_less_than_5_minutes
    errors.add(:created_at) if created_at < (Time.now.in_time_zone - 5.minutes)
  end

  attr_accessor :user_id, :ip, :created_at

  validates :user_id, :ip, :created_at, presence: true
  validate :created_at_must_be_less_than_5_minutes

  def id
    0
  end
end
