# frozen_string_literal: true

require_relative '../support/acceptance_tests_helper'

resource 'Conversations' do
  header 'Content-Type', 'application/json'
  header 'access-token', :access_token_header
  header 'client', :client_header
  header 'uid', :uid_header

  let(:conversation) { create :conversation }
  let(:conversation_with_messages) { create :conversation_with_messages }

  before { create_list :conversation, 3, initiator: user }

  route '/conversations', 'Conversations collection' do
    post 'Create' do
      with_options scope: :conversation, required: true do
        attribute :target_id, 'Target associated to the conversation'
      end

      let(:user) { create :user_with_targets }
      let(:conversation) { build :conversation, initiator: user }
      let(:target_id) { conversation.target_id }

      example 'Ok' do
        request = {
          'data' => {
            'type' => 'conversation',
            'attributes' => {},
            'relationships' => {
              'target' => {
                'data' => {
                  'type' => 'target',
                  'id' => target_id
                }
              }
            }
          }
        }

        do_request(request)

        expect(status).to eq 201
      end

      example 'Bad' do
        do_request conversation: { target_id: user.targets.first.id }

        expect(status).to eq 422
      end
    end

    get 'Index' do
      let(:user) { conversation.initiator }

      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end
  end

  route '/conversations/:id', 'Conversation member' do
    let(:user) { conversation_with_messages.initiator }
    let(:id) { conversation_with_messages.id }

    get 'Show' do
      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end

    put 'Update' do
      let(:user) { conversation_with_messages.initiator }

      with_options scope: :conversation, required: true do
        attribute :unread, 'Flag to mark the conversation as unread'
      end

      let(:unread) { false }

      example 'Ok' do
        request = {
          'data' => {
            'type' => 'conversation',
            'attributes' => {
              'unread' => unread
            }
          }
        }
        do_request(request)

        expect(status).to eq 200
      end
    end
  end
end
