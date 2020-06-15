# frozen_string_literal: true

require_relative '../support/acceptance_tests_helper'

resource 'Messages' do
  header 'Content-Type', 'application/json'
  header 'access-token', :access_token_header
  header 'client', :client_header
  header 'uid', :uid_header

  let(:conversation) { create :conversation_with_messages, messages_count: 35 }
  let(:message) { build :message, conversation: conversation, user: user }
  let(:user) { conversation.initiator }

  route '/conversations/:conversation_id/messages', 'Messages collection' do
    let(:conversation_id) { conversation.id }

    post 'Create' do
      with_options scope: :message, required: true do
        response_field :text, 'Text of the message'
        response_field :created_at, 'Created at timestamp'
        response_field :user_id, 'Sender of the message'
      end

      with_options scope: :message, required: true do
        attribute :text, 'Message to send'
      end

      let(:text) { message.text }

      example 'Ok' do
        request = {
          'data' => {
            'type' => 'message',
            'attributes' => {
              'text' => text
            }
          }
        }
        do_request(request)

        expect(status).to eq 201
      end

      example 'Bad' do
        request = {
          'data' => {
            'type' => 'message',
            'attributes' => {
              'text' => ''
            }
          }
        }
        do_request(request)

        expect(status).to eq 422
      end
    end

    get 'Index' do
      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end
  end
end
