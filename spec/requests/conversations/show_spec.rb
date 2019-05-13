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
      expect(subject['id']).to eq conversation.id
    end
  end

  context 'given the current user is the receiver of the conversation' do
    let(:user) { conversation.target.user }

    it 'returns my conversation' do
      expect(subject['id']).to eq conversation.id
    end
  end

  context 'given the current user tries to fetch a conversation from another user' do
    let(:user) { create :user }

    it 'does not return a successful response' do
      subject
      expect(response.status).to eq 404
    end
  end
end
