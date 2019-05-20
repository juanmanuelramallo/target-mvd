# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /auth', type: :request do
  let(:params) do
    {
      email: email,
      password: password
    }
  end

  subject do
    post '/auth', params: params
    response
  end

  context 'valid data' do
    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Internet.password(8) }

    it 'creates the user' do
      expect(subject).to have_http_status(:success)
    end

    it 'sends a confirmation mail' do
      expect { subject }.to change { ActionMailer::Base.deliveries.count }.by 1
    end
  end

  context 'invalid data' do
    context 'empty email' do
      let(:email) { '' }
      let(:password) { Faker::Internet.password(8) }

      before { subject }

      it "doesn't create the user" do
        expect(errors).to include "can't be blank"
      end
    end

    context 'empty password' do
      let(:email) { Faker::Internet.email }
      let(:password) { '' }

      it "doesn't create the user" do
        expect(subject).to have_http_status(:unprocessable_entity)
      end
    end

    context 'too short password' do
      let(:email) { Faker::Internet.email }
      let(:password) { Faker::Internet.password(1, 5) }

      before { subject }

      it "doesn't create the user" do
        expect(errors).to include 'is too short (minimum is 6 characters)'
      end
    end
  end
end
