# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BroadcastCompatibleTargetsJob, type: :job do
  include ActiveJob::TestHelper

  subject { described_class.perform_now(target) }

  let(:lat) { Faker::Address.latitude }
  let(:lng) { Faker::Address.longitude }
  let(:serialized_target) { ActiveModelSerializers::SerializableResource.new(target).as_json }
  let(:target) { create :target, topic: topic, lat: lat, lng: lng, area_length: 1500 }
  let(:topic) { create :topic }

  context 'new target with compatible targets' do
    let(:compatible_target) do
      create :target, topic: topic, area_length: 2000, lat: lat + 0.001,
                      lng: lng + 0.001
    end

    before do
      compatible_target
    end

    it 'broadcasts to the users with compatible targets' do
      expect { subject }.to have_broadcasted_to(compatible_target.user)
        .from_channel(CompatibleTargetsChannel)
        .with(serialized_target)
    end
  end

  context 'new target without compatible targets' do
    let(:another_target) { create :target, lat: lat + 1, lng: lng + 1, area_length: 1000 }

    before do
      target
      another_target
    end

    it "doesn't broadcast to any user" do
      expect { subject }.to_not have_broadcasted_to(another_target.user)
        .from_channel(CompatibleTargetsChannel)
        .with(target: serialized_target)
    end
  end
end
