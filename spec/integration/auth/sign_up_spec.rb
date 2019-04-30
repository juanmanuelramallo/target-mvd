require 'rails_helper'

RSpec.describe 'Sign up user', type: :request do
  let(:params) do
    {
      email: email,
      password: password
    }
  end

  subject { post '/auth', params: params }

  before(:each) { subject }

  context 'valid data' do
    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Internet.password(8) }

    it 'should create the user' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'invalid data' do
    context 'empty email' do
      let(:email) { '' }
      let(:password) { Faker::Internet.password(8) }

      it "shouldn't create the user" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'empty password' do
      let(:email) { Faker::Internet.email }
      let(:password) { '' }

      it "shouldn't create the user" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'too short password' do
      let(:email) { Faker::Internet.email }
      let(:password) { Faker::Internet.password(1, 5) }

      it "shouldn't create the user" do
        expect(errors['password'][0]).to include 'is too short'
      end
    end
  end
end
