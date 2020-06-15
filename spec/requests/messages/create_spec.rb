# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /conversations/:conversation_id/messages', type: :request do
  let(:conversation) { create :conversation }
  let(:message) { build :message, conversation: conversation, user: user }
  let(:user) { conversation.initiator }

  let(:params) do
    {
      message: {
        text: message.text
      }
    }
  end

  subject do
    post "/conversations/#{conversation.id}/messages", params: params, headers: headers
    data
  end

  context 'sending a message with valid params' do
    context 'to one of my conversations' do
      it 'creates a message' do
        expect { subject }.to change { conversation.messages.count }
      end
    end

    context "to a conversation the user doesn't belong to" do
      let(:user) { create :user }

      before { subject }

      it 'returns a not found error code' do
        expect(response.status).to eq 404
      end
    end

    context 'as the receiver of the conversation' do
      let(:user) { conversation.target.user }

      it 'creates a message' do
        expect { subject }.to change { conversation.messages.count }
      end
    end
  end

  context 'missing params' do
    let(:params) do
      {
        message: {
          text: nil
        }
      }
    end

    before { subject }

    it 'returns an error message' do
      expect(errors).to include "Text can't be blank"
    end
  end

  context 'given a disabled conversation' do
    before do
      conversation.update!(status: :disabled)
      subject
    end

    it 'returns an error' do
      expect(errors).to include 'Conversation must be active'
    end
  end
end
