# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  subject do
    connect '/cable', headers: headers
    connection
  end

  context 'with valid user' do
    let(:user) { create :user }

    it 'successfully connects' do
      expect(subject.current_user).to eq user
    end
  end

  context 'with anonymous user' do
    let(:headers) do
      {
        'access-token': 'fake_token',
        'token-type': 'Bearer',
        client: 'fake_client',
        expiry: '123456',
        uid: 'fake_uid@example.com'
      }
    end

    it 'rejects the connection' do
      expect { subject }.to have_rejected_connection
    end
  end
end
