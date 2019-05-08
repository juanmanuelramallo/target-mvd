# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create :user }

  describe 'associations' do
    it { should have_many(:targets).dependent(:destroy) }
  end

  describe '#compatible_targets' do
    let(:user) { create :user }

    subject { user.compatible_targets }

    context 'user with compatible targets' do
      let(:lat) { Faker::Address.latitude }
      let(:lng) { Faker::Address.longitude }
      let(:target) { create :target, user: user, lat: lat, lng: lng, area_length: 1500 }
      let(:another_target) do
        create :target, user: user, lat: lat + 0.05, lng: lng + 0.05, area_length: 3000
      end
      let(:expected_targets) do
        [
          create(:target, topic: target.topic, area_length: 2000, lat: lat + 0.001,
                          lng: lng + 0.001),
          create(:target, topic: target.topic, area_length: 5000, lat: lat - 0.001,
                          lng: lng - 0.001)
        ]
      end

      before do
        target
        another_target
        expected_targets
      end

      it 'should return 2 unique targets' do
        expect(subject).to eq expected_targets
      end
    end

    context 'user without targets' do
      it 'should return an empty collection' do
        expect(subject).to eq []
      end
    end
  end

  describe '#conversations' do
    let(:user) { create :user_with_targets }
    subject { user.conversations }

    context 'user with conversations' do
      before { create_list :conversation, 3, initiator: user }

      it 'should return 3 conversations' do
        expect(subject.size).to eq 3
      end
    end

    context 'user with conversations as the receiver' do
      let(:conversation) { create :conversation }
      let(:user) { conversation.target.user }

      it 'should return 1 conversation' do
        expect(subject.size).to eq 1
      end
    end

    context 'user without conversations' do
      it 'should return an empty collection' do
        expect(subject.size).to eq 0
      end
    end
  end
end
