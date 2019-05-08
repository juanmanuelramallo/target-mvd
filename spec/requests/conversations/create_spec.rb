# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /conversations', type: :request do
  let(:target) { create :target }
  let(:user) { create :user }

  let(:params) do
    {
      conversation: {
        target_id: target.id,
        initiator_id: user.id
      }
    }
  end

  subject do
    post '/conversations', params: params, headers: headers
    data
  end

  context 'valid params' do
    context 'nonexistent conversation' do
      it 'should create a conversation' do
        expect { subject }.to change { Conversation.count }.by 1
      end
    end

    context 'with an already started conversation' do
      before do
        create :conversation, target: target, initiator: user
      end

      it "shouldn't create a conversation" do
        expect { subject }.to_not change { Conversation.count }
      end
    end

    context 'fetching a conversation initiated by another user' do
      let(:my_target) { create :target, user: user }
      let(:params) do
        {
          conversation: {
            target_id: my_target.id,
            initiator_id: target.user.id
          }
        }
      end

      context 'nonexistent conversation' do
        it 'should create a conversation' do
          expect { subject }.to change { Conversation.count }.by 1
        end
      end

      context 'with an already started conversation' do
        before do
          create :conversation, target: my_target, initiator: target.user
        end

        it "shouldn't create a conversation" do
          expect { subject }.to_not change { Conversation.count }
        end
      end
    end
  end

  context 'missing params' do
    let(:params) do
      {
        conversation: {
          initiator_id: user.id
        }
      }
    end

    before { subject }

    it 'should return an error message' do
      expect(errors['target']).to include 'must exist'
    end
  end
end
