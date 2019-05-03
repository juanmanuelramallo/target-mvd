require 'rails_helper'

RSpec.describe Target, type: :model do
  describe 'associations' do
    it { should belong_to(:topic) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lng) }
    it { should validate_numericality_of(:area_length).is_greater_than(0) }
  end
end
