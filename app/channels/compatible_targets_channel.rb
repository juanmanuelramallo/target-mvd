# frozen_string_literal: true

class CompatibleTargetsChannel < ApplicationCable::Channel
  def subscribed
    stream_from current_user
  end
end
