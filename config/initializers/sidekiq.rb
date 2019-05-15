# frozen_string_literal: true

if Rails.env.production?
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV.fetch('REDISTOGO_URL') }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV.fetch('REDISTOGO_URL') }
  end
end
