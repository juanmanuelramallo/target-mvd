# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /auth', type: :request do
  let(:email) { Faker::Internet.email }
  let(:params) do
    {
      avatar: avatar,
      email: email,
      full_name: full_name,
      gender: gender,
      password: password
    }
  end
  let(:avatar) { nil }
  let(:full_name) { 'Jorge Drexler' }
  let(:password) { Faker::Internet.password(8) }
  let(:gender) { 'male' }

  subject { post '/auth', params: params }

  it 'sends a confirmation mail' do
    expect { subject }.to change { ActionMailer::Base.deliveries.count }.by 1
  end

  context 'valid data' do
    before { subject }

    it 'creates the user' do
      expect(response).to have_http_status(:success)
    end

    it 'has the correct name' do
      expect(attributes['fullName']).to eq full_name
    end
  end

  context 'with an avatar' do
    let(:avatar) do
      fixture_file_upload(Rails.root.join('spec', 'support', 'avatar.png'), 'image/png')
    end

    before { subject }

    it 'has an avatar attached' do
      expect(attributes['avatarUrl']).to include '/avatar.png'
    end
  end

  context 'invalid data' do
    before { subject }

    context 'empty email' do
      let(:email) { '' }

      it "doesn't create the user" do
        expect(errors).to include "can't be blank"
      end
    end

    context 'empty password' do
      let(:password) { '' }

      it "doesn't create the user" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'too short password' do
      let(:password) { Faker::Internet.password(1, 5) }

      it "doesn't create the user" do
        expect(errors).to include 'is too short (minimum is 6 characters)'
      end
    end
  end
end
