# frozen_string_literal: true

require 'rails_helper'
require 'rake'

describe 'topics:seed' do
  subject { Rake.application.invoke_task 'topics:seed' }

  before do
    Rake.application.rake_require 'tasks/topics'
    Rake::Task.define_task(:environment)
  end

  it 'should create 9 topics' do
    expect { subject }.to change { Topic.count }.by 9
  end
end
