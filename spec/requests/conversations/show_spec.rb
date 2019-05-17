# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /conversations/:id', type: :request do
  let(:conversation) { create :conversation }

  subject do
    get "/conversations/#{conversation.id}", headers: headers
    data
  end

  context 'given the current user is the initiator of the conversation' do
    let(:user) { conversation.initiator }

    it 'returns my conversation' do
      expect(subject['id']).to eq conversation.id.to_s
    end
  end

  context 'given the current user is the receiver of the conversation' do
    let(:user) { conversation.target.user }

    it 'returns my conversation' do
      expect(subject['id']).to eq conversation.id.to_s
    end
  end

  context 'given the current user tries to fetch a conversation from another user' do
    let(:user) { create :user }

    it 'does not return a successful response' do
      subject
      expect(response.status).to eq 404
    end
  end

  context 'asking for included objects' do
    let(:conversation) { create :conversation_with_messages }
    let(:user) { conversation.initiator }

    subject do
      get "/conversations/#{conversation.id}?include=#{includes}", headers: headers
      json_response
    end

    context 'including messages' do
      let(:includes) { 'messages' }

      it 'returns the messages along with the conversation' do
        expect(subject['included'][0]['type']).to eq 'messages'
      end
    end

    context 'including messages and target' do
      let(:includes) { 'messages,target' }

      it 'returns both included keys' do
        expect(subject['included'].size).to eq(conversation.messages.count + 1)
      end
    end

    context 'including a unpermitted object' do
      let(:includes) { 'user' }

      it 'does not return an included key' do
        expect(subject['included']).to be nil
      end
    end
  end
end
