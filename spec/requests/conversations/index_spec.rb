# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /conversations', type: :request do
  let(:user) { create :user_with_targets }

  subject do
    get '/conversations', headers: headers
    json_response
  end

  context 'without pagination' do
    before { create_list :conversation, 5, initiator: user }

    it 'returns my 5 conversations' do
      expect(subject['data'].size).to eq 5
    end
  end

  context 'pagination' do
    before { create_list :conversation, 25, initiator: user }
    let(:page_number) { 1 }
    let(:page_size) { 10 }

    subject do
      get "/conversations?page[number]=#{page_number}&page[size]=#{page_size}", headers: headers
      json_response
    end

    it 'returns the pagination links' do
      expect(subject['links'].keys).to eq %w[self first prev next last]
    end

    context 'asking for the third page' do
      let(:page_number) { 3 }

      it 'returns the last 5 conversations' do
        expect(subject['data'].size).to eq 5
      end
    end

    context 'asking for more items in a page' do
      let(:page_size) { 30 }

      it 'does not return the next page link' do
        expect(subject['links']['next']).to eq nil
      end
    end
  end

  context 'pagination and included param' do
    before { create_list :conversation, 25, initiator: user }
    let(:include_param) { 'target' }
    let(:page_number) { 2 }
    let(:page_size) { 5 }

    subject do
      get "/conversations?include=#{include_param}&page[number]=#{page_number}\
          &page[size]=#{page_size}", headers: headers
      json_response
    end

    it 'should return included data' do
      expect(subject['included']).to be_truthy
    end

    it 'should return links data' do
      expect(subject['links']).to be_truthy
    end
  end
end
