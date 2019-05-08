# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Conversations' do
  header 'access-token', :access_token_header
  header 'client', :client_header
  header 'uid', :uid_header

  let(:conversation) { create :conversation }
  let(:user) { conversation.initiator }

  before { create_list :conversation, 3, initiator: user }

  route '/conversations', 'Conversations collection' do
    post 'Create' do
      with_options scope: :conversation, required: true do
        attribute :target_id, 'Target associated to the conversation'
        attribute :initiator_id, 'ID of the user whom initiated the conversation'
      end

      with_options scope: :target, required: true do
        response_field :messages, 'Array of messages'
        response_field :target, 'Target object'
        response_field :initiator, 'Initiator user'
        response_field :unread, 'Unread indicator for the current user'
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
end
