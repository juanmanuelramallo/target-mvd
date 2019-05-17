# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateConversationsStatusJob, type: :job do
  include ActiveJob::TestHelper

  subject { described_class.perform_now(target) }
  let(:target) { conversation.target }

  let(:topic) { create :topic }

  context 'target with one conversation' do
    let(:conversation) { create :conversation }

    before do
      target.update(topic: topic)
    end

    it 'marks the conversation as disabled' do
      expect { subject }.to change { conversation.reload.status }.to 'disabled'
    end
  end

  context 'target with a disabled conversation' do
    let(:conversation) { create :conversation, status: :disabled }

    before do
      target.update(topic: topic)
    end

    it 'does not update the conversation status' do
      expect { subject }.to_not change { conversation.reload.status }
    end
  end
end
