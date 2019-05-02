require 'rails_helper'

RSpec.describe 'Create target', type: :request do
  let(:area_length) { rand 1000 }
  let(:lat) { Faker::Address.latitude.to_s }
  let(:lng) { Faker::Address.longitude.to_s }
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
    it 'should create the target correctly' do
      expect { subject }.to change { Target.count }.by 1
    end

    it 'should have the correct lat' do
      expect(subject['lat']).to eq lat
    end

    it 'should have the correct lng' do
      expect(subject['lng']).to eq lng
    end

    it 'should have the correct title' do
      expect(subject['title']).to eq title
    end

    it 'should have the correct area length' do
      expect(subject['area_length']).to eq area_length
    end

    it 'should have the correct user id' do
      expect(subject['user_id']).to eq user.id
    end
  end

  context 'missing params' do
    let(:title) { nil }

    before { subject }

    it 'should return the error message' do
      expect(errors['title']).to include "can't be blank"
    end
  end
end
