# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /compatible_targets', type: :request do
  let(:lat) { Faker::Address.latitude }
  let(:lng) { Faker::Address.longitude }
  let(:target) { create :target, user: user, lat: lat, lng: lng, area_length: 1000 }
  let(:user) { create :user }

  subject do
    get '/compatible_targets', headers: headers
    data
  end

  context 'user with compatible targets' do
    before do
      target
      3.times do
        create :target, topic: target.topic, area_length: rand(1000..5000), lat: lat + rand / 100,
                        lng: lng + rand / 100
      end
    end

    it 'should return 3 targets' do
      expect(subject.size).to eq 3
    end

    context 'user with several targets' do
      let(:another_target) do
        create :target, user: user, lat: lat + rand / 100, lng: lng + rand / 100,
                        area_length: 10_000
      end

      before { another_target }

      it 'should return 3 targets' do
        expect(subject.size).to eq 3
      end
    end
  end

  context 'user without compatible targets' do
    before do
      target
      3.times do
        create :target, topic: target.topic, area_length: rand(1000..2000), lat: lat + rand(10),
                        lng: lng + rand(10)
      end
    end

    it 'should return an empty array' do
      expect(subject.size).to eq 0
    end
  end
end
