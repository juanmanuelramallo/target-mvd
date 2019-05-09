# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /conversations', type: :request do
  let(:lat) { user.targets.first.lat }
  let(:lng) { user.targets.first.lng }
  let(:target) { create :target, lat: lat, lng: lng, topic: topic }
  let(:topic) { user.targets.first.topic }
  let(:user) { create :user_with_targets, targets_count: 1 }

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
      it 'creates a conversation' do
        expect { subject }.to change { Conversation.count }.by 1
      end
    end

    context 'with an already started conversation' do
      before do
        create :conversation, target: target, initiator: user
      end

      it "doesn't create a conversation" do
        expect { subject }.to_not change { Conversation.count }
      end
    end

    context 'fetching a conversation initiated by another user' do
      let(:my_target) { create :target, user: user, lat: lat, lng: lng, topic: topic }
      let(:params) do
        {
          conversation: {
            target_id: my_target.id,
            initiator_id: target.user.id
          }
        }
      end

      context 'nonexistent conversation' do
        it 'creates a conversation' do
          expect { subject }.to change { Conversation.count }.by 1
        end
      end

      context 'with an already started conversation' do
        before do
          create :conversation, target: my_target, initiator: target.user
        end

        it "doesn't create a conversation" do
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

    it 'returns an error message' do
      expect(errors['target']).to include 'must exist'
    end
  end
end
