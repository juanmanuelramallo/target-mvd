# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe 'associations' do
    it { should have_many(:messages).dependent(:destroy) }
    it { should belong_to(:target) }
    it { should belong_to(:initiator) }
  end
end
