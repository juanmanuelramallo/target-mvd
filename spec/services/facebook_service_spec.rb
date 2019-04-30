require 'rails_helper'

RSpec.describe 'FacebookService' do
  let(:access_token) { 'EAAZAW69YHUAoBAAqdqz6O9woATHZCuSgVyaFc1U5p0MPr4hEdXbb4ZBw9EPbewlqymGbJbDD1oQt0ixAWa3hNRjuimCaHKEFYQqlIX1ltBXsZCVYSrgYRF62TbAxtlwW7SpCtoeTDg2FMZAC632QU1LlRVIf2V2fqAV0Exxx6VYmLSIRJyeGu4R7ccRRtMR4ZD' }
  subject { FacebookService.call!(access_token) }

  context 'creating a user' do
    it 'should return my newly created user' do
      VCR.use_cassette 'facebook_service/valid' do
        expect { subject }.to change { User.count }.by 1
      end
    end
  end

  context 'existing user' do
    let(:user) { create :user, email: 'existing-user@example.com' }

    before { user }

    it 'should return the existing user' do
      VCR.use_cassette 'facebook_service/valid' do
        expect(subject).to eq(user)
      end
    end
  end

  context 'invalid access token' do
    let(:access_token) { '123456' }

    it 'should raise an error' do
      VCR.use_cassette 'facebook_service/invalid' do
        expect { subject }.to raise_error(FacebookError)
      end
    end
  end
end
