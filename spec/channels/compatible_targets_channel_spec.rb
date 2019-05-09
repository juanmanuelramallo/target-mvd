# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompatibleTargetsChannel, type: :channel do
  let(:user) { create :user }

  context 'with user signed in' do
    subject { subscription }

    before :each do
      stub_connection current_user: user
      subscribe
    end

    it { is_expected.to be_confirmed }
    it { is_expected.to have_stream_for(user) }
  end
end
