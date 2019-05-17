# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  let(:created_at) { Time.now.in_time_zone }
  let(:ip) { Faker::Internet.public_ip_v4_address }
  let(:ticket) do
    Ticket.new(user_id: user.id, ip: ip,
               created_at: created_at)
  end
  let(:ticket_value) { ticket.encode }
  let(:user) { create :user }

  subject do
    connect "/cable?ticket=#{ticket_value}", headers: headers
    connection
  end

  context 'with valid ticket' do
    it 'successfully connects' do
      expect(subject.current_user).to eq user
    end

    it 'deletes the key in the cache' do
      Rails.cache.fetch(ticket) { ticket }
      expect { subject }.to change { Rails.cache.fetch(ticket) }.to nil
    end
  end

  context 'with no ticket' do
    let(:ticket_value) { nil }

    it 'rejects the connection' do
      expect { subject }.to have_rejected_connection
    end
  end

  context 'with an old ticket' do
    let(:created_at) { Time.now.in_time_zone - 10.minutes }

    it 'rejects the connection' do
      expect { subject }.to have_rejected_connection
    end
  end

  context 'with a ticket from a different ip' do
    before do
      Ticket.new(user_id: user.id, ip: Faker::Internet.public_ip_v4_address,
                 created_at: created_at).encode
    end

    it 'rejects the connection' do
      expect { subject }.to have_rejected_connection
    end
  end
end
