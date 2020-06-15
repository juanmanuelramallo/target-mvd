# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BroadcastNewMessageJob, type: :job do
  include ActiveJob::TestHelper

  subject { described_class.perform_now(message) }

  let(:conversation) { create :conversation }
  let(:message) { build :message, conversation: conversation, user: conversation.initiator }
  let(:serialized_message) { MessageSerializer.new(message).serialized_json }

  it 'broadcasts to the conversation channel' do
    expect { subject }.to have_broadcasted_to(conversation)
      .from_channel(ConversationsChannel)
      .with(serialized_message)
  end
end
