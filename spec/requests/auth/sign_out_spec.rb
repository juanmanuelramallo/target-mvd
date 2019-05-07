# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /auth/sign_out', type: :request do
  let(:access_token) { response.header['access-token'] }
  let(:client) { response.header['client'] }
  let(:uid) { response.header['uid'] }
  let(:headers) do
    {
      'access-token': access_token,
      client: client,
      uid: uid
    }
  end

  subject do
    delete '/auth/sign_out', headers: headers
    response
  end

  context 'logged in user' do
    let(:user) { create :user }

    before do
      post '/auth/sign_in', params: { email: user.email, password: 'P@55word' }
    end

    it 'should allow me to log out' do
      expect(subject).to have_http_status(:success)
    end
  end

  context 'already logged out user' do
    let(:user) { create :user }
    let(:token) { user.create_token }
    let(:access_token) { token[1] }
    let(:client) { token[0] }
    let(:uid) { user.email }

    it "shouldn't allow me to log out again" do
      expect(subject).to have_http_status(:not_found)
    end
  end
end
