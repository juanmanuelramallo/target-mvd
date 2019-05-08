# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Conversation, type: :model do
  subject { create :conversation }

  describe 'associations' do
    it { should have_many(:messages).dependent(:destroy) }
    it { should belong_to(:target) }
    it { should belong_to(:initiator) }
  end

  describe 'validations' do
    subject { create :conversation }

    context 'should have a target compatible with the initiator' do
      context 'conversation valid' do
        it 'should be valid' do
          expect(subject.valid?).to be true
        end
      end

      context 'conversation invalid' do
        subject { build :conversation, target: target, initiator: target.user }
        let(:target) { create :target }

        it 'should be invalid' do
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

      it 'should always return false' do
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

        it 'should return true' do
          expect(subject).to eq true
        end
      end

      context 'user has already read the conversation' do
        it 'should return false' do
          expect(subject).to eq false
        end
      end
    end

    context 'no messages in conversation' do
      let(:conversation) { create :conversation }
      let(:user) { conversation.initiator }

      it 'should return false' do
        expect(subject).to eq false
      end
    end
  end
end
