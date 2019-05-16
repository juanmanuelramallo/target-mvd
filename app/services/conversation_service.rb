# frozen_string_literal: true

class ConversationService
  attr_reader :current_user, :target_id

  def self.call(args)
    new(args).build
  end

  def initialize(args)
    @current_user = args[:current_user]
    @target_id = args[:target_id]
  end

  def build
    raise ConversationWithSameUserError unless valid?

    Conversation.new target_id: target_id, initiator_id: current_user.id
  end

  private

  def valid?
    !current_user.targets.include?(target)
  end

  def target
    @target ||= Target.find target_id
  end
end
