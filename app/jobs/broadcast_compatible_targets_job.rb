# frozen_string_literal: true

class BroadcastCompatibleTargetsJob < ApplicationJob
  queue_as :default

  def perform(target)
    target.compatible_users.each do |user|
      CompatibleTargetsChannel.broadcast_to(
        user,
        TargetSerializer.new(target).serialized_json
      )
    end
  end
end
