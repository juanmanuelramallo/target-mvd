# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Conversation, type: :model do
  subject { create :conversation }

  describe 'associations' do
    it { is_expected.to have_many(:messages).dependent(:destroy) }
    it { is_expected.to belong_to(:target) }
    it { is_expected.to belong_to(:initiator) }
  end

  describe 'validations' do
    subject { create :conversation }

    context 'has a target compatible with the initiator' do
      context 'conversation valid' do
        it 'is valid' do
          expect(subject.valid?).to be true
        end
      end

      context 'conversation invalid' do
        subject { build :conversation, target: target, initiator: target.user }
        let(:target) { create :target }

        it 'is invalid' do
          expect(subject.valid?).to be false
        end
      end
    end
  end

  describe '#unread?' do
    subject { conversation.unread? user }

    let(:conversation) { create :conversation_with_messages }
    let(:user) { conversation.initiator }

    context 'user is the last to send a message' do
      before do
        create :message, conversation: conversation, user: user
      end

      it 'always returns false' do
        expect(subject).to eq false
      end
    end

    context 'user is the second last to send a message' do
      before do
        create :message, conversation: conversation, user: conversation.target.user
      end

      context 'user has not read the conversation' do
        before do
          conversation.update unread: true
        end

        it 'returns true' do
          expect(subject).to eq true
        end
      end

      context 'user has already read the conversation' do
        it 'returns false' do
          expect(subject).to eq false
        end
      end
    end

    context 'no messages in conversation' do
      let(:conversation) { create :conversation }
      let(:user) { conversation.initiator }

      it 'returns false' do
        expect(subject).to eq false
      end
    end
  end
end
