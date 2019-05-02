require 'rails_helper'

RSpec.describe 'FrontendUrlService' do
  it 'should return the confirmation url for the frontend' do
    expect(FrontendUrlService.confirmed_url).to eq 'http://localhost:3001/users/confirmed'
  end
end
