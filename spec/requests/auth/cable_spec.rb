# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /auth/cable', type: :request do
  let(:user) { create :user }

  subject do
    post auth_cable_path, headers: headers
    data
  end

  it 'updates the cache' do
    expect { subject }.to change { Rails.cache.exist?("users/#{user.id}/cable_ticket") }
  end

  it 'generates a valid ticket' do
    expect(CableTicketValidationService.call!(subject['attributes']['value'])).to eq user
  end
end
