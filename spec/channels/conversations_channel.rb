# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConversationsChannel, type: :channel do
  let(:conversation) { create :conversation }
  let(:user) { conversation.initiator }

  context 'with user signed in' do
    subject { subscription }

    before :each do
      stub_connection current_user: user, params: { id: conversation.id }
      subscribe
    end

    it { is_expected.to be_confirmed }
    it { is_expected.to have_stream_for(conversation) }
  end
end
