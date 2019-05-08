# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Target, type: :model do
  subject { build :target }

  describe 'associations' do
    it { should belong_to(:topic) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lng) }
    it { should validate_numericality_of(:area_length).is_greater_than(0) }

    context 'user must have less than 10 targets' do
      let(:target) { build :target, user: user }
      let(:user) { create :user }

      context 'user with less than 10 targets' do
        it 'should be valid' do
          expect(target.valid?).to be true
        end
      end

      context 'user with more than 10 targets' do
        before do
          10.times { create :target, user: user }
        end

        it "shouldn't be valid" do
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
        create(:target, topic: target.topic, area_length: 2000, lat: lat + 0.01, lng: lng + 0.01)
      end

      before do
        expected_target
        create :target, topic: target.topic, area_length: 1000, lat: lat + 1, lng: lng + 1
      end

      it 'should return one target' do
        expect(subject).to eq [expected_target]
      end
    end

    context 'with no compatible targets' do
      before do
        create :target, topic: target.topic, area_length: 1000, lat: lat + 1, lng: lng + 1
        create :target, topic: target.topic, area_length: 10_000, lat: lat - 1, lng: lng - 1
      end

      it 'should return zero targets' do
        expect(subject).to eq []
      end
    end
  end
end
