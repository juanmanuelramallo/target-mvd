# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /conversations', type: :request do
  let(:user) { create :user_with_targets }

  subject do
    get '/conversations', headers: headers
    data
  end

  before { create_list :conversation, 5, initiator: user }

  it 'should return my 5 conversations' do
    expect(subject.size).to eq 5
  end
end
