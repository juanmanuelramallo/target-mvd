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
end
