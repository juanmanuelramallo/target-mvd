# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /auth/password', type: :request do
  let(:params) do
    {
      password: password,
      password_confirmation: password_confirmation
    }
  end
  let(:password) { 'p@55word' }
  let(:password_confirmation) { password }
  let(:user) { create :user }

  subject do
    put '/auth/password', params: params, headers: headers
    response
  end

  context 'valid params' do
    it 'updates the password' do
      expect(subject).to have_http_status(:ok)
    end
  end

  context 'password does not match' do
    let(:password_confirmation) { 'another-password' }

    before { subject }

    it 'returns an error' do
      expect(errors).to include "doesn't match Password"
    end
  end
end
