require 'rails_helper'

RSpec.describe Topic, type: :model do
  subject { create :topic }

  describe 'associations' do
    it { should have_many(:targets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
