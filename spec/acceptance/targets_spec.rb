require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Targets' do
  header 'access-token', :access_token_header
  header 'client', :client_header
  header 'uid', :uid_header

  let(:user) { create :user }

  before do
    2.times { create :target, user: user }
  end

  route '/targets', 'Targets collection' do
    get 'Index' do
      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end

    post 'Create' do
      with_options scope: :target, required: true do
        attribute :area_length, 'Area length'
        attribute :lat, 'Latitude'
        attribute :lng, 'Longitude'
        attribute :title, 'Title'
        attribute :topic_id, 'Topic ID'
      end

      with_options scope: :target, required: true do
        response_field :area_length, 'Area length'
        response_field :id, 'Target ID'
        response_field :lat, 'Latitude'
        response_field :lng, 'Longitude'
        response_field :title, 'Title'
        response_field :topic_id, 'Topic ID'
      end

      let(:topic) { create :topic }
      let(:target) { create :target, topic: topic }
      let(:area_length) { target.area_length }
      let(:lat) { target.lat }
      let(:lng) { target.lng }
      let(:title) { target.title }
      let(:topic_id) { target.topic_id }

      example 'Ok' do
        do_request

        expect(status).to eq 201
      end
    end
  end
end
