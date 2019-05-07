# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /auth/password', type: :request do
  let(:params) do
    {
      email: email,
      redirect_url: '/reset-password'
    }
  end

  subject do
    post '/auth/password', params: params
    response
  end

  context 'valid user' do
    let(:user) { create :user }
    let(:email) { user.email }

    it 'should send me an email' do
      expect { subject }.to change { ActionMailer::Base.deliveries.count }.by 1
    end
  end

  context 'invalid user' do
    let(:email) { 'fake-user@example.com' }

    it "shouldn't send me an email" do
      expect { subject }.to change { ActionMailer::Base.deliveries.count }.by 0
    end
  end
end
