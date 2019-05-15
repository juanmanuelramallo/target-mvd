# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /topics', type: :request do
  let(:user) { create :user }
  let(:topics) { create_list :topic, 3 }

  subject do
    get topics_path, headers: headers
    data
  end

  before { topics }

  it 'returns 3 topics' do
    expect(subject.size).to eq 3
  end

  it 'returns different topics' do
    topic_names = subject.map { |topic| topic['attributes']['name'] }
    expect(topic_names).to eq topics.map(&:name)
  end
end
