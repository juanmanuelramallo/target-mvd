# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /topics', type: :request do
  let(:user) { create :user }

  subject do
    get '/topics', headers: headers
    data
  end

  before { create_list :topic, 3 }

  it 'returns 3 topics' do
    expect(subject.size).to eq 3
  end
end
