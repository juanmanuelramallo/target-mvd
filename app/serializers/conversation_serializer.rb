# frozen_string_literal: true

class ConversationSerializer < ApplicationSerializer
  attributes :id, :unread, :status

  belongs_to :initiator, serializer: :user
  belongs_to :target

  attribute :unread do |object, params|
    object.unread?(params[:current_user])
  end
end
