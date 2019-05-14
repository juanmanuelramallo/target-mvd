# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /auth/facebook/callback', type: :request do
  let(:params) do
    {
      facebook: {
        access_token: access_token
      }
    }
  end

  subject do
    post auth_facebook_callback_path, params: params
    response
  end

  context 'valid access token' do
    let(:access_token) { 'acc35T0k3n' }

    context 'existing user' do
      before do
        create :user, email: 'existing-user@example.com'
      end

      it 'allows me to log in' do
        VCR.use_cassette 'facebook_service/valid' do
          expect(subject).to have_http_status(:success)
        end
      end
    end

    context 'creating the user' do
      it 'creates a new user' do
        VCR.use_cassette 'facebook_service/valid' do
          expect { subject }.to change { User.count }.by 1
        end
      end
    end
  end

  context 'invalid access token' do
    let(:access_token) { '123456' }

    it 'returns an error' do
      VCR.use_cassette 'facebook_service/invalid' do
        expect(subject).to have_http_status(:bad_request)
      end
    end
  end
end
