# frozen_string_literal: true

class ConversationSerializer < ApplicationSerializer
  attributes :id, :status
  attribute :unread do |object, args|
    object.unread?(args[:current_user])
  end

  belongs_to :initiator, serializer: UserSerializer
  belongs_to :target
end
