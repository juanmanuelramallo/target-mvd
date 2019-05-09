# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FacebookService' do
  let(:access_token) { '@cc355t0k3N' }
  subject { FacebookService.call!(access_token) }

  context 'creating a user' do
    it 'returns my newly created user' do
      VCR.use_cassette 'facebook_service/valid' do
        expect { subject }.to change { User.count }.by 1
      end
    end
  end

  context 'existing user' do
    let(:user) { create :user, email: 'existing-user@example.com' }

    before { user }

    it 'returns the existing user' do
      VCR.use_cassette 'facebook_service/valid' do
        expect(subject).to eq(user)
      end
    end
  end

  context 'invalid access token' do
    let(:access_token) { '123456' }

    it 'raises an error' do
      VCR.use_cassette 'facebook_service/invalid' do
        expect { subject }.to raise_error(FacebookError)
      end
    end
  end
end
