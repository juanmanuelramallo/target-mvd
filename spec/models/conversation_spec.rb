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
end
