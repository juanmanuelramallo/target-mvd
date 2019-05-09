# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topic, type: :model do
  subject { create :topic }

  describe 'associations' do
    it { is_expected.to have_many(:targets) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
