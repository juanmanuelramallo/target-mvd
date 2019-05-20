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

    before { subject }

    it 'does not return a successful response' do
      expect(errors).to include "Couldn't find the record"
    end
  end

  context 'target with conversation' do
    let(:conversation) { create :conversation }
    let(:target) { conversation.target }
    let(:user) { conversation.target.user }

    it 'enqueues a job to disable the conversation' do
      expect { subject }.to have_enqueued_job(DisableConversationsJob)
    end
  end
end
