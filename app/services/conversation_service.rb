# frozen_string_literal: true

class ConversationService
  attr_reader :current_user, :initiator_id, :target_id

  def self.call(args)
    new(args).build
  end

  def initialize(args)
    @current_user = args[:current_user]
    @initiator_id = args[:initiator_id].to_i
    @target_id = args[:target_id]
  end

  def build
    raise ConversationNotAllowedError unless valid?

    Conversation.first_or_initialize target_id: target_id, initiator_id: initiator_id
  end

  private

  def valid?
    current_user.id == initiator_id || current_user.targets.include?(target)
  end

  def target
    @target ||= Target.find target_id
  end
end
