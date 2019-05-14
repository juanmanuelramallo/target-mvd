# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:conversation) { create :conversation }
  subject { build :message, conversation: conversation, user: conversation.initiator }

  describe 'associations' do
    it { is_expected.to belong_to(:conversation) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'callbacks' do
    context 'after create' do
      it 'enqueues job to broadcast to conversation' do
        expect { subject.save }.to have_enqueued_job(BroadcastNewMessageJob)
      end
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:text) }
  end
end
