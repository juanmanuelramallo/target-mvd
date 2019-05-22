# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /conversations/:conversation_id/messages', type: :request do
  let(:conversation) { create :conversation_with_messages, messages_count: 3 }
  let(:user) { conversation.initiator }

  subject do
    get conversation_messages_path(conversation), headers: headers
    data
  end

  it 'returns 3 messages' do
    expect(subject.size).to eq 3
  end

  it 'returns messages objects' do
    expect(subject[0]['type']).to eq 'messages'
  end

  it 'returns messages from the conversation' do
    expect(subject[0]['relationships']['conversation']['data']['id']).to eq conversation.id.to_s
  end
end
