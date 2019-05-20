# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DisableConversationsJob, type: :job do
  include ActiveJob::TestHelper

  subject { described_class.perform_now(conversation_ids) }
  let(:conversations) { create_list :conversation, 3 }
  let(:conversation_ids) { conversations.pluck(:id) }

  it 'marks the conversations as disabled' do
    expect { subject }.to change { conversations.each(&:reload).pluck(:status) }
      .to(['disabled'] * 3)
  end
end
