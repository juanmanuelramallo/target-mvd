# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Conversations' do
  header 'access-token', :access_token_header
  header 'client', :client_header
  header 'uid', :uid_header

  let(:user) { create :user }

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
      end

      let(:target) { create :target }
      let(:target_id) { target.id }
      let(:initiator_id) { user.id }

      example 'Ok' do
        do_request

        expect(status).to eq 201
      end
    end
  end
end
