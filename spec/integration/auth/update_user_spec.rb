require 'rails_helper'

RSpec.describe 'Update user', type: :request do
  let(:access_token) { response.header['access-token'] }
  let(:client) { response.header['client'] }
  let(:current_password) { 'P@55word' }
  let(:new_email) { Faker::Internet.free_email }
  let(:uid) { response.header['uid'] }
  let(:user) { create :user }
  let(:headers) do
    {
      'access-token': access_token,
      client: client,
      uid: uid
    }
  end
  let(:params) do
    {
      current_password: current_password,
      email: new_email,
      password: 'n3w-P@55word'
    }
  end

  subject do
    put '/auth', params: params, headers: headers
    response
  end

  before :each do
    post '/auth/sign_in', params: { email: user.email, password: 'P@55word' }
  end

  it 'should update the email' do
    expect { subject }.to change { user.reload.email }.to new_email
  end

  context 'given a wrong current password' do
    let(:current_password) { 'wrong-password' }

    it "shouldn't update the email" do
      expect { subject }.to_not change { user.reload.email }
    end
  end
end
