# frozen_string_literal: true

class CompatibleTargetsChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end
end
