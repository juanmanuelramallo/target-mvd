# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Target, type: :model do
  subject { build :target }

  describe 'associations' do
    it { is_expected.to belong_to(:topic) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'callbacks' do
    context 'after create' do
      it 'enqueues job to broadcast to compatible users' do
        expect { subject.save }.to have_enqueued_job(BroadcastCompatibleTargetsJob)
      end
    end

    context 'after update' do
      let(:target) { create :target }
      subject { target.update(title: 'New title') }

      it 'enqueues job to update conversations involving the target' do
        expect { subject }.to have_enqueued_job(UpdateConversationsStatusJob)
      end
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:lat) }
    it { is_expected.to validate_presence_of(:lng) }
    it { is_expected.to validate_numericality_of(:area_length).is_greater_than(0) }

    context 'user must have less than 10 targets' do
      let(:target) { build :target, user: user }
      let(:user) { create :user }

      context 'user with less than 10 targets' do
        it 'is valid' do
          expect(target.valid?).to be true
        end
      end

      context 'user with more than 10 targets' do
        before do
          10.times { create :target, user: user }
        end

        it 'is not be valid' do
          expect(target.valid?).to be false
        end
      end
    end
  end

  describe '#compatible_targets' do
    subject { target.compatible_targets }

    let(:lat) { Faker::Address.latitude }
    let(:lng) { Faker::Address.longitude }
    let(:target) { create :target, lat: lat, lng: lng, area_length: 1500 }

    context 'with one compatible target' do
      let(:expected_target) do
        create(:target, topic: target.topic, area_length: 2000, lat: lat + 0.001, lng: lng + 0.001)
      end

      before do
        expected_target
        create :target, topic: target.topic, area_length: 1000, lat: lat + 1, lng: lng + 1
      end

      it 'returns one target' do
        expect(subject).to eq [expected_target]
      end
    end

    context 'with no compatible targets' do
      before do
        create :target, topic: target.topic, area_length: 1000, lat: lat + 1, lng: lng + 1
        create :target, topic: target.topic, area_length: 10_000, lat: lat - 1, lng: lng - 1
      end

      it 'returns zero targets' do
        expect(subject).to eq []
      end
    end
  end
end
