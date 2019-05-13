# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /targets', type: :request do
  let(:area_length) { rand 1000 }
  let(:lat) { Faker::Address.latitude }
  let(:lng) { Faker::Address.longitude }
  let(:title) { Faker::Name.name }
  let(:topic) { create :topic }
  let(:user) { create :user }

  let(:params) do
    {
      target: {
        area_length: area_length,
        lat: lat,
        lng: lng,
        title: title,
        topic_id: topic.id
      }
    }
  end

  subject do
    post '/targets', params: params, headers: headers
    data
  end

  context 'valid params' do
    it 'creates the target correctly' do
      expect { subject }.to change { Target.count }.by 1
    end

    it 'has the correct lat' do
      expect(subject['attributes']['lat']).to eq lat
    end

    it 'has the correct lng' do
      expect(subject['attributes']['lng']).to eq lng
    end

    it 'has the correct title' do
      expect(subject['attributes']['title']).to eq title
    end

    it 'has the correct area length' do
      expect(subject['attributes']['area-length']).to eq area_length
    end

    it 'enqueues a broadcast job' do
      expect { subject }.to have_enqueued_job
    end
  end

  context 'missing params' do
    let(:title) { nil }

    before { subject }

    it 'returns the error message' do
      expect(errors['title']).to include "can't be blank"
    end
  end
end
