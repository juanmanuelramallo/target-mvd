require 'rails_helper'

RSpec.describe Topic, type: :model do
  describe 'associations' do
    it { should have_many(:targets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
