# frozen_string_literal: true

namespace :topics do
  desc 'Creates default topics'

  task seed: :environment do
    topic_names = %w[Football Travel Politics Art Dating Music Movies Series Food]
    print 'Creating topics'

    Topic.transaction do
      topic_names.each do |topic_name|
        Topic.create!(name: topic_name)
        print '.'
      end
    end

    puts "\n#{topic_names.size} topics created successfully!"
  end
end
