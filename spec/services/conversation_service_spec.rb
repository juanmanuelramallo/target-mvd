# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ConversationService' do
  let(:args) do
    {
      current_user: current_user,
      initiator_id: initiator_id,
      target_id: target_id
    }
  end
  let(:current_user) { user }
  let(:initiator_id) { user.id }
  let(:lat) { user.targets.first.lat }
  let(:lng) { user.targets.first.lng }
  let(:target) { create :target, lat: lat, lng: lng, topic: topic }
  let(:target_id) { target.id }
  let(:topic) { user.targets.first.topic }
  let(:user) { create :user_with_targets, targets_count: 1 }

  subject { ConversationService.call(args) }

  context 'building a conversation' do
    context 'as the initiator' do
      it 'returns a new conversation record' do
        expect(subject.new_record?).to eq true
      end
    end

    context 'as a the receiver' do
      let(:initiator_id) { target.user.id }
      let(:target_id) { user.targets.first.id }

      it 'returns a new conversation record' do
        expect(subject.new_record?).to eq true
      end
    end

    context 'as a user not related to the target or the initiator' do
      let(:current_user) { create :user_with_targets }

      it 'raises an error' do
        expect { subject }.to raise_error ConversationNotAllowedError
      end
    end
  end
end
