require 'rails_helper'

RSpec.describe "Signing user in", type: :request do
  let(:user) { create :user }
  let(:password) { "P@55word" }
  let(:params) do
    {
      email: user.email,
      password: password
    }
  end

  subject { post "/auth/sign_in", params: params }

  before(:each) { subject }

  context "valid user" do
    it "should allow me to log in" do
      expect(response).to have_http_status(:success)
    end
  end

  context "invalid user" do
    context "inexistent user" do
      let(:user) { build :user }

      it "shouldn't allow me to log in" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "wrong password" do
      let(:password) { "123456" }

      it "shouldn't allow me to log in" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
