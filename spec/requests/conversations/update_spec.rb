# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /conversations/:id', type: :request do
  let(:conversation) { create :conversation_with_messages, unread: true }
  let(:params) do
    {
      conversation: {
        unread: unread
      }
    }
  end
  let(:user) { conversation.initiator }

  subject do
    put conversation_path(conversation), params: params, headers: headers
    data
  end

  context 'given the second last user sends a message in the conversation' do
    before :each do
      create :message, user: conversation.target.user, conversation: conversation
    end

    context 'and the last user want to mark the conversation as read' do
      let(:unread) { false }

      it 'updates the conversation' do
        expect { subject }.to change { conversation.reload.unread }.from(true).to(false)
      end
    end

    context 'and the conversation is already read' do
      let(:unread) { true }

      before { conversation.update(unread: false) }

      it 'updates the conversation to be marked as unread' do
        expect { subject }.to change { conversation.reload.unread }.from(false).to(true)
      end
    end
  end

  context 'given the very last user sends a message in the conversation' do
    before :each do
      create :message, user: user, conversation: conversation
    end

    context 'and the second last user wants to mark the conversation as read' do
      let(:unread) { false }

      it "doesn't update the unread attribute" do
        expect { subject }.to_not change { conversation.reload.unread }
      end
    end
  end

  context 'given a disabled conversation' do
    let(:unread) { true }

    before do
      conversation.update!(status: :disabled)
      subject
    end

    it 'returns an error' do
      expect(errors).to include "Can't update a disabled conversation"
    end
  end
end
