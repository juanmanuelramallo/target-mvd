require 'rails_helper'

RSpec.describe 'Deleting a target', type: :request do
  let(:user) { create :user }

  subject { delete "/targets/#{target.id}", headers: headers }

  context 'user with target' do
    let(:target) { create :target, user: user }

    before { target }

    it 'should destroy the target correctly' do
      expect { subject }.to change { user.reload.targets.count }.by(-1)
    end
  end

  context 'passing a target id from a different user' do
    let(:target) { create :target }

    it "shouldn't destroy the target" do
      expect { subject }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
