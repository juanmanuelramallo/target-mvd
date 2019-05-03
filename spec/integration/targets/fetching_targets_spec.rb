require 'rails_helper'

RSpec.describe 'Fetching targets', type: :request do
  let(:user) { create :user }

  subject do
    get '/targets', headers: headers
    data
  end

  context 'user with targets' do
    before do
      3.times { create :target, user: user }
    end

    it 'should return 3 targets' do
      expect(subject.size).to eq 3
    end
  end

  context 'user without targets' do
    it 'should return an empty array' do
      expect(subject.size).to eq 0
    end
  end
end
