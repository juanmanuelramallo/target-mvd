# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /targets/:id', type: :request do
  let(:area_length) { rand(1..1000) }
  let(:lat) { Faker::Address.latitude.round(11) }
  let(:lng) { Faker::Address.longitude.round(11) }
  let(:target) { create :target }
  let(:title) { Faker::Name.name }
  let(:topic) { create :topic }
  let(:user) { target.user }

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
    put target_path(target), params: params, headers: headers
    data
  end

  before { target }

  context 'valid params' do
    it 'does not create a new target' do
      expect { subject }.to_not change { Target.count }
    end

    it 'has the correct lat' do
      expect { subject }.to change { target.reload.lat }.to lat
    end

    it 'has the correct lng' do
      expect { subject }.to change { target.reload.lng }.to lng
    end

    it 'has the correct title' do
      expect { subject }.to change { target.reload.title }.to title
    end

    it 'has the correct area length' do
      expect { subject }.to change { target.reload.area_length }.to area_length
    end
  end

  context 'missing title param' do
    let(:title) { nil }

    before { subject }

    it 'returns an error message' do
      expect(errors['title']).to include "can't be blank"
    end
  end
end
