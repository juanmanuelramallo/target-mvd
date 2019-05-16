# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ConversationService' do
  let(:args) do
    {
      current_user: current_user,
      target_id: target_id
    }
  end
  let(:current_user) { user }
  let(:lat) { user.targets.first.lat }
  let(:lng) { user.targets.first.lng }
  let(:target) { create :target, lat: lat, lng: lng, topic: topic }
  let(:target_id) { target.id }
  let(:topic) { user.targets.first.topic }
  let(:user) { create :user_with_targets, targets_count: 1 }

  subject { ConversationService.call(args) }

  context 'building a conversation' do
    it 'returns a new conversation record' do
      expect(subject.new_record?).to eq true
    end

    context 'as a user owning the target' do
      let(:target) { current_user.targets.first }

      it 'raises an error' do
        expect { subject }.to raise_error ConversationWithSameUserError
      end
    end
  end
end
