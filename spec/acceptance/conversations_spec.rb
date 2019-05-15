# frozen_string_literal: true

require_relative '../support/acceptance_tests_helper'

resource 'Conversations' do
  header 'Content-Type', 'application/json'
  header 'access-token', :access_token_header
  header 'client', :client_header
  header 'uid', :uid_header

  let(:conversation) { create :conversation }
  let(:conversation_with_messages) do
    create :conversation_with_messages, initiator: conversation.initiator,
                                        target: conversation.target
  end
  let(:user) { conversation.initiator }

  before { create_list :conversation, 3, initiator: user }

  route '/conversations', 'Conversations collection' do
    post 'Create' do
      with_options scope: :conversation, required: true do
        attribute :target_id, 'Target associated to the conversation'
        attribute :initiator_id, 'ID of the user whom initiated the conversation'
      end

      let(:target_id) { conversation.target_id }
      let(:initiator_id) { conversation.initiator_id }

      example 'Ok' do
        do_request

        expect(status).to eq 201
      end
    end

    get 'Index' do
      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end
  end

  route '/conversations/:id', 'Conversation member' do
    let(:id) { conversation_with_messages.id }

    get 'Show' do
      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end

    put 'Update' do
      with_options scope: :conversation, required: true do
        attribute :unread, 'Flag to mark the conversation as unread'
      end

      let(:unread) { false }

      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end
  end
end
