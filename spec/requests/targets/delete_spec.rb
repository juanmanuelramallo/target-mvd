# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /targets/:id', type: :request do
  let(:user) { create :user }

  subject { delete "/targets/#{target.id}", headers: headers }

  context 'user with target' do
    let(:target) { create :target, user: user }

    before { target }

    it 'destroys the target correctly' do
      expect { subject }.to change { user.reload.targets.count }.by(-1)
    end
  end

  context 'passing a target id from a different user' do
    let(:target) { create :target }

    it 'does not return a successful response' do
      subject
      expect(response.status).to eq 404
    end
  end
end
